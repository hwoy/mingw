#!/bin/sh

DIR=$(dirname $0)

cd ${DIR}

sh BUILDALL64.S1.sh && sh BUILDALL64.S23.sh && sh BUILDALL64.Sfinal.sh && echo "===================== Success ====================="
