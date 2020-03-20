filename=_config.yml
linenumber=`grep -n tagline ${filename} | grep -Eo '^[^:]+'`

re='^[0-9]+$'

quotes=(
"But I, unfortunately, I do not know how to see the sheep through the crates."
"As we wind on down the road, our shadows taller than our soul."
"How many roads must a man walk down, before you call him a man?"
"O that this too too solid flesh would melt, thaw, and resolve itself into a dew!"
"There must be someway out of here, said the joker to the thief."
"I'm a joker, I'm a smoker, I'm a midnight toker, I sure don't want to hurt no one."
"Tell me and I forget. Show me and I remember. Involve me and I understand."
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
