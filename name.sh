#!/bin/bash
cd /root/nfs/linux-museum/linux
echo "" > names.txt
while read line
do
	commit=`echo ${line} | awk '{print $2}'`
	email=`echo ${line} | awk '{print $3}'`
	echo "${commit} ${email} `git show --pretty='%an' ${commit} | head -n 1`" >> names3.txt
done < /root/nfs/linux-museum/github/part3.txt
