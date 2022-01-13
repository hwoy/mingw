#!/bin/sh

source ../0_append_distro_path.sh

SNAME=make
SVERSION=4.3

decompress()
{
	untar_file ${SNAME}-${SVERSION}.tar.gz
}

prepare()
{
	cd patch
	apply_patch_p0 0001-make-4.3-FixMinw32.diff
	cd ..
}

build()
{
	cd ${X_BUILDDIR}
	mkdir -p dest/bin

	mv ${SNAME}-${SVERSION} src
	cd src
	# " /c" works around https://github.com/msys2/MSYS2-packages/issues/1606
	cmd " /c" "build_w32.bat" "gcc"
	strip -s GccRel/gnumake.exe
	# mingw32-make.exe is for CMake.
	mv GccRel/gnumake.exe ../dest/bin/mingw32-make.exe
	cd ${X_BUILDDIR}
	rm -rf src

	mv dest ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}
	cd ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}

	rm -rf ../${PROJECTNAME}
	mkdir ../${PROJECTNAME}
	mv * ../${PROJECTNAME}
	mv ../${PROJECTNAME} ./
	zip7 ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}.7z

}

decompress

prepare

build