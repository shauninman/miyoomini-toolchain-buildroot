#!/bin/sh

set -x

TOOLCHAIN_VERSION=8.3-2019.03
TOOLCHAIN_NAME="gcc-arm-$TOOLCHAIN_VERSION-x86_64-arm-linux-gnueabihf"
TOOLCHAIN_TAR="$TOOLCHAIN_NAME.tar.xz"
TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu-a/$TOOLCHAIN_VERSION/binrel/$TOOLCHAIN_TAR"
BUILDROOT_DL="/root/buildroot/dl/toolchain-external-arm-arm/$TOOLCHAIN_TAR"

cd ~
if [ ! -f "./$TOOLCHAIN_TAR" ]; then
	if [ -f "$BUILDROOT_DL" ]; then
		cp "$BUILDROOT_DL" ./
	else
		wget "$TOOLCHAIN_URL"
	fi
fi

tar xf "./$TOOLCHAIN_TAR"
mv $TOOLCHAIN_NAME miyoomini-toolchain

ln -rs ./miyoomini-toolchain ./miyoomini-toolchain/usr
ln -rs ./miyoomini-toolchain/arm-linux-gnueabihf/libc ./miyoomini-toolchain/arm-linux-gnueabihf/sysroot

cd ~
if [ ! -d "./my283" ]; then
	tar xf my283.tar.xz
fi
rsync -a /root/my283/ ./miyoomini-toolchain/arm-linux-gnueabihf/sysroot/
rsync -a --ignore-existing /root/buildroot/output/host/arm-buildroot-linux-gnueabihf/sysroot/ ./miyoomini-toolchain/arm-linux-gnueabihf/sysroot/
find ./miyoomini-toolchain -type f -name ".*" -delete

# NOTE: xz takes forever but produces a toolchain half the size of gzip
tar --xz -cvf miyoomini-toolchain.tar.xz miyoomini-toolchain/
mv ./miyoomini-toolchain.tar.xz ~/workspace/
rm -rf miyoomini-toolchain
