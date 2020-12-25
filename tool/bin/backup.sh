#!/bin/bash
backuppath=/
excludefiles=(dev proc tmp boot var/cache var/lock var/log var/run  lost+found media mnt run sys swapfile vmlinuz vmlinuz.old initrd.img initrd.img.old) 
backupfilepath=/media/jk54/Data/
backupfilename=$backupfilepath"backup`date +"%Y%m%d%H%M"`.tar.gz"
backuplogname=$backupfilepath"backup`date +"%Y%m%d%H%M"`.log"
processnum=$(expr `cat /proc/cpuinfo| grep "processor"| wc -l` / 2) #全核压缩SSD温度太高
cmd="sudo tar -cvpP --use-compress-program='pigz -6 -p $processnum' -f $backupfilename"
for i in ${excludefiles[@]}
do
	cmd=""$cmd" --exclude=$backuppath$i"
done
cmd="$cmd $backuppath"
cmd="$cmd "\>\>" $backuplogname"
echo $cmd
echo -e
