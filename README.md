# DEBIAN 10, RaspberryPi 3b+, ARMv7

## Скомпилированную библиотеку, готовую к установке можно скачать в **[релизах](https://github.com/MiXaiLL76/OpenBLAS_RaspberryPi/releases)**

## Toolchain

```
sudo apt install -y checkinstall build-essential autoconf \
automake cmake unzip pkg-config gcc-arm-linux-gnueabihf \
g++-arm-linux-gnueabihf gfortran-arm-linux-gnueabihf \
libgfortran3-armhf-cross gcc rsync

cd ~
mkdir raspberry
cd ~/raspberry
```
## Raspberry Pi

```
pi@raspberrypi:~ $ sudo apt install -y libgfortran3 rsync
```

## Setup

Клонировать репозиторий OpenBLAS

``` 
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS/

```

Теперь нужно сконфигурировать и скомпилировать OpenBLAS. Это займет несколько минут.

```
tc_prefix="arm-linux-gnueabihf-"; rArch="ARMV7";
make CC=${tc_prefix}gcc \
RANLIB=${tc_prefix}ranlib  \
AR=${tc_prefix}gcc-ar \
FC=${tc_prefix}gfortran \
HOSTCC=gcc TARGET=${rArch} NUM_THREADS=3

```

По умолчанию OpenBLAS устанавливается в /opt/OpenBLAS, что неудобно для обычного использования. Имхо

Так же при установке в таком формате для RPI что то происходит с LAPACKE и приходится немного подправить конфиг.

А еще при установке часто ругается на папку */usr/local/lib/cmake/openblas/*. Предлагаю её *удалить*, а потом создать.

```
oprefix="/opt/OpenBLAS";nprefix="/usr/local"
sed -i "s@${oprefix}@${nprefix}@" Makefile.install
sed -i "s@NO_LAPACKE@NO_LAPACKE_OUT@" Makefile.install

OpenBLASver=`cat Makefile.rule | grep VERSION | sed "s@VERSION = @@" | sed "s@.dev@@"`
sudo rm -rf /usr/local/lib/cmake/openblas/
sudo mkdir -p -m777 /usr/local/lib/cmake/openblas/

```

Сборка пакета OpenBLAS

```
sudo checkinstall -D \
--install=no \
--strip=no \
--pkgversion=${OpenBLASver} \
--pkgrelease="dev" \
--pkgname=libopenblas \
--pkgarch=armhf \
--pkgsource="http://github.com/xianyi/OpenBLAS" \
--maintainer="MiXaiLL76" --default

```

Установка OpenBLAS

```
deviceIP="192.168.1.101"
scp libopenblas_${OpenBLASver}-dev_armhf.deb pi@${deviceIP}:~
ssh pi@${deviceIP} "sudo dpkg -i ~/libopenblas_${OpenBLASver}-dev_armhf.deb"
ssh pi@${deviceIP} "sudo ldconfig"

```

Проверка

```
wget https://raw.githubusercontent.com/MiXaiLL76/OpenBLAS_RaspberryPi/master/time_dgemm.c
scp time_dgemm.c pi@${deviceIP}:~
ssh pi@${deviceIP} "gcc time_dgemm.c -o out -lopenblas"
ssh pi@${deviceIP} "~/out"
```
Вывод выглядит не плохо. Ограничил 3 ядрами.

```
test! 3
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.359737 s      5559.617165 MFLOPS
```