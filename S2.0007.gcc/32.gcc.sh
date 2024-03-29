#!/bin/sh

source ../0_append_distro_path_32.sh

SNAME=gcc
SVERSION=12.1.0


# Extract vanilla sources.

decompress()
{
	untar_file gmp-6.2.1.tar.xz
	untar_file mpfr-4.1.0.tar.xz
	untar_file mpc-1.2.1.tar.gz
	untar_file isl-0.25.tar.xz

	untar_file ${SNAME}-${SVERSION}.tar.xz
}

prepare()
{
	cd patch
	
	patch -Z -d ${X_BUILDDIR}/mpfr-4.1.0 -p1 < mpfr-4.1.0-p13.patch
	
	patch -p1 -d ${X_BUILDDIR}/isl-0.25 < isl-0.14.1-no-undefined.patch
	autoreconf -fi ${X_BUILDDIR}/isl-0.25
	
	rm -rf ${X_BUILDDIR}/${SNAME}-${SVERSION}/intl/relocatex.c ${X_BUILDDIR}/${SNAME}-${SVERSION}/intl/relocatex.h
	
  # Debian decided to pull in changes from git, so just re-user that as is.
  # https://salsa.debian.org/toolchain-team/gcc/-/blob/5ac26f96b568a7258b4a2900f8d99799d94bb8a9/debian/patches/git-updates.diff
	apply_patch_p2 "git-updates.diff"

	apply_patch_p1 \
    0002-Relocate-libintl.patch \
    0003-Windows-Follow-Posix-dir-exists-semantics-more-close.patch \
    0004-Windows-Use-not-in-progpath-and-leave-case-as-is.patch \
    0005-Windows-Don-t-ignore-native-system-header-dir.patch \
    0006-Windows-New-feature-to-allow-overriding.patch \
    0007-Build-EXTRA_GNATTOOLS-for-Ada.patch \
    0008-Prettify-linking-no-undefined.patch \
    0010-Fix-using-large-PCH.patch \
    0011-Enable-shared-gnat-implib.patch \
    0012-Handle-spaces-in-path-for-default-manifest.patch \
    0014-gcc-9-branch-clone_function_name_1-Retain-any-stdcall-suffix.patch \
    0020-libgomp-Don-t-hard-code-MS-printf-attributes.patch \
    0021-PR14940-Allow-a-PCH-to-be-mapped-to-a-different-addr.patch
	
  # Enable diagnostic color under mintty
  # Вячеслав Петрищев <vyachemail@gmail.com>
  apply_patch_p1 \
    0140-gcc-8.2.0-diagnostic-color.patch
	

  # workaround for AVX misalignment issue for pass-by-value arguments
  #   cf. https://github.com/msys2/MSYS2-packages/issues/1209
  #   cf. https://sourceforge.net/p/mingw-w64/discussion/723797/thread/bc936130/ 
  #  Issue is longstanding upstream at https://gcc.gnu.org/bugzilla/show_bug.cgi?id=54412
  #  Potential alternative: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=939559
  # https://github.com/msys2/MINGW-packages/pull/8317#issuecomment-824548411
  apply_patch_p1 \
    0200-add-m-no-align-vector-insn-option-for-i386.patch

  # Patch from https://gcc.gnu.org/pipermail/gcc-patches/2022-January/588341.html
  # Related bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=95130
  apply_patch_p1 \
    0300-override-builtin-printf-format.patch

  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105745
  apply_patch_p1 \
    1001-libgomp-use-_aligned_free-in-gomp_aligned_free-if-ne.patch \
    1002-libgomp-don-t-use-GOMP_USE_ALIGNED_WORK_SHARES-on-Wi.patch
	

	cd ..
	
	cd ${X_BUILDDIR}/${SNAME}-${SVERSION}
  # do not expect ${prefix}/mingw symlink - this should be superceded by
  # 0005-Windows-Don-t-ignore-native-system-header-dir.patch .. but isn't!
  sed -i 's/${prefix}\/mingw\//${prefix}\//g' configure

  # change hardcoded /mingw prefix to the real prefix .. isn't this rubbish?
  # it might work at build time and could be important there but beyond that?!
  local MINGW_NATIVE_PREFIX=$(cygpath -am ${MINGW_PREFIX})
  sed -i "s#\\/mingw\\/#${MINGW_NATIVE_PREFIX//\//\\/}\\/#g" gcc/config/i386/mingw32.h
}

