#!/usr/bin/env bash

set -veuo pipefail 

install_pkgs() {
    apt-get update
    apt-get install -y --no-install-recommends $@

    update-dlocatedb 
}

find_shlib_deps() {
    set +o pipefail 

    find "$1" -type f \( -name "*.so" -o -executable \) \
        | file -F" " -f-    \
        | awk '/ELF/ { print $1 }' \
        | xargs ldd \
        | grep -v "not found" \
        | awk '/^\t(.*)=>(.*)/ { print $3 }' \
        | grep -v "^/$1" \
        | sort | uniq \
        | xargs dlocate -p \
        | sort | uniq
}

install_pkgs \
    dlocate \
    autoconf \
    automake \
    libtool \
    python3-dev \
    libexpat-dev \
    libtbb-dev \
    zlib1g-dev \
    xzip \
    libbz2-dev \
    libxml2-dev \
    libbz2-dev \
    llvm-8-dev \
    python3-mako \
    python3-setuptools \
    libfontconfig-dev \
    libboost-atomic-dev \
    libboost-chrono-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-thread-dev \
    libnetcdf-dev \
    libpng-dev \
    libsz2 \
    python3-numpy \
    python3-scipy

update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-8 40

mkdir -p /build 
pushd /build


# clone superbuild source
git clone \
    --recursive \
    --branch v5.9.1 \
    --depth 1 \
    https://gitlab.kitware.com/paraview/paraview-superbuild.git \
    pv-src

# configure
# use these as system dependencies
system=(boost libxml2 python3 tbb zlib png bzip2 expat netcdf numpy szip freetype llvm)
# enable these aspects
enable=(osmesa ospray vtkm ffmpeg silo hdf5 paraviewsdk)

cmake -G Ninja -B pv-bld -S pv-src -Wno-dev \
      -DPARAVIEW_BUILD_EDITION=CANONICAL \
      -Dparaview_SOURCE_SELECTION=5.9.1 \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_BUILD_TYPE_paraview=Release \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -Dospray_BUILD_ISA=AVX,AVX2 \
      $(printf -- "-DENABLE_%s=ON\n" ${enable[@]} ${system[@]}) \
      $(printf -- "-DUSE_SYSTEM_%s=ON\n" ${system[@]}) \
    2>&1 | tee buildlog

cmake --build   pv-bld 2>&1 | tee -a buildlog
cmake --install pv-bld 2>&1 | tee -a buildlog

# collect buildinfo
mkdir -p /usr/local/share/buildinfo

# find packages that are needed for runtime dependencies
find_shlib_deps pv-bld/install > /usr/local/share/buildinfo/paraview.dpkg
cat /usr/local/share/buildinfo/paraview.dpkg

# save buildlog
cat buildlog | xz > /usr/local/share/buildinfo/paraview.buildlog.xz

popd