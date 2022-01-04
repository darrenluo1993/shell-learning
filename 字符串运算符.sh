#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

a="abc"
b="efg"
c=aaa
d=bbb
e=ttt
f=ttt

if [ $a = $b ]
then
   echo "$a = $b : a 等于 b"
else
   echo "$a = $b: a 不等于 b"
fi
if [ $a != $b ]
then
   echo "$a != $b : a 不等于 b"
else
   echo "$a != $b: a 等于 b"
fi
if [ -z $a ]
then
   echo "-z $a : 字符串长度为 0"
else
   echo "-z $a : 字符串长度不为 0"
fi
if [ -n "$a" ]
then
   echo "-n $a : 字符串长度不为 0"
else
   echo "-n $a : 字符串长度为 0"
fi
if [ $a ]
then
   echo "$a : 字符串不为空"
else
   echo "$a : 字符串为空"
fi

if [[ $c < $d ]]
then
   echo "$c < $d 返回 true"
else
   echo "$c < $d 返回 false"
fi

if (( $c <= $d ))
then
   echo "$c <= $d 返回 true"
else
   echo "$c <= $d 返回 false"
fi

if [ $e == $f ]
then
   echo "$e == $f 返回 true"
else
   echo "$e == $f 返回 false"
fi

if [[ $e == $f ]]
then
   echo "$e == $f 返回 true"
else
   echo "$e == $f 返回 false"
fi

if (( $e == $f ))
then
   echo "$e == $f 返回 true"
else
   echo "$e == $f 返回 false"
fi
