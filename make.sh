#!/bin/bash

# Guide:
# 1. Run ./make.sh config [configfile]
# 2. Run ./make.sh <nr-of-cpu-cores>
# 3. Enjoy your arch/arm/boot/zImage!

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
export PATH=/home/luca/android/prebuilt/compat:$PATH
# Get the toolchain from http://releases.linaro.org/archive/14.06/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux.tar.xz
# Note that gcc 4.9.1 is confirmed to work but 4.9.4 is throwing kernel section mismatches.
export CROSS_COMPILE=/home/luca/android/prebuilt/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux/bin/arm-linux-gnueabihf-

# Make sure build is clean!
echo 'Cleaning up.'
make clean

# Generates a new .config and exits
if [ "$1" = "config" ] ; then
    config=$2
    if [ ! $config ]; then
        config=lineageos_fp2_defconfig
    fi
    echo "Running 'make $config'"
    make "$config"
    exit
fi

# Checks if $1 is a number.
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
    help
fi

# Compile
echo 'Start the compilation.'
make -j$1
