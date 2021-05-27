#! /usr/bin/env bash
set -e

build_pkgs \
	build-essential	\
	pkg-config		\
	curl			\
	python3-dev		\
	python3-mako	\
	llvm-11-dev		\
    meson         	\
    ninja-build     \
	zlib1g-dev		\
	libdrm-dev		\
	gettext			\
	bison			\
	flex			\
	libelf-dev		\
	xz-utils

runtime_pkgs \
	libstdc++6		\
	libllvm11		\
	zlib1g

# get source

curl -kL https://mesa.freedesktop.org/archive/mesa-21.0.3.tar.xz \
    | tar Jx --strip-components 1

# configure and build
mkdir build

if [ $(uname -m) == "x86_64" ]; then
	conf_args -Dgallium-drivers=swr,swrast
fi

meson build 					\
    --prefix=/usr				\
    -Dosmesa=true				\
    -Dplatforms= 				\
    -Dglx=disabled				\
    -Dgles2=disabled			\
    -Dgles1=disabled			\
    -Dllvm=true					\
    -Ddri-drivers=				\
    -Dvulkan-drivers=			\
	-Dswr-arches=avx			\
    -Dshared-glapi=enabled		\
	${configure_args}

ninja -v -C build install

