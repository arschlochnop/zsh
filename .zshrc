# 如果你来自 bash，你可能需要更改你的 $PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# oh-my-zsh 安装路径
export ZSH="`echo ~`/.oh-my-zsh"

# 设置要加载的主题名称 --- 如果设置为 "random"，它将在每次加载 oh-my-zsh 时
# 加载一个随机主题，在这种情况下，要知道加载了哪个特定主题，请运行：echo $RANDOM_THEME
# 参见 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# 设置随机加载时要从中选择的主题列表
# 当 ZSH_THEME=random 时设置此变量将导致 zsh 从
# 此变量加载主题，而不是在 ~/.oh-my-zsh/themes/ 中查找
# 如果设置为空数组，此变量将不起作用
# ZSH_THEME_RANDOM_CANDIDATES=("robbyrussell" "agnoster")

# 使用区分大小写的补全
# CASE_SENSITIVE="true"

# 使用对连字符不敏感的补全
# 区分大小写的补全必须关闭。_ 和 - 将可以互换
HYPHEN_INSENSITIVE="true"

# 禁用每两周一次的自动更新检查
# DISABLE_AUTO_UPDATE="true"

# 自动更新而不提示
# DISABLE_UPDATE_PROMPT="true"

# 更改自动更新的频率（以天为单位）
export UPDATE_ZSH_DAYS=7

# 如果粘贴 URL 和其他文本不正确，请取消注释以下行
# DISABLE_MAGIC_FUNCTIONS=true

# 禁用 ls 中的颜色
# DISABLE_LS_COLORS="true"

# 禁用自动设置终端标题
# DISABLE_AUTO_TITLE="true"

# 启用命令自动更正
ENABLE_CORRECTION="true"

# 在等待补全时，显示红点
COMPLETION_WAITING_DOTS="true"

# 如果你想禁用将 VCS 下的未跟踪文件标记为脏，请取消注释以下行
# 这使得大型仓库的状态检查更快
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# 如果你想更改历史命令输出中显示的命令执行时间戳，请取消注释以下行
# 你可以设置以下三种可选格式之一：
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# 或使用 strftime 函数格式规范设置自定义格式，
# 有关详细信息，请参见 'man strftime'
# HIST_STAMPS="mm/dd/yyyy"

# 你想使用 $ZSH/custom 以外的其他自定义文件夹吗？
# ZSH_CUSTOM=/path/to/new-custom-folder

# 你想加载哪些插件？
# 标准插件可以在 ~/.oh-my-zsh/plugins/* 中找到
# 自定义插件可以添加到 ~/.oh-my-zsh/custom/plugins/
# 示例格式：plugins=(rails git textmate ruby lighthouse)
# 谨慎添加，因为太多插件会减慢 shell 启动速度
plugins=(git autojump zsh-autosuggestions extract zsh-completions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# 用户配置

# export MANPATH="/usr/local/man:$MANPATH"

# 检测操作系统类型
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS 特定配置
    export PATH="/opt/homebrew/bin:$PATH"  # Homebrew 路径
    export PATH="/opt/homebrew/sbin:$PATH"  # Homebrew sbin 路径
    
    # 设置 macOS 特定的颜色支持
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
    
    # 设置 macOS 特定的终端类型
    export TERM=xterm-256color
    
    # 设置 macOS 特定的语言环境
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    
    # macOS 特定的别名
    alias ls='ls -G'  # 使用 macOS 的彩色 ls
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -CF'
    
    # 设置 macOS 特定的补全
    if type brew &>/dev/null; then
        FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
        autoload -Uz compinit
        compinit
    fi
else
    # Linux 特定配置
    export PATH="/usr/local/bin:$PATH"
    export PATH="/usr/local/sbin:$PATH"
    
    # Linux 特定的别名
    alias ls='ls --color=auto'
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -CF'
fi

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups


#bindkey "\e[H" beginning-of-line # Début
#bindkey "\e[F" end-of-line # Fin
# bindkey "\e[3~" delete-char


# HSTR configuration - add this to ~/.zshrc
alias hh=hstr                    # hh to be alias for hstr
setopt histignorespace           # skip cmds w/ leading space from history
export HSTR_CONFIG=hicolor       # get more colors
bindkey -s "\C-r" "\C-a hstr -- \C-j"     # bind hstr to Ctrl-r (for Vi mode check doc)

first-tab() {
    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi
}
zle -N first-tab
bindkey '^I' first-tab


setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form 'anything=expression'
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# 自定义 git 状态显示函数
function git_status() {
    # 检查当前目录是否是 git 仓库
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # 获取当前分支名
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
            # 检查是否有未提交的更改
            local git_changes=""
            if [ -n "$(git status --porcelain)" ]; then
                git_changes="%F{red}*%f"  # 红色星号表示有未提交的更改
            fi
            # 返回格式化的分支信息
            echo " %F{green}[on   $branch]$git_changes%f"
        fi
    fi
}

# 设置自定义提示符
setopt PROMPT_SUBST

configure_prompt() {
    prompt_symbol=㉿
    # 骷髅 emoji 用于 root 终端
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    
    # 检测终端类型
    if [[ "$TERM" == "xterm-256color" ]]; then
        # 支持真彩色
        color_prompt=yes
    else
        # 回退到基本颜色
        color_prompt=
    fi
    
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS 特定的提示符样式
                PROMPT=$'%F{%(#.blue.green)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}] $(git_status)\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            else
                # Linux 提示符样式
                PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+(${debian_chroot})─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}] $(git_status)\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            fi
            ;;
        oneline)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS 单行提示符
                PROMPT=$'${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            else
                # Linux 单行提示符
                PROMPT=$'${debian_chroot:+(${debian_chroot})}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            fi
            RPROMPT=
            ;;
        backtrack)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS 回溯提示符
                PROMPT=$'${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            else
                # Linux 回溯提示符
                PROMPT=$'${debian_chroot:+(${debian_chroot})}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            fi
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# 以下块被两个分隔符包围
# 这些分隔符不能修改。谢谢。
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # 覆盖默认的 virtualenv 指示器
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt
else
    PROMPT='${debian_chroot:+(${debian_chroot})}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# 如果这是一个 xterm，设置标题为 user@host:dir
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|*xterm-256color)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            TERM_TITLE=$'\e]0;${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
        else
            TERM_TITLE=$'\e]0;${debian_chroot:+(${debian_chroot})}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
        fi
        ;;
    *)
        ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

        # 在提示符之前打印一个空行，但仅当它不是第一行时
        if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
            if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
                _NEW_LINE_BEFORE_PROMPT=1
            else
                print ""
            fi
        fi
    }


# 一些额外的 ls 别名
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# 启用补全功能
autoload -U compinit && compinit

# 加载自定义配置
source $HOME/.zshconfig/.aliases.zsh
source $HOME/.zshconfig/.user_profile.zsh
source $HOME/.zshconfig/.user_aliases.zsh
