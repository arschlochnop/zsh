#!/bin/bash

# 检测操作系统类型
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    PACKAGE_MANAGER="brew"
    INSTALL_CMD="brew install"
    UPDATE_CMD="brew update"
else
    # Linux (Ubuntu/Debian)
    PACKAGE_MANAGER="apt"
    INSTALL_CMD="sudo apt install"
    UPDATE_CMD="sudo apt update"
fi

# 安装基础依赖
$INSTALL_CMD zsh git

# 设置 zsh 为默认 shell
chsh -s /bin/zsh

# 安装 oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# 创建符号链接
path=`pwd`
ln -sf $path/.oh-my-zsh/ ~/.oh-my-zsh
ln -sf $path/.zshrc ~/.oh-my-zsh
ln -sf $path/.zshconfig/.aliases.zsh ~/.aliases.zsh

# 安装 zsh 插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# 安装其他工具
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS 特定安装
    $INSTALL_CMD autojump
    $INSTALL_CMD hstr
else
    # Linux 特定安装
    $INSTALL_CMD autojump
    sudo add-apt-repository ppa:ultradvorka/ppa
    $UPDATE_CMD
    sudo apt-get install hstr
fi

# 初始化补全
autoload -U compinit && compinit
