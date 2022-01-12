#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

cat 0_common_head.sh | grep "#_default_msvcrt=ucrt" || sed 's/_default_msvcrt=ucrt/#_default_msvcrt=ucrt/1' 0_common_head.sh -i

sh BUILDALL32.S1.sh && sh BUILDALL32.S23.sh && sh BUILDALL32.Sfinal.sh && echo "===================== Success ====================="

cd ${DIR}

sh BUILDALL32.S1.sh && sh BUILDALL32.S23.sh && sh BUILDALL32.Sfinal.sh && echo "===================== Success ====================="

