#!/bin/sh
source ../0_append_distro_path_32.sh

SNAME=libtool
SVERSION=2.4.6

decompress()
{
	untar_file ${SNAME}-${SVERSION}.tar
}

prepare()
{
:;
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
	--with-sysroot=${X_BUILDDIR}/dest
	
	make "CFLAGS=-s -O2"
	make install

	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-${SVERSION}
	cd ${SNAME}-${SVERSION}
	

	zip7 ${SNAME}-${SVERSION}-${X_TARGET}.7z

}

decompress

prepare

build