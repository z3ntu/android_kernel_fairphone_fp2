#!/bin/bash

# Guide:
# 1. Run ./make.sh config
# 2. Run ./make.sh <nr-of-cpu-cores>
# 3. Enjoy your arch/arm/boot/zImage!

# Exports all the needed things Arch, SubArch and Cross Compile
export ARCH=arm
echo 'exporting Arch'
export SUBARCH=arm
echo 'exporting SubArch'

# "ln -s /usr/bin/python2 ./python" in that folder.
export PATH=/home/luca/android/prebuilt/compat:$PATH
# Get the toolchain from http://releases.linaro.org/archive/14.06/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux.tar.xz
# Note that gcc 4.9.1 is confirmed to work but 4.9.4 is throwing kernel section mismatches.
export CROSS_COMPILE=/home/luca/android/prebuilt/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux/bin/arm-linux-gnueabihf-
echo 'exporting Cross Compile'

# Make sure build is clean!
echo 'Cleaning build'
make clean

# Generates a new .config and exits
if [ "$1" = "config" ] ; then
    echo 'Making defconfig for fp2'
    make lineageos_fp2_defconfig
    exit
fi

# Lets go!
echo 'Lets start!'
make -j$1
