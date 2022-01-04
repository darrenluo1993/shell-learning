#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
	999) echo "你输入的数字为 $aNum，游戏结束！"
	    exit
	;;
        *) echo "你输入的数字不是 1 到 5 之间的!"
            continue
        ;;
    esac
done
