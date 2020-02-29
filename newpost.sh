#!/bin/bash
###
 # @Author: Ofey Chan
 # @Date: 2020-02-29 17:27:12
 # @LastEditors: Ofey Chan
 # @LastEditTime: 2020-02-29 17:40:54
 # @Description: 
 # @Reference: 
 ###
d=`date '+%F'`
t=`date '+%T'`

echo "input post file name"

read fn

fp=_posts/$d-$fn.md

if test -f "$fp"; then
    echo "file name exists, $fp"
    exit 0
fi

touch $fp

echo "---" > $fp
echo "layout: post" >> $fp
echo "title: {} " >> $fp
echo "description: {}" >> $fp
echo "date: $d $t +0800" >> $fp
echo "categories: {}" >> $fp
echo "---" >> $fp