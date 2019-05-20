#!/bin/bash
cd /root/nfs/linux-museum/github

echo "" > output
while read line
do

for j in `seq 1 1 2`
do

for i in `cat names*.txt| grep "${line}" | awk '{print $2}' | sort | uniq`
do
end=`cat part${j}.txt | grep "${i}" | head -n 1 | awk '{print $1}'`
begin=`cat part${j}.txt | grep "${i}" | tail -n 1 | awk '{print $1}'`
echo part${j}.txt ${i} "From "`date -d @${begin} | awk '{print $6}' `" TO" `date -d @${end} | awk '{print $6}'` >> output
done

done

done < team.txt


cat output| grep -v "From  TO" | awk '{print $2 " " $4 " " $6}' | sort -k 2
