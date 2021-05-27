#! /bin/bash

set -e

# do not install if not on an Intel processor
[ $(uname -m) == "x86_64" ] || exit 0

build_pkgs \
    build-essential         \
    curl                    \
    ca-certificates         \
    cmake                   \
    ninja-build             \
    libtbb-dev

runtime_pkgs \
    libtbb2

# --------------------------------------------------------------------------

curl -L https://github.com/ospray/ospray/archive/v2.6.0.tar.gz | \
    tar xz --strip-components 1

mkdir build
pushd build

cmake -G Ninja \
    -DCMAKE_INSTALL_PREFIX=/usr     \
    -DCMAKE_BUILD_TYPE=Release      \
    -DOSPRAY_ENABLE_APPS=OFF        \
    -DOSPRAY_MODULE_DENOISER=ON     \
    ..

cmake --build .
cmake --install .

popd

# REQUIRED - not sure why this isn't automatically called
ldconfig