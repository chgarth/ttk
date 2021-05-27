#! /bin/bash

set -e

build_pkgs \
    clang-11                \
    curl                    \
    ca-certificates         \
    cmake                   \
    ninja-build             \
    libtbb-dev              \
    libclang-11-dev         \
    libc6-dev-i386-cross    \
    libc6-dev-arm64-cross   \
    libc6-dev-armhf-cross   \
    libc6-dev-amd64-cross   \
    llvm-11-dev             \
    bison                   \
    flex                    \
    zlib1g-dev              

runtime_pkgs \
    libllvm11 \
    zlib1g

ln -s /usr/bin/clang++-11 /usr/bin/clang++
ln -s /usr/bin/clang-11 /usr/bin/clang

# --------------------------------------------------------------------------

# get source code
curl -L https://github.com/ispc/ispc/archive/refs/tags/v1.15.0.tar.gz | \
  tar xz --strip-components 1

mkdir build
pushd build

cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release	            \
  -DARM_ENABLED=ON                          \
  -DX86_ENABLED=ON                          \
  -DISPC_INCLUDE_BENCHMARKS=OFF             \
  -DISPC_INCLUDE_EXAMPLES=OFF               \
  -DISPC_INCLUDE_TESTS=OFF                  \
  -DISPC_INCLUDE_UTILS=OFF                  \
  -DISPC_NO_DUMPS=ON                        \
  -DISPC_STATIC_LINK=ON                     \
  ..

cmake --build .
cmake --install .

popd

rm /usr/bin/clang++ /usr/bin/clang