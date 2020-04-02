#!/bin/bash

deviceIP=$1
arch="arm64"
pack_name="libopenblas"


scp ${pack_name}_${arch}_*.dev.deb ubuntu@${deviceIP}:~
scp time_dgemm.c ubuntu@${deviceIP}:~
ssh ubuntu@${deviceIP} "sudo dpkg -i ~/${pack_name}_${arch}_*.dev.deb"