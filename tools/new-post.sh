#!/bin/bash
# set -x
set -euo pipefail

check_args() {
	local args="$@"

	if [[ "$args" == "" ]]; then
		echo "Usage:"
		echo "  ./new-post.sh ./_post"
		exit 0
	fi
}

# eg: space seperated line -> space-seperated-line
space2dash() {
	local args="$@"

	local ans=""
	for word in $args; do
		if [[ "$ans" == "" ]]; then
			ans="$word"
		else
			ans="$ans-$word"
		fi
	done
	echo $ans
}

create() {
	local file="$1"
	local title="$2"

	{
		echo "---"
		echo "layout: post"
		echo "title:  \"$title\""
		echo "date:   $(date +"%Y-%m-%d %H:%M:%S +0800")"
		echo "---"
	} >"$file"
}

main() {
	check_args "$@"

	local post_dir="$1"

	echo "Enter Title of post:"
	read -r title
	if [[ "$title" == "" ]]; then
		echo "Error: title could't be empty."
		exit 1
	fi

	echo "Enter language postfix, default: en"
	read -r lan
	if [[ "$lan" == "" ]]; then
		lan="en"
	fi

	f="$post_dir/$(date +%Y-%m-%d)-$(space2dash $title).$lan.markdown"
	if [[ -f "$f" ]]; then
		echo "file $f exists."
		exit 1
	fi

	create "$f" "$title"
}

main "$@"
