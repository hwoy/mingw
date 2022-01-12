#!/bin/sh
source ../0_append_distro_path_32.sh

SNAME=libiconv
SVERSION=1.16

decompress()
{
	untar_file ${SNAME}-${SVERSION}.tar.gz
}

prepare()
{
	cd patch

	apply_patch_p1 0001-compile-relocatable-in-gnulib.mingw.patch
	apply_patch_p1 0002-fix-cr-for-awk-in-configure.all.patch
	apply_patch_p1 fix-pointer-buf.patch

	cd ..
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
		--target==${X_TARGET} \
		--prefix=${X_BUILDDIR}/dest \
		--enable-static \
		--enable-shared \
		--enable-extra-encodings \
		--enable-relocatable \
		--disable-rpath \
		--enable-silent-rules \
		--enable-nls

	make $X_MAKE_JOBS all
	make install

	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}
	cd ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}

	#remove binary
	rm -rf bin/*.exe

	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}.7z

}

decompress

prepare

build
