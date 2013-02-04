#!/bin/bash
# break-it-out by Brian Baskin 
# 2005 - fun code for challenge laid out by Johnny Long

newimage="NO"
echo "o0o which image to use o0o"
select imagename in *.enc;
do
  echo $imagename
  if [ $imagename = "create-new.enc" ]
  then
    newimage="YES"
    
    imagename=$RANDOM".img.enc"
    echo "o0o creating file "$imagename" o0o"
    dd if=/dev/urandom of=./$imagename bs=1M count=3
  fi
  break;
done
echo "o0o Using "$imagename" for home dir o0o"
echo $imagename > home.pid

echo "o0o preparing home o0o"
cp $imagename /tmp/

if [ $newimage = "YES" ]
then
  echo "o0o using new home o0o"
  mv /tmp/$imagename /tmp/bbag.img
else
  echo "o0o decrypting home o0o"
  openssl enc -d -aes-256-cbc -in /tmp/$imagename -out /tmp/bbag.img
  rm /tmp/$imagename -f
fi

echo "o0o mounting home o0o"
losetup /dev/loop0 /tmp/bbag.img
if [ $newimage = "YES" ]
then
  echo "o0o making ext2 o0o"
  mkfs -t ext2 /dev/loop0
fi

if [ -e /BB ] 
then 
  echo "o0o reusing /BB o0o" 
else 
  echo "o0o making /BB o0o"
  mkdir /BB
fi
mount /dev/loop0 /BB


echo "o0o setting home o0o"
cp /etc/passwd /tmp/old.passwd
echo "root:x:0:0:root:/BB:/bin/bash" >> /tmp/new.passwd
tail -`wc -l /etc/passwd | awk '{print $1-1}'` /etc/passwd >> /tmp/new.passwd
mv /tmp/new.passwd /etc/passwd


echo "o0o home created, type su - o0o"
