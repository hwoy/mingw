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
	apply_patch_p1 Define-__-de-register_frame_info-in-fake-libgcc_s.patch
  cd ..
  
}

build()
{
	
	cd ${X_BUILDDIR}

	# Build mingw-w64 and winpthreads.
	MINGW_PARAM="--enable-lib32 --disable-lib64"
	mv ${SNAME}-${SVERSION} src
	mkdir build dest

  _tools="gendef genlib genidl genpeimg widl" # genstubdll
  local cur=
  for cur in ${_tools}; do
  rm -rf build
  mkdir build
  cd build
    ../src/mingw-w64-tools/${cur}/configure \
	--build=${X_BUILD} --host=${X_HOST} --target=${X_HOST} \
	--prefix=${X_BUILDDIR}/dest \
	${MINGW_PARAM}
    make $X_MAKE_JOBS
	make install
    cd ..
  done
	# https://github.com/msys2/MINGW-packages/issues/7043

	# The headers must be built first. See: https://github.com/StephanTLavavej/mingw-distro/issues/64

	#make $X_MAKE_JOBS all "CFLAGS=-s -O2"
	#make  install

	# Cleanup.
	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-tools-${SVERSION}-${X_HOST}
	cd ${SNAME}-tools-${SVERSION}-${X_HOST}
	mv ${X_HOST}/bin ./
	
	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-tools-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}.7z

}

decompress

prepare

build
