#!/bin/sh

local="false"
remote="false"

if read -t50 -p "请输入要删除分支<模糊匹配>：" regexp
then
    if read -t50 -n1 -p "是否删除本地分支(y/n)：" local
    then
        echo
        case $local in 
        Y|y):
        local="true";;
        N|n):
        local="false";;
        *)
        echo "请输入y或n" && exit 0 ;;
        esac
    else    
        exit 0    
    fi       
    if read -t50 -n1 -p "是否删除远端分支(y/n)：" remote
    then
        echo
        case $remote in 
        Y|y):
        remote="true";;
        N|n):
        remote="false";;
        *)
        echo "请输入y或n" && exit 0 ;;
        esac
    else
        exit 0   
    fi        
else
    exit 0
fi        

islocal=`git br | grep ${regexp} | wc -l`  
isremote=`git br -r | grep ${regexp} | wc -l`  

if [ $isremote -gt 0 ]
then
    if [ $remote == "true" ] 
    then
        echo '-----------remote--------------'
	git br -r | grep ${regexp} | xargs -n 1000  
        git br -r | grep ${regexp} | cut -d '/' -f2 | xargs -n1 -I {} git push origin --delete {}
        echo "delete ${regexp} remote branch all ok"
        echo "${regexp} remote branch num---->`git br -r | grep ${regexp} | wc -l`"
    fi
else
    echo "${regexp} remote branch is not exist"
fi

if [ $islocal -gt 0 ]
then
    if [ $local = "true" ] 
    then
	echo '-----------local--------------'
        git br | grep ${regexp} | xargs -n 1000
        git br | grep ${regexp} | xargs -n1 -I {} git branch -D {}
        git fetch origin --prune
        git fetch origin
        echo "delete ${regexp} local branch all ok"
        echo "${regexp} local branch num---->`git br | grep ${regexp} | wc -l`"
    fi
else
    echo "${regexp} local branch is not exist"
fi

exit 0
