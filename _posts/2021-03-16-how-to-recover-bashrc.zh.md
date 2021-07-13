---
layout: post
title:  如何恢复误删的 bashrc
date: 2021-03-16 22:56 +0800
lang: 中文
lang-ref: 2021-03-16-how-to-recover-bashrc
---

如果你不慎删除了 bashrc，请不要马上关闭现有的 shell。许多有价值的信息可以从其中恢复。

当然也可能是遇到了如下的情况：
- 在增加环境变量的时候手贱把 `<` 打成了 `<<`
- 不慎在备份 bashrc 的时候搞错了 cp 的方向

当然如果在版本控制系统下面操作，以上的错误都可以恢复。

## 环境变量

```bash
env
# SHELL=/bin/bash
# SESSION_MANAGER=local/unix:@/tmp/.ICE-unix/2668,unix/unix:/tmp/.ICE-unix/2668
# ...
```

## 函数

```bash
declare -F
# declare -f j
# declare -f jc
# declare -f unproxy
# ...
```

执行打印出的命令，就可以打印出函数的定义。

## 别名

```bash
alias
# ...
# alias tr='todo remove'
# alias typora='/opt/typora/Typora'
# alias vim='nvim'
# alias which='(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot'
# alias xzegrep='xzegrep --color=auto'
# alias xzfgrep='xzfgrep --color=auto'
# alias xzgrep='xzgrep --color=auto'
# ...
```

## 系统的 bashrc 模板

```bash
cat /etc/skel/.bashrc 
```

## 不能恢复的东西
`source ... ` 语句，和用于判断的逻辑。

## 祝你好运！

## Reference
- https://askubuntu.com/questions/404424/how-do-i-restore-bashrc-to-its-default
