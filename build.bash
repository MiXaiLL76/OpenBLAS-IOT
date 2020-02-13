#!/bin/bash

replace(){
find=$1
rep=$2
file=$3
sed -i "s@${find}@${rep}@" ${file}
}

sudo apt install -y checkinstall build-essential autoconf \
automake cmake unzip pkg-config gcc-arm-linux-gnueabihf \
g++-arm-linux-gnueabihf gfortran-arm-linux-gnueabihf \
libgfortran3-armhf-cross gcc rsync

cd ~
mkdir -p -m777 raspberry
cd ~/raspberry

git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS

tc_prefix="arm-linux-gnueabihf-"; rArch="ARMV7";


make CC=${tc_prefix}gcc \
RANLIB=${tc_prefix}ranlib  \
AR=${tc_prefix}gcc-ar \
FC=${tc_prefix}gfortran \
HOSTCC=gcc TARGET=${rArch} NUM_THREADS=4 -j8

replace "/opt/OpenBLAS" "/usr/local" Makefile.install
replace "NO_LAPACKE" "NO_LAPACKE_OUT" Makefile.install