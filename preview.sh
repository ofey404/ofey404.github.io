###
 # @Author: Ofey Chan
 # @Date: 2020-02-29 18:38:38
 # @LastEditors: Ofey Chan
 # @LastEditTime: 2020-02-29 19:03:06
 # @Description: 
 # @Reference: 
 ###

name="JekyllBlog"
running=false

if [ ! "$(docker ps | grep $name)" ]; then
    echo "++ Container $name is not running. ++"
    docker start $name
else
    echo "++ Container $name is running. ++"
    running=true
fi

docker exec -it $name jekyll serve

if [ ! "$running" = true ]; then
    echo "++ Stop contrainer $name ++"
    docker stop $name
fi