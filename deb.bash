#!/bin/bash

su="sudo"
apt_tool="${su} apt"

indexOf(){
# indexOf "asdsad" "a"
  echo "$1" "$2" | awk '{print index($1,$2)}' 
}

dpkg_test(){
  find_str="no packages found"
  line=`dpkg -l $1 | grep $1`

  if [ "$(echo ${line} | awk '{print length}')" == '0' ]; then
      ${apt_tool} update
      ${apt_tool} install $1 -y
  fi
}

### Обновление пакетов, нужных для установки
dpkg_test debconf
dpkg_test debhelper
dpkg_test lintian
dpkg_test bc
dpkg_test fakeroot

new_fakeroot="fakeroot-tcp"
${su} update-alternatives --set fakeroot /usr/bin/${new_fakeroot}
### Для сборки пакета

# Название пакета
pack_name="libopenblas"
arch="armhf"

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

# Удаление предыдущей сборки
${su} rm -rf ${root}

# Создание папок
mkdir -p ${root}
mkdir -p ${root}/DEBIAN

make install PREFIX=${root}/usr/local

sizebyte=$(stat libopenblas_armv7p-r${version}.dev.a -c %s)
let "sizekb = sizebyte / 1024 * 2"

# Сборка контрольных файлов
{
  echo "Package: ${pack_name}"
  echo "Version: ${version}.dev"
  echo "Maintainer: MiXaiLL76 <mike.milos@yandex.ru>"
  echo "Architecture: ${arch}"
  echo "Section: misc"
  echo "Description: OpenBLAS builded for RPI3b+"
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

# Вывод информации
echo ""
echo ""
echo ${info}
echo ""
echo "This root is: ${pwd_root}"
echo "Created package is: ${pack_name}_${arch}_${version}.dev.deb"

${su} rm -rf ${root}

