#!/bin/sh


DIR=$(dirname $0)

FILE=${DIR}/../PKGLIST.TXT
rm -rf ${FILE}

for i in $(find ${DIR}/../ -name wget.txt)
do
	cat ${i} >> ${FILE}
	echo "" >> ${FILE}
done

for i in $(cat ${FILE})
do
	echo $(basename ${i}) >> ${FILE}.1
done

source ../0_common_head.sh

echo "Distro name: ${PROJ}" > ${FILE}
echo "Created by: ${AUTHOR}" >> ${FILE}
echo "Reversion: ${REV}" >> ${FILE}
echo "Compilers: ${_languages}" >> ${FILE}
echo "Thread: ${X_THREAD}" >> ${FILE}
echo "Exception: SEH for 64 and Draft-2 for 32" >> ${FILE}
echo "Libc: ${_default_msvcrt}" >> ${FILE}
echo "" >> ${FILE}
echo "" >> ${FILE}
echo "====================== Packages ======================" >> ${FILE}
awk '!seen[$0]++' ${FILE}.1 >> ${FILE}
echo "====================== Packages ======================" >> ${FILE}
rm -f ${FILE}.1