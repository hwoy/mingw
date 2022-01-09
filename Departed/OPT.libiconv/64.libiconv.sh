#!/bin/sh
source ../0_append_distro_path.sh

SNAME=libiconv
SVERSION=1.16

decompress()
{
	untar_file ${SNAME}-${SVERSION}.tar
}

prepare()
{
	patch -d ${X_BUILDDIR}/${SNAME}-${SVERSION} -p1 < 1.14-cross-install.patch
	patch -d ${X_BUILDDIR}/${SNAME}-${SVERSION} -p1 < libiconv-1.16-msysize.patch
}

build()
{
	cd ${X_BUILDDIR}
	mv ${SNAME}-${SVERSION} src
	mkdir build dest
	cd build
	
	../src/configure \
	--build=${X_BUILD} \
	--host=${X_HOST} \
	--prefix=${X_BUILDDIR}/dest \
	--with-sysroot=${X_BUILDDIR}/dest \
	--disable-libintl \
	--disable-libiconv \
    --disable-static \
    --enable-shared \
    --enable-extra-encodings
	
	make $X_MAKE_JOBS all "CFLAGS=-s -O2"
	make $X_MAKE_JOBS install

	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-${SVERSION}
	cd ${SNAME}-${SVERSION}
	
	#remove binary
	rm -rf bin/*.exe

	zip7 ${SNAME}-${SVERSION}-${X_TARGET}.7z

}

decompress

prepare

build