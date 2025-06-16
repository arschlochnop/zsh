alias a='nano ~/.aliases.zsh'
alias zshreload='source ~/.zshrc'



alias tailf='tail -F'

# ====================== 文件列表相关别名 ======================
# 基础 ls 命令，带颜色和分类显示
alias ls=' ls  --color=auto -CF'  # 分类显示，带颜色
alias l='ls  --color=auto -CF'    # ls 的简写形式

# 高级文件列表命令
alias lll='ls -Alh --sort=size . | tr -s " " | cut -d " " -f 5,9'  # 按文件大小排序，只显示大小和文件名
alias ll='ls -latrh'              # 按时间倒序显示，包含隐藏文件，人类可读大小
alias lal='ls -Alh'               # 显示所有文件（包括隐藏文件），人类可读大小
alias l.='ls .[A-Za-z]*'          # 只显示隐藏文件
alias la='ls -CF -A'              # 显示所有文件（包括隐藏文件），分类显示
alias dir='ls --color=auto --format=vertical'    # 垂直格式显示
alias vdir='ls --color=auto --format=long'       # 长格式显示
alias lc='ls *.cpp'               # 只显示 .cpp 文件
alias lnew='ls -ld *(/om[1])'     # 显示最新创建的目录
alias lm='ls -tld **/*(m-2)'      # 显示当前目录树中更新时间超过2天的文件

# ====================== 常用命令优化别名 ======================
# 搜索和查看命令
alias grep='grep -in --color'     # 搜索时忽略大小写，显示行号，带颜色

# 磁盘和文件系统命令
alias du='du -h'                  # 以人类可读格式显示磁盘使用情况
alias df='df -h'                  # 以人类可读格式显示文件系统使用情况

# 系统命令
alias sudo='nocorrect sudo'       # 禁用 sudo 命令的自动纠正

# 文件操作命令（带安全保护）
alias rm='rm -i'                  # 删除前询问确认
alias mv='mv -i'                  # 移动前询问确认
alias cp='cp -r'                  # 递归复制
alias mkdir='mkdir -p'            # 创建目录时自动创建父目录

# ====================== 网络相关别名 ======================
# 网络连接测试
alias p8='ping 8.8.8.8'           # 测试与 Google DNS 的连接
alias pb='ping www.baidu.com'     # 测试与百度的连接
alias p='proxychains '            # 通过代理执行命令

# ====================== SSH 相关别名 ======================
# SSH 连接配置
alias proxyssh='ssh -v -o "ProxyCommand nc -x 127.0.0.1:20808 -X 5  %h %p" -o TCPKeepAlive=yes -o ServerAliveInterval=300'  # 通过代理连接 SSH
alias addssh='ssh-copy-id'        # 快速添加 SSH 公钥到远程服务器

# ====================== 全局别名 ======================
# 进程管理
alias k9='kill -9'                # 强制终止进程
alias ka="killall"                # 终止所有匹配的进程

# 目录导航
alias ..=' cd ..; ls'             # 返回上级目录并列出文件
alias ...=' cd ..; cd ..; ls'     # 返回上上级目录并列出文件

# 开发服务器
alias server='python -m SimpleHTTPServer'  # 启动简单的 HTTP 服务器

# 文件类型关联
alias -s deb="sudo dpkg -i"       # 直接安装 .deb 文件
alias -s jar="java -jar"          # 直接运行 .jar 文件

# Docker 相关
alias dockerps='docker ps -a'     # 显示所有 Docker 容器（包括未运行的）

# 文件系统操作
alias opendir='xdg-open ./'       # 使用系统默认程序打开当前目录

# Git 代理操作
alias pgit='p git clone'          # 通过代理克隆 Git 仓库

# 显示我的外网IP地址
function myip() {
  for v in 4 6 ; do
    local curl="curl -s -$v --max-time 3"
    echo IPv$v \
         $($=curl curl 'https://api.ipify.org' || echo "unknown")
  done 2> /dev/null
}

# 显示网卡ip
function ip() {
    # 获取所有网卡信息并过滤出有效的 IPv4 地址
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS 系统使用 networksetup 命令
        networksetup -listallhardwareports | grep -A1 "Hardware Port" | while read -r line; do
            if [[ $line == *"Device:"* ]]; then
                interface=$(echo "$line" | awk '{print $2}')
                ip=$(ipconfig getifaddr "$interface" 2>/dev/null)
                if [ -n "$ip" ] && [ "$ip" != "127.0.0.1" ]; then
                    echo "$interface - $ip"
                fi
            fi
        done
    else
        # Linux 系统使用 ip 命令
        ip -4 addr show | grep -E '^[0-9]+:' | while read -r line; do
            interface=$(echo "$line" | awk -F: '{print $2}' | tr -d ' ')
            ip=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)
            if [ -n "$ip" ]; then
                echo "$interface - $ip"
            fi
        done
    fi
}

