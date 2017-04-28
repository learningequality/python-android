# python-android
python build for kolibri-android-wrapper

To generete the python build `python_27.zip` and `python_extras_27.zip`, run the following commands:
```
sudo docker build -t androidpython .
container_id=`sudo docker create androidpython`
sudo docker cp $container_id:/python-android27/python_27.zip . 
sudo docker cp $container_id:/python-android27/python_extras_27.zip .
```

-------

Current progress:
1. Able to generate a minimum PIE enabled python_27.zip, meaning when install on android, we can bring up the interactive python via adb, but lack some python libs to start Kolibri.
2. Not able to generate python_extras_27.zip yet, still working on it.

-------

# Tips:

* how to bring up interactive python via adb:
```
cd <path_to_your_sdk>/platform-tools
./adb shell
run-as com.android.kolibri27
export PYTHONHOME=/data/data/com.android.kolibri27/files/python
export PYTHONPATH=/sdcard/com.android.kolibri27/extras/python:/data/data/com.android.kolibri27/files/python/lib/python2.7/lib-dynload:/data/data/com.android.kolibri27/files/python/lib/python2.7
export PATH=$PYTHONHOME/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/data/com.android.kolibri27/files/python/lib:/data/data/com.android.kolibri27/files/python/lib/python2.7/lib-dynload
python
```

-------

Reference:
    http://code.google.com/p/python-for-android/

./bootstrap.sh

    Downloads Python-2.7.2 source
    patches Python for android
    builds hostpython and hostpgen

./build.sh

    builds python library for android

./package.sh

    creates python_rxx.zip and python_extras_rxx.zip

./pip_install.sh

    install python packages using pip.

    example:

        ./pip_install.sh python-twitter

-------

# Eli's journey

1. I installed the following packages:
    ```
    sudo apt-get install build-essential bison flex autoconf automake autotools-dev quilt libcurl3 curl openssh-server ant mercurial filezilla pure-ftpd dpatch texinfo libncurses5-dev libgmp3-dev libmpfr-dev gawk patchutils binutils-dev zlib1g-dev 
    ```
    and
    ```
    sudo apt-get install git-core gnupg gperf libc6-dev x11proto-core-dev libx11-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc libreadline-dev libreadline6 ia32-libs-multiarch libzip-dev libzip-dev libzzip-dev libzzip-0-13
    ```
2. I'm using ubuntu ubuntu-14.04.5-desktop-amd64.iso (64-bit)
3. With gcc-4.8
4. [android-ndk-r13b](https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip)
5. [andriod-sdk-linux](https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz)
6. the `site.py` file inside `python_extras_27.zip` won't work, a work around for now is to replace it with the `site.py` from `android-python27` project.


7. Under `android-ndk-r13b/toolchains/` need to rename everything to `something-4.4.3`
8. Under `android-ndk-r13b/toolchains/x86_64-4.4.3/prebuilt/linux-x86_64/bin/` need to rename `x86_64-linux-android-gcc` to `x86_64-gcc`; `x86_64-linux-android-g++` to `x86_64-g++`; `x86_64-linux-android-strip` to `x86_64-strip`
9. Under `android-ndk-r13b/toolchains/aarch64-linux-android-4.4.3/prebuilt/linux-x86_64/bin/` need to rename `aarch64-linux-android-g++` to `aarch64-g++`; `aarch64-linux-android-gcc` to `aarch64-gcc`; `aarch64-linux-android-strip` to `aarch64-strip`
10. Make `openssl/AndroidManifest.xml` minSdkVersion=24
11. In order to compile openssl successfully and generate `libcrypt.so`, `libcrypto.so`, `libsqlite3.so`, `libssl.so` that are required to run python on android, we need to modify `android-ndk-r13b/build/core/default-build-commands/mk`, find around line 113 and change to `TARGET_LDLIBS:= -lz -lc -lm`. After we got thoese share libraries, restore the change to `TARGET_LDLIBS:= -lc -lm`, and continue to build the python. It's a bit tricky to get both python and these shared libraries built at one shoot. Sometimes you may want to prepare two envirenment to build them separately.


Note: In Ubuntu, `sudo apt-get install hardening-includes` and use its `hardening-check <file path>` to check position independent code.

-------


current status:

    Python build finished, but the necessary bits to build these modules were not found:

    _bsddb             _curses            _curses_panel
    _tkinter           bsddb185           bz2
    dbm                dl                 gdbm
    imageop            linuxaudiodev      nis
    ossaudiodev        readline           sunaudiodev

    To find the necessary bits, look in setup.py in detect_modules() for the module's name.


    Failed to build these modules:
    
    _ctypes_test       _locale            audioop
    grp                spwd
