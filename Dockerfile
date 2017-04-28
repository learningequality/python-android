# ** generate python_27.zip and python_extras_27.zip **

# ubuntu 14 should come with gcc-4.8, if not, and the build failed, can try install gcc-4.8
FROM ubuntu:14.04.5

# Copy python-android27 into the container
ADD /python-android27/. /python-android27

# install libs
RUN apt-get update
RUN sudo apt-get install -y build-essential bison flex autoconf automake autotools-dev quilt libcurl3 curl \
    openssh-server ant mercurial filezilla pure-ftpd dpatch texinfo libncurses5-dev libgmp3-dev libmpfr-dev \
    gawk patchutils binutils-dev zlib1g-dev git-core gnupg gperf libc6-dev x11proto-core-dev libx11-dev \
    libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc libreadline-dev \
    libreadline6 libzip-dev libzip-dev libzzip-dev libzzip-0-13 \
    wget unzip zip
# work around for not being able to install ia32-libs-multiarch on ubuntu 14
RUN sudo dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386

# get the right version of NDK and SDK
RUN wget https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip
RUN wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN unzip android-ndk-r13b-linux-x86_64.zip
RUN tar -xvzf android-sdk_r24.4.1-linux.tgz

# 1. run bootstrap.sh
WORKDIR /python-android27
RUN /python-android27/bootstrap.sh

# modify source files
RUN sed -i '6s@.*@<uses-sdk android:minSdkVersion="24" />@' /python-android27/openssl/AndroidManifest.xml
RUN sed -i '113s@.*@TARGET_LDLIBS := -lz -lc -lm@' /android-ndk-r13b/build/core/default-build-commands.mk

# elielieli
RUN apt-get install -y hardening-includes

# 2. run build.sh
RUN /python-android27/build.sh

# 6. run package.sh to zip compiled python into python_27.zip and python_extras_27.zip
RUN /python-android27/package.sh
