#!/bin/sh

source ../0_append_distro_path_32.sh

SNAME=mingw-w64
SVERSION=v9.0.0

# Extract vanilla sources.

decompress()
{

	untar_file ${SNAME}-${SVERSION}.tar.bz2
}

prepare()
{
	cd patch
	apply_patch_p1 \
	0001-Allow-to-use-bessel-and-complex-functions-without-un.patch \
	0002-DirectX-9-fixes-for-VLC.patch
	
  cd ..
  
}

build()
{
	
	cd ${X_BUILDDIR}

	# Build mingw-w64 and winpthreads.
	MINGW_PARAM="--enable-lib32 --disable-lib64"
	mv ${SNAME}-${SVERSION} src
	mkdir build dest
	cd build

	../src/mingw-w64-crt/configure --build=${X_BUILD} --host=${X_HOST} --target=${X_TARGET} \
	--prefix=${X_BUILDDIR}/dest/${X_HOST}  \
	--enable-wildcard \
    --with-sysroot=${X_BUILDDIR}/dest/${X_HOST} \
    --with-default-msvcrt=${_default_msvcrt} \
	--enable-shared --enable-static --with-tools=all \
	--enable-sdk=all \
	--disable-dependency-tracking \
	${MINGW_PARAM}

	# The headers must be built first. See: https://github.com/StephanTLavavej/mingw-distro/issues/64
	make $X_MAKE_JOBS all
	make  install

	#make $X_MAKE_JOBS all "CFLAGS=-s -O2"
	#make  install

	# Cleanup.
	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-crt-${SVERSION}-${X_HOST}
	cd ${SNAME}-crt-${SVERSION}-${X_HOST}
	
	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-crt-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}.7z

}

decompress

prepare

build
