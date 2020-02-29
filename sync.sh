rsync -avu --delete --exclude ".git" "_site/" "../ofey404.github.io" 

current=`pwd`
cd ../ofey404.github.io 
pwd

cd $current
