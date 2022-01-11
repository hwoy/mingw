#!/bin/sh

source ../0_append_distro_path.sh

SNAME=mingw-w64
SVERSION=v9.0.0

# Extract vanilla sources.

decompress()
{

	untar_file ${SNAME}-${SVERSION}.tar.bz2
}


prepare()
{
:;
}


build()
{
	
	cd ${X_BUILDDIR}

	# Build mingw-w64 and winpthreads.
	MINGW_PARAM="--disable-lib32 --enable-lib64"
	mv ${SNAME}-${SVERSION} src
	mkdir build dest
	cd build

	../src/mingw-w64-libraries/libmangle/configure \
	--build=${X_BUILD} --host=${X_HOST} --target=${X_HOST} \
	--prefix=${X_BUILDDIR}/dest \
	${MINGW_PARAM}
	
	# https://github.com/msys2/MINGW-packages/issues/7043

	# The headers must be built first. See: https://github.com/StephanTLavavej/mingw-distro/issues/64
	make $X_MAKE_JOBS all
	make  install

	#make $X_MAKE_JOBS all "CFLAGS=-s -O2"
	#make  install

	# Cleanup.
	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-libmangle-${SVERSION}-${X_HOST}
	cd ${SNAME}-libmangle-${SVERSION}-${X_HOST}
	
	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-libmangle-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}.7z

}

decompress

prepare

build
