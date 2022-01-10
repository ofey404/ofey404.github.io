---
layout: post
title:  "简单电脑 tweak 收集"
date:   2022-01-10 22:41:59 +0800
lang: 中文
lang-ref: 2022-01-10-my-user-settings
---

我推荐的一些简单电脑 tweak，最长的使用时间已经接近两年，对手指康复和身心健康有一定好处。

配置原则是简单粗暴，尽量选用常见的东西。同时在工具中取公共按键集合（类 vim + 工具内置命令），在整个计算机环境中保持一致。

部分配置可以参见 [ofey404/dotfiles](https://github.com/ofey404/dotfiles)。

每篇内按照必要度从高到低排序。

## OS 篇

- caps 映射 ctrl，之后 ctrl / alt / super 互换。
  - 左手大拇指按 ctrl，可以做出一个更自然的姿势。
- ctrl-enter 映射到切换应用，即 alt - tab。
  - 可以缓解左手小指承担的功能过多，导致劳损的问题。
  - 使用习惯是永远每个桌面上只开两个应用，可以无脑切换。

在整个计算机环境的设定中，hjkl 有相当明确的意义。或者说就是参照 vim + vscode 的某个功能子集，在所有常用的应用和系统上实现了相似的意义。

- super-j，super-k 切换虚拟桌面。
- super-h 打开剪贴板历史。

## VSCode 篇

在接受它某种程度上和 emacs 有相似性以后思路就打开了——自带一套 UI/UX 框架加一门还不错的脚本语言。然后就写了一两个 vscode 插件。

[配置文件](https://github.com/ofey404/dotfiles/tree/master/vscode)

- vim 插件。这部分和 vim 保持一致，和 vimrc 放在一起看，功能其实是 vscode 和 vim8 都能实现的一个子集，甚至还兼容 ideavim。
  - ctrl-w 映射到 `,`，没有损失特别多的东西。能够迅速地按下 `,v` 分屏。
  - jk 映射到 esc。常见。
- ctrl-h / ctrl-l 映射到转移焦点到左右编辑器组上。加上 shift 设定成把编辑器 tab 在左右 group 之间移动，很直觉。
- ctrl-j 打开 terminal。ctrl-shift-j terminal 最大化。
  - vscode 作为一个终端模拟器使用相当不赖。可以向下兼容终端工作流。同时可以让 shell 感知到自己在 intergrated terminal 中从而达成一些联动。
- ctrl-m 额外的 show all commands，和 F1 / ctrl-shift-p 相同。
  - 和 vivaldi 浏览器保持一致。可以减少手指劳损，多用命令，少记忆快捷键。
- ctrl-k show hover，ctrl-j/k 是放弃了纵向切分屏幕之后，换来的两个核心键位。
- ctrl-b toggle sidebar。和浏览器保持一致。
- 自动保存。减少神经质的 `:w` 的习惯。

- 设置了一个环境变量，稍后 shell 篇会用到。

```json
"terminal.integrated.env.linux": {
  "IN_VSCODE_INTEGRATED_TERMINAL": "true"
},
```

## vim 篇

基本没装插件，键绑定参见上一篇 vscode 部分。integrated terminal 能用就行，没啥特别要求。


## shell 篇

自认为比较满意的部分，把 shell 作为胶水，联系起所有的部分。

使用 bash，因为它随处可见。这样配置之后 shell 可以当作一个启动器来使用，也可以成为全功能的开发环境。

[配置文件](https://github.com/ofey404/dotfiles/blob/master/bashrc)。下面根据例子说主导思路吧：

感知是否在 vscode integrated terminal 中，设置好 editor 变量。

```bash
if [[ -z "$IN_VSCODE_INTEGRATED_TERMINAL" ]]; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=code
    export VISUAL=code
fi
alias e="$EDITOR"
```

一些单键触发的 alias：


```bash
alias a="$PAGER"
alias c="$SYSTEM_CLIPBOARD_COMMAND"
alias e="$EDITOR"
alias l='ls -CF'
alias m='make'
alias x='xdg-open' # 系统对应的命令行启动器，比如 mac 的 open
alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
```

重映射了一些控制字符，函数的实现可以进一步参照配置文件。在这些函数中，使用了 bash 的 `READLINE_LINE` 和 `READLINE_POINT` 来操纵当前行缓冲区的内容。

```bash
stty stop undef
bind -x '"\C-s": pet-select'
stty kill undef
bind -x '"\C-u": kill-to-system'
bind -x '"\C-g": gitui'
bind -x '"\C-h": leave-ranger-with-cd'
stty discard undef
bind -x '"\C-o": fzf-cd-with-linebreak'
```

一些外部工具：ranger，fzf，pet。


## 浏览器

我暂时使用 vivaldi，是目前主流浏览器中唯一有开箱即用的内置命令的。nyxt 太不成熟。

- vim 插件。
- ctrl-m，ctrl-p，ctrl-shift-p，:，均映射到唤起内置命令行，简单粗暴，不用思考。

没别的了，只要用的东西够少，就很容易取一个统一的键位子集，0 学习成本。
