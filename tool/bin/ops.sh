#!/bin/sh
function main()
{
    #清理core文件
    ls /home/jk54/core-* >/dev/null 2>&1
    if [ $? -eq 0 ];
    then
        /usr/bin/rm /home/jk54/core-*
    fi
    #备份输入法词典
    cp -urp /home/jk54/.config/fcitx /home/jk54/OneDrive/应用
}
main
