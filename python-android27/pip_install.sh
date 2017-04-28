#!/usr/bin/env sh

export ROOTDIR="/python-android27"
export HOSTPYTHON=$ROOTDIR/hostpython
export HOSTPGEN=$ROOTDIR/hostpgen

export NDK="/android-ndk-r13b" #change this to point to your NDK folder
export SDK="/android-sdk-linux" #change this to point to your SDK folder
export NDKPLATFORM="$NDK/platforms/android-24/arch-arm"

export PATH="$NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86_64/bin/:$NDK:$SDK/tools:$PATH"
export PATH="$ROOTDIR/prebuilt:$PATH"

export PYVERSION="2.7.2"

export ARCH="armeabi"
#export ARCH="armeabi-v7a"

# to override the default optimization, set OFLAG
#export OFLAG="-Os"
#export OFLAG="-O2"

export CFLAGS="-fPIC -mandroid $OFLAG -fomit-frame-pointer --sysroot $NDKPLATFORM -DNO_MALLINFO=1 -I$ROOTDIR/build/include/python2.7"
#if [ $ARCH == "armeabi-v7a" ]; then
#    CFLAGS+=" -march=armv7-a -mfloat-abi=softfp -mfpu=vfp -mthumb"
#fi
export CXXFLAGS="$CFLAGS"

export CC="arm-linux-androideabi-gcc $CFLAGS"
export CXX="arm-linux-androideabi-g++ $CXXFLAGS"
export AR="arm-linux-androideabi-ar"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip --strip-unneeded"
export BLDSHARED="arm-linux-androideabi-gcc -shared $CFLAGS"
export LDSHARED="$ROOTDIR/ldshared"
export MAKE="make -j4"
export LDFLAGS="-fPIE -pie"

export PYTHONHOME="$ROOTDIR/prebuilt"
export PYTHONPATH="$PYTHONHOME:$PYTHONHOME/lib/python2.7"
export LD_LIBRARY_PATH="$PYTHONHOME/lib/python2.7/lib-dynload"
export PATH="$PYTHONHOME/bin:$PATH"

export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

pip install \
    --install-option="--prefix=$VIRTUAL_ENV" \
    $@
