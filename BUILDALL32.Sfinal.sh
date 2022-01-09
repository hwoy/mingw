#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}


cd utils

source ../0_append_distro_path_32.sh
cd ..

sh utils/INSTALL.sh ${STAGE23} ${STAGE23}/output

sh utils/PACKDIR.sh ${STAGE23}/output ${X_SRCDIR}/${PROJ}-${X_TARGET}

rm -rf ${STAGE23}/output
