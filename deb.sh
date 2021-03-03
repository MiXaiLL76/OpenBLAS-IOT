#!/bin/bash

# Название пакета
pack_name="libopenblas"
arch="_ARCH"


if [ "$(arch)" != 'ARMV8' ]; then
  arch="armhf"
else
  arch="arm64"
fi

indexOf(){
  echo "$1" "$2" | awk '{print index($1,$2)}' 
}

new_fakeroot="fakeroot-tcp"
update-alternatives --set fakeroot /usr/bin/${new_fakeroot}

# Тут можно почитать о такого рода сборке
info="Build with [https://habr.com/ru/post/78094]"
date_now=$(date +%Y.%m.%d)
date_all=$(date +%'a, %d %b %Y %H:%M:%S %z')

# Обновление версии пакета
version=`cat Makefile.rule | grep VERSION | sed "s@VERSION = @@" | sed "s@.dev@@"`

# Текущая директория
pwd_root=$(pwd)

# Директория с файлами для сборки пакета
root="${HOME}/${pack_name}_deb"

# Создание папок
mkdir -p ${root}
mkdir -p ${root}/DEBIAN

doc=${root}/usr/share/doc/${pack_name}
mkdir -p ${doc}

make install PREFIX=${root}/usr/local

sizebyte=$(stat libopenblas*.dev.a -c %s)
let "sizekb = sizebyte / 1024 * 2"

# Сборка контрольных файлов
{
  echo "Package: ${pack_name}"
  echo "Version: ${version}.dev"
  echo "Maintainer: MiXaiLL76 <mike.milos@yandex.ru>"
  echo "Architecture: ${arch}"
  echo "Section: misc"
  echo "Depends: libgfortran5"                         # ЗАВИСИМОСТИ!
  echo "Description: OpenBLAS auto builded"
  echo "Installed-Size: ${sizekb}"
  echo "Priority: optional"
  echo "Origin: MiXaiLL76 brain"
} > ${root}/DEBIAN/control

{
  echo "Создатель пакета MiXaiLL76, т.е. я."
  echo "Телефон: +79201393940"
  echo "Почта: mike.milos@yandex.ru"
} > ${root}/DEBIAN/copyright

cp ${root}/DEBIAN/copyright ${doc}/copyright

{
  echo "${pack_name} (${version}.dev) stable; urgency=medium"
  echo ""
  echo "* Testing."
  echo ""
  echo "-- MiXaiLL76 <mike.milos@yandex.ru> ${date_all}"
} > ${root}/DEBIAN/changelog


# Раздаём папкам правильные права
chmod 775 -R ${root}

# Собираем пакет
${new_fakeroot} dpkg-deb --build ${root}

# Копируем пакет обратно в текущую директорию
mv ${root}.deb ${pack_name}_${arch}_${version}.dev.deb
cp ${pwd_root}/${pack_name}_${arch}_${version}.dev.deb /data

# Вывод информации
echo ""
echo ""
echo ${info}
echo ""
echo "This root is: ${pwd_root}"
echo "Created package is: ${pack_name}_${arch}_${version}.dev.deb"

rm -rf ${root}

