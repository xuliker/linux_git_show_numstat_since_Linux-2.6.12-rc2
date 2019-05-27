#!/bin/bash
# sh get_kvm_ranking.sh 1546300800

# echo "1=`date --date='2019-01-01' +%s`"

if [ ! -n "$1" ]; then
  time=`date +%s`
  target="since_`date +%s`.txt"
else
  time=$1
  target="since_$1.txt"
fi

GIT="/root/github/linux_git_show_numstat_since_Linux-2.6.12-rc2"
KVM_COMMIT_BY_COMMPANY="kvm_commit_since_${time}_by_commpany.txt"
KVM_LOC_BY_COMMPANY="kvm_LOC_since_${time}_by_commpany.txt"
LINUX_COMMIT_IN_TEAM="linux_commit_since_${time}_in_team.txt"
LINUX_LOC_IN_TEAM="linux_LOC_since_${time}_in_team.txt"
TEAM="/root/github/teams"

cd ${GIT}

cat part*.txt | awk -v date=${time} ' $1 >= date {print $1" "$2" "$3" "$4" "$5" "$6}' > ${target}

for i in `cat ${target} | grep "ibm.com" | awk '{print $3}' | awk -F "@" '{print $2}' | sort | uniq | grep -v "^$"`
do
sed -i "s/${i}/ibm.com/g" ${target}
done

sed -i "s/pavel@pavel@suse.cz/pavel@suse.cz/g" ${target}

for i in `cat ${target} | grep -F "suse." | awk '{print $3}' | awk -F "@" '{print $2}' | sort | uniq | grep -v "^$"`
do
sed -i "s/${i}/suse.com/g" ${target}
done

for i in `cat ${target} | grep -F "intel.com" | awk '{print $3}' | awk -F "@" '{print $2}' | sort | uniq | grep -v "^$"`
do
sed -i "s/${i}/intel.com/g" ${target}
done

## company commit

TOTAL=`cat ${target} | grep -Ei "kvm|iommu|virtio|vfio|vhost|paravirt|virt/" | \
awk '{print $2 " " $3}' | sort | uniq | awk '{print $2}' | \
awk -F "@" '{print $2}' | grep -v "^$" | sort | uniq -c | sort -nr | awk '{print $1}' | \
awk 'BEGIN{total=0}{total+=$1}END{print total}'`

cat ${target} | grep -Ei "kvm|iommu|virtio|vfio|vhost|paravirt|virt/" | \
awk '{print $2 " " $3}' | sort | uniq | awk '{print $2}' | \
awk -F "@" '{print $2}' | grep -v "^$" | sort | uniq -c | sort -nr | \
awk -v sum=${TOTAL} '{printf $2 " " $1 " " "%04.2f%\n", $1/sum*100}'| \
column -c 1 -t | nl > ${KVM_COMMIT_BY_COMMPANY}

## company LOC

TOTAL=`cat ${target} | grep -Ei "kvm|iommu|virtio|vfio|vhost|paravirt|virt/" | \
awk '{print $3" "$4+$5}' | awk -F "@" '{print $2}' | \
awk '{if($1){a[$1] += $2;}} END{for(i in a){print i" "a[i]}} ' | grep -v "^$" | \
sort -nrk 2 | awk '{print $2}' | awk 'BEGIN{total=0}{total+=$1}END{print total}'`

cat ${target} | grep -Ei "kvm|iommu|virtio|vfio|vhost|paravirt|virt/" | \
awk '{print $3" "$4+$5}' | awk -F "@" '{print $2}' | \
awk '{if($1){a[$1] += $2;}} END{for(i in a){print i" "a[i]}} ' | grep -v "^$" | \
sort -nrk 2 | awk -v sum=${TOTAL} '{printf $1" "$2" " "%04.2f%\n", $2/sum*100}' | \
column -c 1 -t | nl > ${KVM_LOC_BY_COMMPANY}

cd ${TEAM}

cat SSP_PRC_VMM_Enabling_Dev_All.txt | sed 's/;/\n/g' | awk -F "<" '{print $2}' | \
sed 's/>//g' | sed 's/linux.intel.com/intel.com/g' | \
sort | uniq > ssp_prc_vmm_enabling_dev_all.txt

cd ${GIT}

echo "" > since_${time}_ssp_prc_vmm_enabling_dev_all.txt
while read line
do
cat ${target} | grep ${line} >> since_${time}_ssp_prc_vmm_enabling_dev_all.txt
done < /root/github/teams/ssp_prc_vmm_enabling_dev_all.txt

# team commit

TOTAL=`cat since_${time}_ssp_prc_vmm_enabling_dev_all.txt| awk '{print $2" "$3}' | \
sort | uniq | awk '{print $2}' | grep -v "^$" |sort | uniq -c|sort -nr | \
awk '{print $1}' | awk 'BEGIN{total=0}{total+=$1}END{print total}'`

cat since_${time}_ssp_prc_vmm_enabling_dev_all.txt| awk '{print $2" "$3}' | \
sort | uniq | awk '{print $2}' | grep -v "^$" |sort | uniq -c|sort -nr | \
awk -v sum=${TOTAL} '{printf $2 " " $1 " " "%04.2f%\n", $1/sum*100 }'| \
column -c 1 -t | nl > ${LINUX_COMMIT_IN_TEAM}

# team LOC

TOTAL=`cat since_${time}_ssp_prc_vmm_enabling_dev_all.txt | awk '{print $3 " "$4+$5}' | \
awk '{if($1){a[$1] += $2;}} END{for(i in a){print i" "a[i]}} ' | grep -v "^$" | \
awk '{print $2}' | awk 'BEGIN{total=0}{total+=$1}END{print total}'`

cat since_${time}_ssp_prc_vmm_enabling_dev_all.txt | awk '{print $3 " "$4+$5}' | \
awk '{if($1){a[$1] += $2;}} END{for(i in a){print i" "a[i]}} ' | grep -v "^$" | \
sort -nrk 2 | awk -v sum=${TOTAL} '{printf $1 " " $2 " " $3 " " "%04.2f%\n", $2/sum*100 }' | \
column -c 1 -t | nl > ${LINUX_LOC_IN_TEAM}

rm since_${time}*.txt


