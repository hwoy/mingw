#!/bin/sh

source ../0_append_distro_path.sh

SNAME=zstd
SVERSION=1.5.2

decompress()
{
	untar_file ${SNAME}-${SVERSION}.tar.gz
}

prepare()
{
	cd patch
	apply_patch_p1 zstd-1.4.0-fileio-mingw.patch
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
		"-DCMAKE_C_FLAGS=-s -O2" \
		"-DCMAKE_INSTALL_PREFIX=${X_BUILDDIR}/dest" \
		"-DZSTD_BUILD_SHARED=ON" \
		-G "Ninja" ${X_BUILDDIR}/src/build/cmake

	ninja -j${JOBS}
	ninja install
	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}
	cd ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}
	#rm -rf bin/zstdgrep bin/zstdless lib/cmake lib/pkgconfig share
	#for i in bin/unzstd bin/zstdcat bin/zstdmt; do mv $i $i.exe; done

	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}.7z

}

decompress

prepare

build
