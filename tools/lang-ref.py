#!/usr/bin/python3
# Genreate lang-ref attributes from the filename of posts
# 
# My jekyll code would read attribute `lang-ref` and `lang` in posts,
# in order to generate multi-language posts.
# 
# But manually filling the attributes is clumsy, so I decided to generate
# them according to filename of posts.
#
# eg:
# 2021-06-20-welcome-to-jekyll.en.markdown
# - tag: en
# - lang-ref: 2021-06-20-welcome-to-jekyll
# - lang: English

import sys
from pathlib import Path
import fileinput

HELP_MESSAGE="""Usage:
lang-ref.py path_to_posts
"""

TAG2LANG = dict({
    "en": "English",
    "zh": "中文",
})

def has_lang_tag(file: Path):
    if len(file.name.split(".")) != 3:
        return False
    return True

def handle_lang(file: Path):
    lang_ref, tag, _ = file.name.split(".")
    lang = TAG2LANG[tag]

    with fileinput.input(file, inplace=True) as f:
        line = None
        met_3_dash = False
        met_lang = False
        met_lang_ref = False
        end = False
        for line in f:
            if end:
                print(line, end="")

            kv = [s.strip() for s in line.split(":")]
            
            if kv[0] == "lang":
                print(line.replace(kv[1], lang), end="")
                met_lang = True
            elif kv[0] == "lang_ref":
                print(line.replace(kv[1], lang_ref), end="")
                met_lang_ref = True
            elif line == "---\n" and met_3_dash:
                if not met_lang:
                    print("lang: {}", TAG2LANG[tag])
                if not met_lang_ref:
                    print("lang_ref: {}", lang_ref)
                print(line, end="")
                end = True
            elif line == "---\n" and not met_3_dash:
                met_3_dash = True
                print(line, end="")
            else:
                print(line, end="")


def main():
    if len(sys.argv) == 1:
        print(HELP_MESSAGE)
        return 0

    posts = Path(sys.argv[1])

    markdowns = list(posts.rglob("**/*.markdown"))
    markdowns.extend(posts.rglob("**/*.md"))

    for f in markdowns:
        if has_lang_tag(f):
            handle_lang(f)

if __name__ == "__main__":
    main()