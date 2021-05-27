#! /bin/bash

set -e

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

# get source code
curl -L https://github.com/embree/embree/archive/v3.13.0.tar.gz | \
  tar xz --strip-components 1

# use system supplied TBB
sed -i -e 's/TBB 2021/TBB 2020/' common/tasking/CMakeLists.txt

mkdir build
pushd build

case $(uname -m) in 
  x86_64)
    conf_args \
      -DEMBREE_MAX_ISA=SSE4.2
    ;;
  aarch64)
    conf_args \
      -DEMBREE_MAX_ISA=NEON
    ;;
esac

cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release	\
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DEMBREE_TUTORIALS=OFF      \
  ${configure_args} \
  ..

cmake --build .
cmake --install .

popd
