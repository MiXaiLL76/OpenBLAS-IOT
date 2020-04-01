#!/bin/bash

replace(){
find=$1
rep=$2
file=$3
sed -i "s@${find}@${rep}@" ${file}
}

sudo apt install -y build-essential autoconf \
automake cmake unzip pkg-config gcc-aarch64-linux-gnu \
g++-aarch64-linux-gnu gfortran-aarch64-linux-gnu \
libgfortran5-arm64-cross gcc rsync

cd ~
mkdir -p -m777 raspberry
cd ~/raspberry

git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS

tc_prefix="aarch64-linux-gnu-"; rArch="ARMV8";

make CC=${tc_prefix}gcc \
RANLIB=${tc_prefix}ranlib  \
AR=${tc_prefix}gcc-ar \
FC=${tc_prefix}gfortran \
HOSTCC=gcc TARGET=${rArch} NUM_THREADS=4 -j8

replace "/opt/OpenBLAS" "/usr/local" Makefile.install
replace "NO_LAPACKE" "NO_LAPACKE_OUT" Makefile.install