#!/bin/bash
#更新开源项目源码
#opengrok-sync的python脚本执行有问题,懒得debug
srcdir=/usr/share/java/opengrok/src
cd $srcdir
pid={}
i=0
for dir in *;
do
    dst=$srcdir/$dir
    cd $dst
    # git pull  
    git pull >/dev/null 2>&1 &
    pid[$i]=$!
    i=$((i+1))
    cd ..
done
for p in ${pid[*]};
do
    wait $p
done
#更新opengrok的项目
opengrok-indexer -j /usr/bin/java -J=-Djava.util.logging.config.file=/usr/share/java/opengrok/etc/logging.properties -a /usr/share/java/opengrok/lib/opengrok.jar -- -c /usr/bin/ctags -s /usr/share/java/opengrok/src -d /usr/share/java/opengrok/data -H -P -S -G -W /usr/share/java/opengrok/etc/configuration.xml -U http://localhost:8080/source
