#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}
cd utils
source ../0_append_distro_path.sh
cd ..

gcc --version