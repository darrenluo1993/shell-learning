#!/bin/bash

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done

echo ================

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   let a++
done

echo ================

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=$[a+1]
done

echo ================

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=$((a+1))
done
