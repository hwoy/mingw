#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

cat 0_append_distro_path_32.sh | grep "#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}" || sed 's/export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}/1' 0_append_distro_path_32.sh -i

cd utils

source ../0_append_distro_path_32.sh
cd ..

finish()
{
	sh utils/INSTALL.sh ${X_BUILDDIR} $(dirname ${NEW_DISTRO_ROOT})

	cd ${DIR}

	mv ${X_BUILDDIR}/*.7z ${STAGE1}

	rm -rf ${X_BUILDDIR}/*
}

rm -rf ${STAGE1}
mkdir -p ${STAGE1}

cd S1.0001.binutils
sh 32.binutils.sh
cd ..
finish

cd S1.0002.gcc
sh 32.gcc.sh
cd ..
finish
