rsync -avu --delete --exclude ".git" "_site/" "../ofey404.github.io" 

current=`pwd`

echo "Enter commit message(press enter to use date as default)"

read cm

if [ "$cm" = "" ]; then
    cm=`date`
    echo "++ Commit Message ++"
    echo $cm
    echo "++++"
fi

cd ../ofey404.github.io 

git add -A
git commit -m "$cm"
git push

echo "Push complete"

cd $current
