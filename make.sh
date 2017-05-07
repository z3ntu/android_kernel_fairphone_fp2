#!/bin/bash

# Guide:
# 1. Run ./make.sh config [configfile]
# 2. Run ./make.sh <nr-of-cpu-cores>
# 3. Enjoy your arch/arm/boot/zImage!

prebuiltloc=/home/luca/android/prebuilt

# Linaro toolchain
# Get the toolchain from http://releases.linaro.org/archive/14.06/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux.tar.xz
# Note: It probably won't work!
#toolchain=gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux
#crossprefix=arm-linux-gnueabihf-

# AOSP toolchain
# Clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 into $prebuildloc
toolchain=arm-linux-androideabi-4.9
crossprefix=arm-linux-androideabi-

# Define the help function
function help() {
cat <<EOF
Usage:
1. Run $0 config [configfile]
2. Run $0 <nr-of-cpu-cores>
3. Enjoy your arch/arm/boot/zImage!
EOF
exit 0
}

# Show help
if [ "$1" = "--help" ]; then
    help
fi

echo 'Setting important variables'
export ARCH=arm
export SUBARCH=arm

# "ln -s /usr/bin/python2 ./python" in that folder.
export PATH=$prebuiltloc/compat:$PATH

export CROSS_COMPILE=$prebuiltloc/$toolchain/bin/$crossprefix

# Make sure build is clean!
echo 'Cleaning up.'
make clean

# Generates a new .config and exits
if [ "$1" = "config" ]; then
    config=$2
    if [ ! $config ]; then
        config=lineageos_fp2_defconfig
    fi
    echo "Running 'make $config'"
    make "$config"
    exit
fi

if [ "$1" = "menuconfig" ]; then
    echo "Running 'make menuconfig'"
    make menuconfig
    exit
fi

# Checks if $1 is a number.
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
    help
fi

# Compile
echo 'Start the compilation.'
make -j$1 CONFIG_DEBUG_SECTION_MISMATCH=y
