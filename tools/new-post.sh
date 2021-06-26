if [[ "$1" == "" ]]; then
    echo "Usage:"
    echo "  ./new-post.sh ./_post"
    exit 0
fi

post_dir=$1

# Accept a space seperated string, replace spaces with dash.
function space2dash() {
    local ans=""
    for word in $@; do
        if [[ "$ans" == "" ]]; then
            ans="$word"
        else
            ans="$ans-$word"
        fi
    done
    echo $ans
}

echo "Enter Title of post:"

read title

if [[ "$title" == "" ]]; then
    echo "Error: title could't be empty."
    exit 1
fi

echo "Enter language postfix, default: en"

read lan

if [[ "$lan" == "" ]]; then
    lan="en"
fi

f="$post_dir/$(date +%Y-%m-%d)-$(space2dash $title).$lan.markdown"

if [[ -f "$f" ]]; then
    echo "file $f exists."
    exit 1
fi

touch $f

echo "---" > $f
echo "layout: post" >> $f
echo "title:  \"$(space2dash $title)\"" >> $f
echo "date:   $(date +"%Y-%m-%d %H:%M:%S +0800")" >> $f
echo "---" >> $f

