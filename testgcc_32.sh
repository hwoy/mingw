#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}
cd utils
source ../0_append_distro_path_32.sh
cd ..

gcc --version