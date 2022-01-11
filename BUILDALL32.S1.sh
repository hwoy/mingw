#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

cat 0_append_distro_path_32.sh | grep "#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}" || sed 's/export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/1' 0_append_distro_path_32.sh -i

cd utils

source ../0_append_distro_path_32.sh
source ../BULD_COMMON.sh
cd ..


rm -rf ${STAGE1}
mkdir -p ${STAGE1}

buildpkg S1.0001.binutils 32.binutils.sh ${STAGE1}

buildpkg S1.0002.gcc 32.gcc.sh ${STAGE1}

