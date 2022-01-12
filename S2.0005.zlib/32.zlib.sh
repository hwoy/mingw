#!/bin/sh

source ../0_append_distro_path_32.sh

SNAME=zlib
SVERSION=1.2.11

decompress()
{
	untar_file v${SVERSION}.tar.gz
}

prepare()
{
	cd patch

	apply_patch_p1 01-zlib-1.2.11-1-buildsys.mingw.patch
	apply_patch_p2 03-dont-put-sodir-into-L.mingw.patch
	apply_patch_p1 04-fix-largefile-support.patch

	cd ..
}

build()
{
	cd ${X_BUILDDIR}
	mv ${SNAME}-${SVERSION} src
	mkdir build dest
	cd build

	cmake \
		"-DCMAKE_BUILD_TYPE=Release" \
		"-DCMAKE_C_FLAGS=-s -O2 -DTOO_FAR=32767" \
		"-DCMAKE_INSTALL_PREFIX=${X_BUILDDIR}/dest" \
		-G "Ninja" ${X_BUILDDIR}/src

	ninja ${X_B2_JOBS}
	ninja install
	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}
	cd ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}
	#rm -rf bin/zstdgrep bin/zstdless lib/cmake lib/pkgconfig share
	#for i in bin/unzstd bin/zstdcat bin/zstdmt; do mv $i $i.exe; done

	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}.7z

}

decompress

prepare

build
