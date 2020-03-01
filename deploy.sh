rsync -avu --delete --exclude ".git" "_site/" "../ofey404.github.io" 

current=`pwd`

echo "Enter commit message"

read cm

if [ "$cm" = "" ]; then
    cm=`date`
    exit 0
fi

cd ../ofey404.github.io 

git add -A
git commit -m "$cm"
git push

echo "Push complete"

cd $current
