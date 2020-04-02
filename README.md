# UBUNTU 19.10, RaspberryPi 4, aarch kernal

## Скомпилированную библиотеку, готовую к установке можно скачать в **[релизах](https://github.com/MiXaiLL76/OpenBLAS_RaspberryPi/releases)**

## Просто информация

[Тут установка opencv](https://habr.com/ru/post/461693/)

[Тут доп. либы для малинки](https://github.com/raspberrypi/userland)

[Тут глюченый но всё таки aarch64 debian](https://github.com/openfans-community-offical/Debian-Pi-Aarch64/)

[Тут инфа как включить aarch64 kernal](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=257767&hilit=arm64%3D1)

## Raspberry Pi

```
ubuntu@ubuntu:~$ sudo apt install -y gcc libgfortran5
```

## Компиляция пакета

```
sudo bash build.bash
```
1. Создает папку `raspberry/OpenBLAS`
2. Скачивает нужные библиотеки
3. Делает сборку библиоткеи


## Сборка deb пакета OpenBLAS


```
sudo bash deb.bash
```

## Установка OpenBLAS

```
bash install.bash 192.168.1.5
```

## Проверка

```
ubuntu@ubuntu:~$ sudo ldconfig
ubuntu@ubuntu:~$ gcc time_dgemm.c -o out -lopenblas

ubuntu@ubuntu:~$ OMP_NUM_THREADS=1 ./out
openblas_get_num_threads =  1
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.429717 s      4654.225921 MFLOPS

ubuntu@ubuntu:~$ OMP_NUM_THREADS=2 ./out
openblas_get_num_threads =  2
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.226345 s      8836.068833 MFLOPS

ubuntu@ubuntu:~$ OMP_NUM_THREADS=3 ./out
openblas_get_num_threads =  3
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.169808 s      11778.008103 MFLOPS

ubuntu@ubuntu:~$ OMP_NUM_THREADS=4 ./out
openblas_get_num_threads =  4
m=1000,n=1000,k=1000,alpha=1.200000,beta=0.001000,sizeofc=1000000
1000x1000x1000  0.155684 s      12846.535289 MFLOPS

```