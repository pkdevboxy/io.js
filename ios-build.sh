#!/bin/sh

PREFIX="/usr"
NAME="iojs-ios"
DESTDIR="/tmp/$NAME"

if [ ! -f src/node.cc ]; then
	echo run this script from iojs root directory
	exit 1
fi

export CC="xcrun --sdk iphoneos gcc -arch armv7"
export CXX="xcrun --sdk iphoneos g++ -arch armv7 -std=c++11"
export LINK="xcrun --sdk iphoneos g++ -arch armv7"

export IPHONEOS_DEPLOYMENT_TARGET=8.3

CPU=arm
#CPU=arm64

# build iojs
cp -f deps/cares/config/darwin/ares_config.h deps/cares/include/
./configure --prefix=/usr --dest-os=ios --dest-cpu=${CPU} --without-snapshot \
		     --openssl-no-asm \
	--without-dtrace --without-perfctr --without-etw || exit 1
make -j4 || exit 1

# install iojs
make install DESTDIR="${DESTDIR}" || exit 1

# install npm
#cd deps/npm
#./configure --prefix=/usr
#make install DESTDIR="${DESTDIR}"

cd $DESTDIR
tar czvf ../$NAME.tar.gz *
