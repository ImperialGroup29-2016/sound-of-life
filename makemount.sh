#!/bin/bash
make
cp -f kernel.img /media/$1/boot
umount /media/$1/boot
umount /media/$1/f39781f6-b968-4738-93ef-4d1af6861b99
killall nautilus
