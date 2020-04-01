# UBUNTU 18.04, RaspberryPi 4, aarch kernal

## Скомпилированную библиотеку, готовую к установке можно скачать в **[релизах](https://github.com/MiXaiLL76/OpenBLAS_RaspberryPi/releases)**

## Просто информация

[Тут установка opencv](https://habr.com/ru/post/461693/)

[Тут доп. либы для малинки](https://github.com/raspberrypi/userland)

[Тут глюченый но всё таки aarch64 debian](https://github.com/openfans-community-offical/Debian-Pi-Aarch64/)

[Тут инфа как включить aarch64 kernal](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=257767&hilit=arm64%3D1)

## Toolchain

```
sudo apt install -y build-essential autoconf \
automake cmake unzip pkg-config gcc-aarch64-linux-gnu \
g++-aarch64-linux-gnu gfortran-aarch64-linux-gnu \
libgfortran5-arm64-cross gcc rsync

cd ~
mkdir -p -m777 raspberry
cd ~/raspberry

```


## Raspberry Pi

```
ubuntu@ubuntu:~$ sudo apt install -y gcc libgfortran5
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
deviceIP="192.168.1.200"
arch="arm64"
pack_name="libopenblas"

version=`cat Makefile.rule | grep VERSION | sed "s@VERSION = @@" | sed "s@.dev@@"`

scp ${pack_name}_${arch}_${version}.dev.deb ubuntu@${deviceIP}:~
ssh ubuntu@${deviceIP} "sudo dpkg -i ~/${pack_name}_${arch}_${version}.dev.deb"

```

## Проверка

```
sudo ldconfig
wget https://raw.githubusercontent.com/MiXaiLL76/OpenBLAS_IOT/rpi3b_armv8_kernal/time_dgemm.c
scp time_dgemm.c ubuntu@${deviceIP}:~
ssh ubuntu@${deviceIP} "gcc time_dgemm.c -o out -lopenblas"
ssh ubuntu@${deviceIP} "~/out"
```

Вывод выглядит не плохо. На все 4 ядра.

```
ubuntu@ubuntu:~$ OMP_NUM_THREADS=4 ./out
openblas_get_num_threads =  4
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.149772 s      13353.630852 MFLOPS
```