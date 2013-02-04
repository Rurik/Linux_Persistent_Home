#!/bin/bash
# pack-it-up by Brian Baskin
# 2005 for challenge made by Johnny Long

echo "o0o unlink o0o"
umount /BB
losetup -d /dev/loop0

imagename=`cat home.pid`
echo "o0o reverting back to "$imagename" o0o"
rm home.pid


echo "o0o encrypt o0o"
cd /tmp
openssl enc -aes-256-cbc -in bbag.img -out $imagename
rm bbag.img
mv $imagename /mnt/sda1
mv /tmp/old.passwd /etc/passwd
echo "o0o go home o0o"
