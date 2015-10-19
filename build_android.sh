#!/bin/bash
NDK_BASE=${ANDROID_NDK}


# Android now has 64-bit and 32-bit versions of the NDK for GNU/Linux.  We
# assume that the build platform uses the appropriate version, otherwise the
# user building this will have to manually set NDK_PROCESSOR or NDK_TOOLCHAIN.
if [ $(uname -m) = "x86_64" ]; then
    NDK_PROCESSOR=x86_64
else
    NDK_PROCESSOR=x86
fi

# Android NDK setup
NDK_PLATFORM_LEVEL=16
# arm or x86
NDK_ABI=x86
NDK_COMPILER_VERSION=4.9
NDK_UNAME=`uname -s | tr '[A-Z]' '[a-z]'`
if [ $NDK_ABI = "x86" ]; then
    ARCH=i686
    HOST=$ARCH-linux-android
    NDK_TOOLCHAIN=$NDK_ABI-$NDK_COMPILER_VERSION
    ADDI_CFLAGS="-march=$ARCH"
#elif [ $NDK_ABI = "mips" ]; then
#    ARCH=${NDK_ABI}el
#    HOST=${ARCH}-linux-android
#    NDK_TOOLCHAIN=$HOST-$NDK_COMPILER_VERSION
#    ADDI_CFLAGS="-march=$ARCH"
else
    ARCH=$NDK_ABI
    HOST=$NDK_ABI-linux-androideabi
    NDK_TOOLCHAIN=$HOST-$NDK_COMPILER_VERSION
    ADDI_CFLAGS="-m$ARCH"
fi


NDK_SYSROOT=$NDK_BASE/platforms/android-$NDK_PLATFORM_LEVEL/arch-$NDK_ABI/
NDK_TOOLCHAIN_BASE=$NDK_BASE/toolchains/$NDK_TOOLCHAIN/prebuilt/$NDK_UNAME-$NDK_PROCESSOR
# NDK_SYSROOT=$NDK_BASE/platforms/android-16/arch-arm/
# NDK_TOOLCHAIN_BASE=$NDK_BASE/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
echo $NDK_SYSROOT
echo $NDK_TOOLCHAIN_BASE
function build_one
{
./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-gpl \
    --enable-avresample \
    --disable-asm \
    --disable-static \
    --disable-stripping \
    --disable-ffprobe \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffserver \
    --disable-debug \
    --cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$HOST- \
    --target-os=linux \
    --arch=$ARCH \
    --enable-cross-compile \
    --enable-runtime-cpudetect \
    --sysroot=$NDK_SYSROOT \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}
CPU=$NDK_ABI
PREFIX=$(pwd)/android/$CPU
ADDI_CFLAGS="-marm"
build_one
#cd ../app/src/main
#./build.sh