#!/bin/bash

HEAD=`cat /root/github/linux_git_show_numstat_since_Linux-2.6.12-rc2/HEAD`
cd /root/github/linux

git log -M --no-merges --pretty="%at %H %ae" --no-merges ${HEAD}..HEAD > all_commits.txt

echo "" > output.txt

while read line
do

time=`echo ${line} | awk '{print $1}'`
commit=`echo ${line} | awk '{print $2}'`
email=`echo ${line} | awk '{print $3}'`

git show -M --pretty="%H" --numstat ${commit} | sed '1d' | grep -v "^$" > commit_${commit}.txt
while read line
do
echo ${time}" "${commit}" "${email}" "${line} >> output.txt
done < commit_${commit}.txt
rm commit_${commit}.txt

done < all_commits.txt

echo "Please check output.txt in /root/nfs/linux-museum/linux!"
#sh /root/lab/sever-job-notification/send_email.sh "Finished: generate.sh" "please check output.txt in /root/nfs/linux-museum/linux"