# JSON 格式化打印
#
# 许多程序都有一个启用无缓冲输出的标志。例如，
# `curl -N`。大多数程序可以通过
# `stdbuf -o L` 强制使用无缓冲输出。
(( $+commands[python] + $+commands[python3] )) && \
json() {
  PATH=/usr/bin:$PATH ${commands[python3]:-$commands[python]} -u -c '#!/usr/bin/env python3
import sys
import re
import json
import subprocess
import errno
try:
    import pygments
    try:
        from pygments.lexers import JsonLexer
    except ImportError:
        from pygments.lexers import JavascriptLexer as JsonLexer
    from pygments.formatters import TerminalFormatter
except ImportError:
    pygments = None
jsonre = re.compile(r"(?P<prefix>.*?)(?P<json>\{.*\})(?P<suffix>.*)")
def display(f):
    pager = None
    out = sys.stdout
    if out.isatty() and f != sys.stdin:
        pager = subprocess.Popen(["less", "-RFX"],
                                 stdin=subprocess.PIPE,
                                 encoding="utf-8", errors="replace")
        out = pager.stdin
    while True:
        line = f.readline()
        if line == "":
            break
        mo = None
        try:
            mo = jsonre.match(line)
            if not mo:
                raise ValueError("No JSON string found")
            j = json.loads(mo.group("json"))
            pretty = json.dumps(j, indent=2)
            if pygments and sys.stdout.isatty():
                pretty = pygments.highlight(pretty,
                                            JsonLexer(),
                                            TerminalFormatter())
            output = (mo.group("prefix") + pretty.strip() +
                      mo.group("suffix") + "\n")
        except:
            output = line
        try:
            out.write(output)
        except IOError as e:
            if e.errno == errno.EPIPE or e.errno == errno.EINVAL:
                break
            raise
    if pager is not None:
        pager.stdin.close()
        pager.wait()
if len(sys.argv) == 1:
    files = [sys.stdin]
else:
    files = sys.argv[1:]
for f in files:
    try:
        if f != sys.stdin:
            with open(f) as f:
                display(f)
        else:
            display(f)
    except KeyboardInterrupt:
        sys.exit(1)
' "$@"
}

(( $+functions[json] )) && \
jsonf() {
  tail -f "$@" | json
}

# ====================== 开发工具相关别名 ======================
# Git 相关
alias gitinit='git init && git add . && git commit -m "Initial commit"'
alias gs='git status'                    # 查看仓库状态
alias ga='git add'                       # 添加文件到暂存区
alias gc='git commit'                    # 提交更改
alias gp='git push'                      # 推送到远程
alias gl='git pull'                      # 拉取更新
alias gd='git diff'                      # 查看差异
alias gb='git branch'                    # 查看分支
alias gco='git checkout'                 # 切换分支
alias gst='git stash'                    # 暂存更改
alias gsp='git stash pop'                # 恢复暂存的更改
alias glog='git log --oneline --graph'   # 查看提交历史

# Docker 相关
alias d='docker'                         # Docker 命令简写
alias dc='docker-compose'                # Docker Compose 命令简写
alias dps='docker ps'                    # 查看运行中的容器
alias dpsa='docker ps -a'                # 查看所有容器
alias di='docker images'                 # 查看镜像
alias dex='docker exec -it'              # 进入容器
alias dlog='docker logs -f'              # 查看容器日志
alias dstop='docker stop'                # 停止容器
alias drm='docker rm'                    # 删除容器
alias drmi='docker rmi'                  # 删除镜像
alias dprune='docker system prune -f'    # 清理未使用的 Docker 资源

# Node.js 相关
alias n='npm'                            # npm 命令简写
alias ni='npm install'                   # 安装依赖
alias nid='npm install --save-dev'       # 安装开发依赖
alias nr='npm run'                       # 运行 npm 脚本
alias ns='npm start'                     # 启动项目
alias nt='npm test'                      # 运行测试
alias nv='node -v'                       # 查看 Node.js 版本
alias nvmls='nvm ls'                     # 列出已安装的 Node.js 版本

# Python 相关
alias py='python'                        # Python 命令简写
alias py3='python3'                      # Python3 命令简写
alias pip='pip3'                         # pip 命令简写
alias venv='python -m venv'              # 创建虚拟环境
alias act='source venv/bin/activate'     # 激活虚拟环境
alias deact='deactivate'                 # 退出虚拟环境
alias pipf='pip freeze > requirements.txt'  # 导出依赖
alias pyvenv='python -m venv venv && source venv/bin/activate && pip install --upgrade pip'

