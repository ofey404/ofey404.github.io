---
layout: post
title:  How to recover your bashrc
date: 2021-03-16 22:56 +0800
lang: English
lang-ref: 2021-03-16-how-to-recover-bashrc
---

If you deleted your bashrc by accident, don't close current shell! Many valuable configurations can be extracted from it.

Or maybe you make these mistakes:
- While adding new environment variable with `<<`, mistyping it as `<`.
- Reversing source and destination while copying...

If you work under a version control system, you are lucky cause everything can be recovered. Or this post may help.

## Environment variables

```bash
env
# SHELL=/bin/bash
# SESSION_MANAGER=local/unix:@/tmp/.ICE-unix/2668,unix/unix:/tmp/.ICE-unix/2668
# ...
```

## Function definition

```bash
declare -F
# declare -f j
# declare -f jc
# declare -f unproxy
# ...
```

Executing this will print commands to show every bash function in current environment.

## Aliases

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

## The template bashrc of system

```bash
cat /etc/skel/.bashrc 
```

## Things lost forever
All `source ... `, for bash won't remember which file has been sourced. It just change the environment according the file.

The logic in bashrc is lost, eg: When login with ssh, set `$EDITOR` to `vim`.

## After all, good luck!

## Reference
- https://askubuntu.com/questions/404424/how-do-i-restore-bashrc-to-its-default
