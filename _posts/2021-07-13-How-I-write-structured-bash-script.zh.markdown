---
layout: post
title:  "下一次我会如何写结构化的 bash script"
date:   2021-07-13 13:35:26 +0800
lang: 中文
lang-ref: 2021-07-13-How-I-write-structured-bash-script
---

以及我在编写和维护一个 500+ 行的 bash 项目中学到的事情。

太长不看版：

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

参考:
- 英文:
    - [koalaman/shellcheck](https://github.com/koalaman/shellcheck)
    - [bahamas10/bash-style-guide](https://github.com/bahamas10/bash-style-guide)
    - [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- 中文:
    - [编写Shell脚本的最佳实践 - Mythsman 的博客](https://blog.mythsman.com/post/5d2ab67ff678ba2eb3bd346f/)
    - [编写可靠 bash 脚本的一些技巧 - 腾讯技术工程](​https://zhuanlan.zhihu.com/p/123989641)，包含了一些杀掉所有子进程之类的魔法。

## 脚本头部

1. shebang，`#!/usr/bin/env bash`。
2. 调试输出，`set -x`。
3. 更严格的退出，`set -euo pipefail`。
4. 显式写出 main 函数，在脚本最后调用 `main "$@"`。

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

`set -x` 打印每一条执行的命令，展开变量和 alias。

`set -euo pipefail`：

`set -e` 任何一个命令返回非 0 时，立刻退出。

覆盖 bash 的默认行为——失败时继续运行下一条命令。如果需要显式忽略返回值，可以用 `cmd || true` 或者 `cmd || RET=$?`。

`set -o pipefail` 管道中的任何一个命令失败时，整个管道都失败。和 `set -e` 配合。

`set -u` 试图使用未定义的变量时直接退出。

## 函数

1. 不使用 function keyword，使用 `foo() {}` 声明。
2. 内部变量声明为 local。
3. 函数的参数先显式地传递给一个局部变量，避免在函数体中直接使用 `$1`。可以在阅读代码时起到类似函数签名的作用。

```bash
foo() {
    local arg1="$1"

    local i=foo      # local variable

    echo $arg1       # Always use local variable of argument
    # echo $1        # Wrong!
}
```

使用 `foo() {}` 声明：在这点上若干个文档保持了出奇一致的态度，但是我还不知道为什么。
- [bahamas10/bash-style-guide](https://github.com/bahamas10/bash-style-guide#functions)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s7.1-function-names)

## 代码的规模

> If you are writing a script that is more than 100 lines long, or that uses non-straightforward control flow logic, you should rewrite it in a more structured language now. Bear in mind that scripts grow. Rewrite your script early to avoid a more time-consuming rewrite at a later date.
>
> -- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s7.1-function-names)

虽然可以用 `source util.sh` 把一部分功能做成库的形式，但是不建议包含太多文件。

超过这些准则，我会考虑重写：
- 文件不超过两个，即 `main.sh` 和 `util.sh`。
- 超过 200 行代码。
- 超过『保存某个东西到文件』程度的数据结构。

shell script 处理太复杂的数据结构会很痛苦。虽然可以通过嵌入 jq 之类的数据操纵语言来完成，但是传参给 jq 又会受到 shell word splitting 的影响。例子详见 [stedolan/jq: runs from command line not in shell script #1124](https://github.com/stedolan/jq/issues/1124)

## 静态检查和代码格式化

静态检查可以使用 [koalaman/shellcheck](https://github.com/koalaman/shellcheck)


有趣的是，它会给出自己的 wiki 中每个错误的参考链接，很值得学习。

```bash
For more information:
  https://www.shellcheck.net/wiki/SC2124 -- Assigning an array to a string! A...
  https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
```

另外 `shellcheck -f <format>` 支持不同格式的输出，不过 diff 格式输出好像会少掉一部分报告，所以还是默认值吧。

diff 格式可以用 ydiff 看。

```bash
shellcheck -f diff to-be-checked.sh | ydiff -w 0 -s
```

代码格式化可以使用 [shfmt](https://github.com/mvdan/sh)。`shfmt -w` 写入原文件。

## 杂项

在条件判断时使用 `[[]]`，算术表达式使用 `(())`。

用 `$()` 而不是 \`\` 执行命令。backtick 在嵌套的时候需要转义。

使用 `source` 而不是 `.` 来 source 文件。

尽量用 array 代替 space splited string。

全局常量显式地设置成 readonly。

```bash
FLAGS=( --foo --bar='baz' )
readonly FLAGS
```

尽量使用 bash builtin，如生成序列。

```bash
# instead of seq command
for f in {1..5}; do
    ...
done

for ((i = 0; i < n; i++)); do
    ...
done
```

## 坑点

不要解析 ls 的输出。在不同的机器上 ls 的显示可能不同。使用 bash builtin。

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

小心 cd 失败。

```bash
cd /some/path || exit
rm file
```

不要使用 [pipe to while](https://google.github.io/styleguide/shellguide.html#pipes-to-while)。pipeline 产生 subshell，在 pipeline 中修改变量不会改变原本的值。

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
