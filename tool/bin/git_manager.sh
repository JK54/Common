#!/bin/bash
#author:myself

#方便代码上传github
function Git()
{
	prepath=/home/jk54/Inventory
	function backupconfig()
	{
		#不用括号括起来elements就不会被包装成数组,虽然不影响for循环，但是获取到的元素个数就会变成1
		elements=($2)
		count=0
		echo "Back up ${#elements[@]} files from $1."
		for i in ${elements[@]}
		do
			echo $1/$i
			diff $1/$i $3/$i
			if [ $? -ne 0 ]
			then
				cp -a $1/$i $3/$i
				echo "updated"
				count=`expr $count + 1`
			fi
		done
		
		if [ $count -eq 0 ]
		then
			echo "No config file changed since last backup,so none has been backed up."
		fi

		echo -e '\n'
		
		return 0
	}
	
	function Backupconfig()
	{
		home=/home/jk54
		sysctlpath=/usr/lib/systemd/system
		backpath=/home/jk54/Inventory/Common/config
		echo "Updating config files..."
		#[*]与[@]都可以获取所有元素，但是传递给函数时[@]只会传递第一个元素，还不明白为什么，先备注
		cc1=(.tmux.conf .vimrc .bashrc .bash_aliases .bash_profile .globalrc)
		backupconfig  "$home" "${cc1[*]}"  "$backpath"
		
		cc2=(.ycm_extra_conf.py)
		backupconfig "$home/.vim" "${cc2[*]}" "$backpath"

		cc3=(profile)
		backupconfig  "/etc" "${cc3[*]}" "$backpath/etc"
		
		cc4=(gfwlist.service ssr.service)
		backupconfig "$sysctlpath"  "${cc4[*]}" "$backpath/usr"

		return 0
	}

	function Xclear()
	{
		count=0
		#第二个find是为了删除没有后缀的文件，但是.git目录下有很多，所以为了防止误删，另外写了一个find
		cc=(`find $1 -name "*.exe" -o -name "*.o" -o -name "a.out" -o -name "*.core"` `find $1 -prune -a ! -path $prepath/$1/.git -prune -a ! -name "*.*" -type f`)
		echo "Removing temporary files..."
		for i in ${cc[@]}
		do
			echo $i
			rm -rf $i
			count=`expr $count + 1`
		done

		if [ $count -eq 0 ]
		then
			echo "No temporary file deleted."
		fi

		return 0
	}

	function Push()
	{
		cd $1
		if [ $? -ne 0 ]
		then
			return 1
		fi
		result=`git status -s`
		if [ "$result" != "" ]
		then
			echo "update $1."
			git add -A .
			read -p $'input the comment.press enter to set the default string "dididi".\x0a' alien
			if [ "$alien" == "" ];
			then
				alien=dididi
			fi
			echo $alien
			git commit -m "$alien"
			git push
		else
			echo "$prepath/$1 is unchanged.nothing has been done"
		fi
	}

	function Select()
	{
		echo '1、/home/jk54/Inventory/Code'
		echo '2、/home/jk54/Inventory/FTP'
		echo -e
		read -p $'select from the above num,0 mark as none.enter to select all : ' choice
		cc=(/home/jk54/Inventory/Code /home/jk54/Inventory/FTP)
		if  [[ $choice -eq "1" ]]
		then
			Xclear "/home/jk54/InventoryCode"
			Push "/home/jk54/Inventory/Code"
		elif  [[ $choice -eq "2" ]]
		then
			Xclear "/home/jk54/Inventory/FTP"
			Push "/home/jk54/Inventory/FTP"
		elif  [[ $choice -eq "" ]]
		then
			for i in ${cc[@]}
			do
				Xclear $i
				Push $i
			done
		fi
		Push "/home/jk54/Inventory/Common"
	}
	Backupconfig
	Select
}

main()
{
	pp=`pwd`
	#收到中断信号就回到原来目录，并返回执行错误
	trap 'cd $pp;exit 1;' SIGINT
	Git
}

main
