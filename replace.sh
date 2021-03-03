#!/bin/bash

find=$1 # Что заменяем
rep=$2  # На что заменяем
file=$3 # В каком файле заменяем

sed -i "s@${find}@${rep}@" ${file}