#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

cat 0_append_distro_path.sh | grep "#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}" && sed 's/#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/1' 0_append_distro_path.sh -i

cd utils
source ../0_append_distro_path.sh
cd ..

finish()
{
	sh utils/INSTALL.sh ${X_BUILDDIR} $(dirname ${NEW_DISTRO_ROOT})

	cd ${DIR}

	mv ${X_BUILDDIR}/*.7z ${STAGE23}

	rm -rf ${X_BUILDDIR}/*
}

rm -rf ${STAGE23}
mkdir -p ${STAGE23}

cd S2.0001.mingw-headers-w64
sh 64.mingw-w64-headers.sh
cd ..
finish

cd S2.0002.mingw-crt-w64
sh 64.mingw-w64-crt.sh
cd ..
finish

cd S2.0003.mingw-winpthreads-w64
sh 64.mingw-w64-winpthreads.sh
cd ..
finish

cd S2.0004.zstd
sh 64.zstd.sh
cd ..
finish

cd S2.0005.zlib
sh 64.zlib.sh
cd ..
finish

cd S2.0006.gcc
sh 64.gcc.sh
cd ..
finish

cd S2.0007.binutils
sh 64.binutils.sh
cd ..
finish

cd S3.0002.make
sh 64.make.sh
cd ..
finish
