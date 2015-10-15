#!/bin/bash
NDK=${ANDROID_NDK}
SYSROOT=$NDK/platforms/android-16/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
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
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --enable-runtime-cpudetect \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}
CPU=arm
PREFIX=$(pwd)/android/$CPU
ADDI_CFLAGS="-marm"
build_one