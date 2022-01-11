#!/bin/sh

# Reject expansion of unset variables.
set -u

# Exit when a command fails.
if [ "${PS1:-}" == "" ]; then set -e; fi

source ../0_common_head.sh
PROJECTNAME=${PROJ}64-${_default_msvcrt}

export X_BUILD=x86_64-w64-mingw32
export X_HOST=${X_BUILD}
export X_TARGET=${X_BUILD}

export NEW_DISTRO_ROOT=/c/${PROJECTNAME}
export X_DISTRO_ROOT=/c/Temp/msys64/mingw64
#export X_DISTRO_ROOT=${NEW_DISTRO_ROOT}


source ../0_common.sh

STAGE1=${X_SRCDIR}/${X_TARGET}-STAGE1-${X_THREAD}-${_default_msvcrt}
STAGE23=${X_SRCDIR}/${X_TARGET}-STAGE23-${X_THREAD}-${_default_msvcrt}

export LDFLAGS=" "
export CFLAGS=" "
export CXXFLAGS=" "


# Print commands.
if [ "${PS1:-}" == "" ]; then set -x; fi
