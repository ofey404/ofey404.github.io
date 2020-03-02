filename=_config.yml
linenumber=`grep -n tagline ${filename} | grep -Eo '^[^:]+'`

re='^[0-9]+$'

quotes=(
"But I, unfortunately, I do not know how to see the sheep through the crates."
"As we wind on down the road, our shadows taller than our soul."
"How many roads must a man walk down, before you call him a man?"
)

selectedQuote=${quotes[$RANDOM % ${#quotes[@]}]}

if ! [[ $linenumber =~ $re ]]; then 
    echo "not found tagline" >&2
    exit 1
fi

sed -i "" "${linenumber}d" ${filename}

sed -i '' "${linenumber}i\\
\ \ tagline: \"${selectedQuote}\"
" $filename

echo "++ randomly changed tagline on homepage to: ++"
echo $selectedQuote
