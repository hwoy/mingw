#!/bin/sh

source ./0_append_distro_path.sh

untar_file SDL2-2.0.16.tar
untar_file libogg-1.3.5.tar
untar_file libvorbis-1.3.7.tar
untar_file SDL2_mixer-2.0.4.tar --exclude=SDL2_mixer-2.0.4/Xcode
untar_file vorbis-tools-1.4.2.tar

cd /c/temp/gcc

mv SDL2-2.0.16 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src

mv libogg-1.3.5 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src

mv libvorbis-1.3.7 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src

mv SDL2_mixer-2.0.4 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src

mv vorbis-tools-1.4.2 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf bin/sdl2-config lib/cmake lib/pkgconfig lib/*.la share

7z -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