# ====================== 系统管理相关别名 ======================
# 进程管理
alias psa='ps aux'                       # 查看所有进程
alias psg='ps aux | grep'                # 搜索进程
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS 特定的进程管理命令
    alias psmem='ps -m -o %mem,%cpu,pid,command | head -10'  # 按内存使用排序
    alias pscpu='ps -m -o %cpu,%mem,pid,command | head -10'  # 按 CPU 使用排序
    
    # 优化的内存显示命令
    alias topmem='echo "\n=== 系统内存使用情况 ===" && \
        top -l 1 -stats mem | grep -E "PhysMem|VM:|SharedLibs" && \
        echo "\n=== 进程内存使用 TOP 10 ===" && \
        ps -m -o %mem,%cpu,pid,command | head -10 | \
        awk "NR==1 {printf \"%-6s %-6s %-6s %s\n\", \"内存%\", \"CPU%\", \"PID\", \"命令\"} \
             NR>1 {printf \"%-6.1f %-6.1f %-6d %s\n\", \$1, \$2, \$3, \$4}"'
    
    alias topcpu='echo "\n=== CPU 使用情况 ===" && \
        top -l 1 -stats cpu | grep -E "CPU usage|Load Avg" && \
        echo "\n=== 进程 CPU 使用 TOP 10 ===" && \
        ps -m -o %cpu,%mem,pid,command | head -10 | \
        awk "NR==1 {printf \"%-6s %-6s %-6s %s\n\", \"CPU%\", \"内存%\", \"PID\", \"命令\"} \
             NR>1 {printf \"%-6.1f %-6.1f %-6d %s\n\", \$1, \$2, \$3, \$4}"'
else
    # Linux 特定的进程管理命令
    alias psmem='ps aux | sort -rn -k 4' # 按内存使用排序
    alias pscpu='ps aux | sort -rn -k 3' # 按 CPU 使用排序
    alias topmem='top -o mem'            # 按内存使用排序的 top
    alias topcpu='top -o cpu'            # 按 CPU 使用排序的 top
fi
alias kill9='kill -9'                    # 强制终止进程

# 系统信息
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS 特定的系统信息命令
    alias meminfo='vm_stat && top -l 1 -stats mem | grep "PhysMem"'  # 查看内存使用
    alias cpuinfo='sysctl -n machdep.cpu.brand_string'  # 查看 CPU 信息
    alias diskinfo='df -h'               # 查看磁盘使用
    alias sysinfo='system_profiler SPHardwareDataType'  # 查看系统信息
    alias netinfo='networksetup -listallhardwareports'  # 查看网络接口信息
else
    # Linux 特定的系统信息命令
    alias meminfo='free -h'              # 查看内存使用
    alias cpuinfo='lscpu'                # 查看 CPU 信息
    alias diskinfo='df -h'               # 查看磁盘使用
    alias sysinfo='uname -a'             # 查看系统信息
    alias netinfo='ip addr'              # 查看网络接口信息
fi

# ====================== 文件操作相关别名 ======================
# 文件压缩解压
alias targz='tar -zcvf'                  # 创建 .tar.gz 文件
alias untargz='tar -zxvf'                # 解压 .tar.gz 文件
alias zip='zip -r'                       # 创建 zip 文件
alias unzip='unzip -l'                   # 查看 zip 文件内容

# 文件搜索
alias findn='find . -name'               # 按名称搜索文件
alias findc='find . -type f -exec grep -l'  # 搜索文件内容
alias fsize='find . -type f -size'       # 按大小搜索文件
alias fdate='find . -type f -mtime'      # 按修改时间搜索文件

# ====================== 网络相关别名 ======================
# 网络诊断
alias ports='netstat -anlt | grep LISTEN'            # 查看开放端口
alias myip='myip'           # 查看公网 IP
alias localip='ip'              # 查看本地 IP
alias dns='cat /etc/resolv.conf'         # 查看 DNS 配置
alias flushdns='sudo killall -HUP mDNSResponder'  # 刷新 DNS 缓存

# 下载工具
alias wget='wget -c'                     # 断点续传下载
alias curl='curl -L'                     # 跟随重定向下载
alias aria2c='aria2c -x 16'              # 多线程下载

# ====================== 开发环境相关别名 ======================
# 编辑器
alias v='vim'                            # Vim 编辑器
alias nv='nvim'                          # Neovim 编辑器
alias c='code'                           # VS Code 编辑器
alias s='subl'                           # Sublime Text 编辑器

# 目录导航
alias cdp='cd ~/projects'                # 进入项目目录
alias cdd='cd ~/Downloads'               # 进入下载目录
alias cddoc='cd ~/Documents'             # 进入文档目录
alias cdconf='cd ~/.config'              # 进入配置目录

# ====================== 实用工具别名 ======================
# 时间相关
alias now='date "+%Y-%m-%d %H:%M:%S"'    # 显示当前时间
alias epoch='date +%s'                   # 显示 Unix 时间戳

# 系统维护
# 系统更新和清理命令
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS 系统命令
    alias sysupdate='brew update && brew upgrade'    # 更新系统
    alias sysclean='brew cleanup'                   # 清理系统
else
    # Linux 系统命令
    alias sysupdate='sudo apt update && sudo apt upgrade'  # 更新系统
    alias sysclean='sudo apt autoremove && sudo apt clean' # 清理系统
fi

# 安全相关
alias sshgen='ssh-keygen -t ed25519 -C'  # 生成 SSH 密钥
alias sshadd='ssh-add ~/.ssh/id_ed25519' # 添加 SSH 密钥到代理
alias sshlist='ssh-add -l'               # 列出已加载的 SSH 密钥

# ====================== 自定义函数 ======================
# 创建目录并进入
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 提取各种压缩文件
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' 无法被提取" ;;
        esac
    else
        echo "'$1' 不是有效的文件"
    fi
}

# 创建备份文件
backup() {
    cp "$1" "$1.bak"
}


