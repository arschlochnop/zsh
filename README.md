# ZSH 配置项目

这是一个现代化的 ZSH 配置项目，提供了丰富的终端体验和开发工具支持。项目基于 Oh My Zsh，并添加了多个实用的自定义配置和别名。

## ✨ 功能特性

### 1. 终端界面
- 美观的命令提示符，支持多行显示
- 智能的目录路径显示（自动缩短长路径）
- Git 状态实时显示（分支名、更改状态、远程同步状态）
- 支持 Python 虚拟环境显示
- 适配 macOS 和 Debian 系统

### 2. Git 集成
- 实时显示 Git 仓库状态
- 显示分支名、未提交更改、未跟踪文件
- 显示与远程分支的同步状态（领先/落后）
- 丰富的 Git 命令别名

### 3. 开发工具支持
- Python 虚拟环境管理
- Docker 命令支持
- Node.js 开发支持
- 系统监控工具

### 4. 系统管理
- 内存使用监控（`topmem`）
- CPU 使用监控（`topcpu`）
- 进程管理工具
- 系统更新和清理命令

## 🚀 安装步骤

### 一键安装
```bash
git clone https://github.com/arschlochnop/zsh.git
cd zsh
bash install.sh
```

### 手工安装

1. 克隆仓库：
```bash
git clone https://github.com/arschlochnop/zsh.git
```

2. 创建符号链接：
```bash
ln -s .zshrc ~/.zshrc
ln -s .zshconfig ~/.zshconfig
```

3. 安装依赖：
   - 安装 [Oh My Zsh](https://ohmyz.sh/)
   - 安装 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
   - 安装 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
   - 安装 hstr
   - 安装 autojump


4. 应用配置：
```bash
source ~/.zshrc
```

## 🛠️ 配置说明

### 提示符配置
提示符格式：`┌──(venv)─(user@host)-[path]-[git_status]`
- 显示 Python 虚拟环境（如果激活）
- 显示用户名和主机名
- 智能路径显示
- Git 状态显示

### Git 状态显示
Git 状态格式：`[⎇ branch (●2 ●1 ●3 ↑2)]`
- 绿色圆点(●)：已暂存的更改数量
- 黄色圆点(●)：未暂存的更改数量
- 红色圆点(●)：未跟踪的文件数量
- 蓝色上箭头(↑)：领先远程分支的提交数
- 蓝色下箭头(↓)：落后远程分支的提交数

### 常用命令
- `topmem`：显示系统内存使用情况
- `topcpu`：显示 CPU 使用情况
- `gs`：Git 状态
- `ga`：Git 添加
- `gc`：Git 提交
- `gp`：Git 推送
- `gl`：Git 拉取

## 🔧 自定义配置

### 修改主题
编辑 `~/.zshrc` 文件：
```bash
# 设置主题
ZSH_THEME="agnoster"
```

### 添加插件
编辑 `~/.zshrc` 文件：
```bash
# 添加插件
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    # 添加其他插件...
)
```

### 自定义别名
编辑 `~/.zshconfig/.user_aliases.zsh` 文件添加自定义别名。

### 自定义profile
编辑 `~/.zshconfig/.user_profile.zsh` 文件添加自定义变量

## 📝 注意事项

1. 首次使用 Git 时，需要配置用户信息：
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

2. 如果遇到权限问题，确保配置文件有正确的权限：
```bash
chmod 644 ~/.zshrc
chmod 644 ~/.zshconfig/.aliases.zsh
```

3. 在 macOS 上，某些命令可能需要安装额外的工具：
```bash
brew install coreutils
```

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目。在提交 PR 之前，请确保：

1. 代码符合现有的风格
2. 添加了必要的注释
3. 更新了相关文档
4. 测试了所有更改

## 📄 许可证

[Apache License 2.0](LICENSE)

## 🙏 致谢

- [Oh My Zsh](https://ohmyz.sh/)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) 