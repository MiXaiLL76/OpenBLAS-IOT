# DEBIAN 10, RaspberryPi 3b+, aarch kernal

## Скомпилированную библиотеку, готовую к установке можно скачать в **[релизах](https://github.com/MiXaiLL76/OpenBLAS_RaspberryPi/releases)**

## Просто информация

[Тут установка opencv](https://habr.com/ru/post/461693/)

[Тут доп. либы для малинки](https://github.com/raspberrypi/userland)

[Тут глюченый но всё таки aarch64 debian](https://github.com/openfans-community-offical/Debian-Pi-Aarch64/)

[Тут инфа как включить aarch64 kernal](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=257767&hilit=arm64%3D1)

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

## Компиляция пакета

```
sudo bash build.bash
```

## Сборка пакета OpenBLAS


```
cp deb.bash ~/raspberry/OpenBLAS
cd ~/raspberry/OpenBLAS
sudo bash deb.bash
```

## Установка OpenBLAS

```
deviceIP="192.168.1.101"
arch="armhf"
pack_name="libopenblas"

version=`cat Makefile.rule | grep VERSION | sed "s@VERSION = @@" | sed "s@.dev@@"`

scp ${pack_name}_${arch}_${version}.dev.deb pi@${deviceIP}:~
ssh pi@${deviceIP} "sudo dpkg -i ~/${pack_name}_${arch}_${version}.dev.deb"

```

## Проверка

```
sudo ldconfig
wget https://raw.githubusercontent.com/MiXaiLL76/OpenBLAS_IOT/rpi3b_armv8_kernal/time_dgemm.c
scp time_dgemm.c pi@${deviceIP}:~
ssh pi@${deviceIP} "gcc time_dgemm.c -o out -lopenblas"
ssh pi@${deviceIP} "~/out"
```
Вывод выглядит не плохо. 

```
openblas_get_num_threads =  3
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.359737 s      5559.617165 MFLOPS
```