build()
{
	#No use libiconv
	#export am_cv_func_iconv=no
	export lt_cv_deplibs_check_method='pass_all'
	#export gcc_cv_libc_provides_ssp=yes

	cd ${X_BUILDDIR}

	# Prepare to build gcc.
	mv ${SNAME}-${SVERSION} src
	mv gmp-6.2.1 src/gmp
	mv mpfr-4.1.0 src/mpfr
	mv mpc-1.2.1 src/mpc
	mv isl-0.25 src/isl

	# Prepare to build gcc - perform magic directory surgery.
	#cp -r dest/${X_HOST}/lib dest/${X_HOST}/lib64
	#cp -r dest/${X_HOST} dest/mingw
	#mkdir -p src/gcc/winsup/mingw
	#cp -r dest/${X_HOST}/include src/gcc/winsup/mingw/include
	#mkdir -p ${X_BUILDDIR}/dest/usr/include


	# Configure.
	GCC_PARAMS="--disable-sjlj-exceptions --with-dwarf2"
	ZST=${X_BUILDDIR}/zstd-1.5.1
	ICONV=${X_BUILDDIR}/libiconv-1.16
	_arch=i686
	local _LDFLAGS_FOR_TARGET="$LDFLAGS"
	LDFLAGS+=" -Wl,--disable-dynamicbase"

	mkdir build
	cd build

	../src/configure --enable-languages=${_languages} \
		--build=${X_BUILD} --host=${X_HOST} --target=${X_TARGET} \
		--prefix=${MINGW_PREFIX}  \
		--disable-nls  --disable-win32-registry \
		--enable-threads=${X_THREAD} --disable-bootstrap \
		--enable-shared --enable-static --enable-lto --disable-multilib \
		--with-gnu-as --with-gnu-ld \
		--enable-graphite \
		--enable-fully-dynamic-string \
		--enable-libstdcxx-filesystem-ts=yes \
		--enable-libstdcxx-time=yes \
		--disable-libstdcxx-pch \
		--disable-libstdcxx-verbose \
		--disable-libstdcxx-debug \
		--enable-cloog-backend=isl \
		--enable-version-specific-runtime-libs \
		--disable-isl-version-check \
		--with-libiconv \
		--without-libintl-prefix --disable-libintl \
		--enable-linker-build-id \
		--enable-libquadmath \
		--enable-libquadmath-support \
		--enable-libatomic \
		--disable-werror \
		--disable-symvers \
		--disable-rpath \
		--enable-libgomp \
		--with-arch=${_arch} \
		--with-tune=generic \
		--with-pkgversion="${PROJECTNAME} ${REV}, Built by ${AUTHOR}" \
		--with-boot-ldflags="${LDFLAGS} -static-libstdc++ -static-libgcc" \
		LDFLAGS_FOR_TARGET="${_LDFLAGS_FOR_TARGET}" \
		--enable-linker-plugin-flags='LDFLAGS=-static-libstdc++\ -static-libgcc\ '"${_LDFLAGS_FOR_TARGET// /\\ }"'\ -Wl,--stack,12582912' \
		${GCC_PARAMS}



	# --enable-languages=c,c++        : I want C and C++ only.
	# --build=${X_BUILD}      : I want a native compiler.
	# --host=${X_HOST}       : Ditto.
	# --target=${X_TARGET}     : Ditto.
	# --disable-multilib              : I want 64-bit only.
	# --prefix=${X_BUILDDIR}/dest       : I want the compiler to be installed here.
	# --with-sysroot=${X_BUILDDIR}/dest : Ditto. (This one is important!)
	# --disable-libstdcxx-pch         : I don't use this, and it takes up a ton of space.
	# --disable-libstdcxx-verbose     : Reduce generated executable size. This doesn't affect the ABI.
	# --disable-nls                   : I don't want Native Language Support.
	# --disable-shared                : I don't want DLLs.
	# --disable-win32-registry        : I don't want this abomination.
	# --enable-threads=posix          : Use winpthreads.
	# --enable-libgomp                : Enable OpenMP.
	# --with-zstd=$X_DISTRO_ROOT      : zstd is needed for LTO bytecode compression.
	# --disable-bootstrap             : Significantly accelerate the build, and work around bootstrap comparison failures.

	# Build and install.
	make -j${JOBS}
	make DESTDIR=${X_BUILDDIR}/dest install

	# Cleanup.
	cd ${X_BUILDDIR}
	rm -rf build src
	mv dest ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}
	cd ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}/${MINGW_PREFIX}

	#rm -rf usr
	#cp libgcc_s
	mkdir -p ${X_TARGET}/lib
	cp $(find . -name "libgcc_s.a")  ${X_TARGET}/lib

	find -name "*.la" -type f -print -exec rm {} ";"
	find -name "*.exe" -type f -print -exec strip -s {} ";"

	cd ../

	mv ${MINGW_PREFIX:1} ${PROJECTNAME}
	zip7 ${SNAME}-${SVERSION}-${X_HOST}-${X_THREAD}-${_default_msvcrt}-${REV}.7z

}

decompress

prepare

build
