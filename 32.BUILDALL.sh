#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

sh BUILDALL32.S1.sh && sh BUILDALL32.S23.sh && sh BUILDALL32.Sfinal.sh && echo "===================== Success ====================="
