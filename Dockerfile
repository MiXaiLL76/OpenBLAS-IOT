FROM ubuntu:20.04
LABEL maintainer="mike.milos@yandex.ru"

WORKDIR /tmp

# GET LIBS
RUN DEBIAN_FRONTEND=noninteractive apt update  -y
RUN DEBIAN_FRONTEND=noninteractive apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y build-essential autoconf
RUN DEBIAN_FRONTEND=noninteractive apt install -y automake cmake unzip pkg-config gcc rsync git  

# Обновление пакетов, нужных для установки
RUN DEBIAN_FRONTEND=noninteractive apt install -y debconf debhelper lintian bc fakeroot

# ARM
RUN DEBIAN_FRONTEND=noninteractive apt install -y gcc-arm-linux-gnueabihf
RUN DEBIAN_FRONTEND=noninteractive apt install -y g++-arm-linux-gnueabihf gfortran-arm-linux-gnueabihf
RUN DEBIAN_FRONTEND=noninteractive apt install -y libgfortran5-armhf-cross gcc rsync git 

# ARM64
RUN DEBIAN_FRONTEND=noninteractive apt install -y gcc-aarch64-linux-gnu
RUN DEBIAN_FRONTEND=noninteractive apt install -y g++-aarch64-linux-gnu gfortran-aarch64-linux-gnu
RUN DEBIAN_FRONTEND=noninteractive apt install -y libgfortran5-arm64-cross gcc rsync git 

# BUILD
RUN git clone https://github.com/xianyi/OpenBLAS.git
WORKDIR /tmp/OpenBLAS

ARG TC_PREFIX
ENV TC_PREFIX ${TC_PREFIX}

ARG ARCH
ENV ARCH ${ARCH}

RUN make CC=${TC_PREFIX}gcc RANLIB=${TC_PREFIX}ranlib AR=${TC_PREFIX}gcc-ar FC=${TC_PREFIX}gfortran HOSTCC=gcc TARGET=${ARCH} NUM_THREADS=4 -j8

COPY ./replace.sh .
RUN ./replace.sh "/opt/OpenBLAS" "/usr/local" Makefile.install
RUN ./replace.sh "NO_LAPACKE" "NO_LAPACKE_OUT" Makefile.install

COPY ./deb.sh .
RUN ./replace.sh "_ARCH" ${ARCH} deb.sh

ENTRYPOINT '/bin/bash'