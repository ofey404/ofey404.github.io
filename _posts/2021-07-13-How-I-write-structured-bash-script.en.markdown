---
layout: post
title:  "How will I write structured bash script"
date:   2021-07-13 13:35:26 +0800
lang: English
lang-ref: 2021-07-13-How-I-write-structured-bash-script
---

And what I learnt while writing and maintaining a 500+ line bash project.

TL;DR:

```bash
#!/usr/bin/env bash
set -x             # for debug
set -euo pipefail  # fail early

source util.sh
# . util.sh

GLOBAL_CONST=( --foo --bar='baz' ) # use array when possible
# GLOBAL_CONST="--foo --bar='baz'"

readonly GLOBAL_CONST              # readonly global const

# use func() {} definition
func_style() {
    local arg1="$1"
    local arg2="$2"

    echo "$arg1"     # Don't use $1 directly.
    # echo $1        # Wrong!
}

# use [[]], (())
control_style() {
    if [[ -n "${my_var}" ]]; then 
        do_something
    fi

    if (( my_var > 3 )); then
        do_something
    fi
}

main(){
    arg1=$(func_style "$1")  # use $() instead of ``
}

main "$@"
```

Ref:
- English:
    - [koalaman/shellcheck](https://github.com/koalaman/shellcheck)
    - [bahamas10/bash-style-guide](https://github.com/bahamas10/bash-style-guide)
    - [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Chinese:
    - [编写Shell脚本的最佳实践 - Mythsman 的博客](https://blog.mythsman.com/post/5d2ab67ff678ba2eb3bd346f/)
    - [编写可靠 bash 脚本的一些技巧 - 腾讯技术工程](​https://zhuanlan.zhihu.com/p/123989641). It contains some black magic such as kill all subprocess when script exits.

## Head of script

1. shebang, `#!/usr/bin/env bash`
2. debug output, `set -x`
3. stricter fail strategy, `set -euo pipefail`
4. write and call main explictly, `main "$@"`

```bash
#!/usr/bin/env bash
set -x  # For debug
set -euo pipefail

func(){
    #do sth
}

main(){
    func
}

main "$@"
```

`set -x` will print all command(expanded) during execution.

`set -euo pipefail`：

`set -e` exit immediately if a pipeline (which may consist of a single simple command),  a list,  or a compound command (see SHELL GRAMMAR above), exits with a non-zero status.

Override the default behavior of bash, which will run the next command. If we want to ignore return value explicitly, `cmd || true` or `cmd || RET=$?` can be used.

`set -o pipefail` If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully.

`set -u` Treat unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter expansion.

## Function

1. Declare with `foo() {}` style.
2. Use keyword local.
3. Pass argument of variable to a local variable at the beginning of function. This help readers, serving as a function fingerprint.

```bash
foo() {
    local arg1="$1"

    local i=foo      # local variable

    echo $arg1       # Always use local variable of argument
    # echo $1        # Wrong!
}
```

Declare with `foo() {}` style: I don't know why, but all documentations I found say so.
- [bahamas10/bash-style-guide](https://github.com/bahamas10/bash-style-guide#functions)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s7.1-function-names)

## Size of project

> If you are writing a script that is more than 100 lines long, or that uses non-straightforward control flow logic, you should rewrite it in a more structured language now. Bear in mind that scripts grow. Rewrite your script early to avoid a more time-consuming rewrite at a later date.
>
> -- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s7.1-function-names)

Though `source util.sh` can do something like include a library, but I strongly recommend to use it limitly.

If one of those rules are violated, I would take rewrite into consideration:
- No more than two files, `main.sh` and `util.sh`.
- Code less than 200 lines.
- Complex data structure, more than just save something to file.

It's a pain in the ass when dealing with complex data structure with shell script. Though we can use embedded DSL, such as jq, but shell word splitting would mess up parameter passing. eg: [stedolan/jq: runs from command line not in shell script #1124](https://github.com/stedolan/jq/issues/1124)

## Static check & Foramtting

Static check: [koalaman/shellcheck](https://github.com/koalaman/shellcheck)

The 'For more information' part of output is so good.

```bash
For more information:
  https://www.shellcheck.net/wiki/SC2124 -- Assigning an array to a string! A...
  https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
```

Besides `shellcheck -f <format>` support multiple formats, but it seems that format of diff would miss some error report.

We can view diff format output with `ydiff`:

```bash
shellcheck -f diff to-be-checked.sh | ydiff -w 0 -s
```

Code format: [shfmt](https://github.com/mvdan/sh). `shfmt -w` write inplace.

## MISC

Use `[[]]` and `(())`.

Execute command with `$()` rather than backtick.

When sourcing file, use `source` instead of `.`.

Use array instad of space splited string, if possible.

Set global constants as readonly.

```bash
FLAGS=( --foo --bar='baz' )
readonly FLAGS
```

Use bash builtin when possible. eg: sequence generation

```bash
# instead of seq command
for f in {1..5}; do
    ...
done

for ((i = 0; i < n; i++)); do
    ...
done
```

## Pitfalls

Do not parse output of `ls`.

```bash
# very wrong, potentially unsafe
for f in $(ls); do
    ...
done

# right
for f in *; do
    ...
done
```

Be aware of the possibility of cd failing, it can mess up everything...

```bash
cd /some/path || exit
rm file
```

Do not use [pipe to while](https://google.github.io/styleguide/shellguide.html#pipes-to-while)

Pipes create a subshell, so any variables modified within a pipeline do not propagate to the parent shell.

```bash
last_line='NULL'
your_command | while read -r line; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done

# This will always output 'NULL'!
echo "${last_line}"
```
