#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

cat 0_append_distro_path.sh | grep "#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}" && sed 's/#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/1' 0_append_distro_path.sh -i

cd utils
source ../0_append_distro_path.sh
source ../BUILD_COMMON.sh
cd ..

rm -rf ${STAGE23}
mkdir -p ${STAGE23}


buildpkg S2.0001.mingw-headers-w64 64.mingw-w64-headers.sh ${STAGE23}

buildpkg S2.0002.mingw-crt-w64 64.mingw-w64-crt.sh ${STAGE23}

buildpkg S2.0003.mingw-winpthreads-w64 64.mingw-w64-winpthreads.sh ${STAGE23}

buildpkg S2.0004.zstd 64.zstd.sh ${STAGE23}

buildpkg S2.0005.zlib 64.zlib.sh ${STAGE23}

buildpkg S2.0006.libiconv 64.libiconv.sh ${STAGE23}

buildpkg S2.0007.gcc 64.gcc.sh ${STAGE23}

buildpkg S2.0008.binutils 64.binutils.sh ${STAGE23}

buildpkg S3.0001.mingw-libmangle-w64 64.mingw-w64-libmangle.sh ${STAGE23}

buildpkg S3.0002.mingw-tools-w64 64.mingw-w64-tools.sh ${STAGE23}

buildpkg S3.0003.mingw-winstorecompat-w64 64.mingw-w64-winstorecompat.sh ${STAGE23}

buildpkg S3.0004.make 64.make.sh ${STAGE23}
