# UBUNTU 19.10, RaspberryPi 4, aarch kernal

## Скомпилированную библиотеку, готовую к установке можно скачать в **[релизах](https://github.com/MiXaiLL76/OpenBLAS_RaspberryPi/releases)**

## Компиляция пакета
```
docker-compose build
```

1. Скачивает нужные библиотеки в образе
2. Делает сборку библиоткеи в образе

## Подключение для отладки (если нужно)
```
docker run --rm -ti iot/openblas
```

## Сборка deb пакета OpenBLAS
```
docker-compose up
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