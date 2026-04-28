# Debian QCOW2 自定义镜像构建 (AI Vibecoding 版)

本项目提供一套全自动构建脚本与 GitHub Actions 配置，用于将原生的 [Debian 13 Trixie NoCloud](https://cloud.debian.org/images/cloud/trixie/latest/) QCOW2 镜像进行极致的国内本地化定制，打造开箱即用的 AI 编程 (Vibecoding) 和开发测试环境。

本镜像特别适用于**没有 Cloud-Init 提供者**的虚拟机平台（如各类NAS平台、本地 QEMU/KVM 或家用私有云环境）。

## 核心特性

- **开箱即用**: 默认 root 密码为 `root`，并直接启用 SSH root 登录与密码登录认证。
- **极致的国内加速**: 整个系统全面切换至 [清华大学 Tuna 源](https://mirrors.tuna.tsinghua.edu.cn) 及阿里云 NTP。
  - Debian 基础库与安全库替换为 Tuna 镜像。
  - Docker CE 预配国内下载源并植入国内注册表镜像 (`daemon.json`)。
  - Node.js 及 npm 统一采用镜像源 (`npmmirror.com`, NodeSource from Tuna)。
  <!-- - Rustup/Cargo 全环境换用 Tuna 源。 -->
  - Python UV 包管理器配置 `pypi.tuna.tsinghua.edu.cn/simple` 代理。
- **现代化 Vibecoding 预置栈**:
  - `Docker` + `Docker Compose`: 快速启停 AI 容器或服务。
  - `Python UV`: 极速的多合一 Python 环境管理。
  - `Node.js 20.x`: 提供前端与 JavaScript 环境基础。
  <!-- - `Rust`: 原生编译级基础设施。 -->
  - `OpenCode`: 预装 anomalyco 提供的强大开源 TUI 终端 AI 编程 Agent。
  - `增强型基建`: 将 `tmux`, `git`, `zsh`, `jq`, `vim`, `htop`, `fail2ban`, `qemu-guest-agent` 等纳入基建环境，告别安装依赖烦恼。
- **安全防冲突设计**:
  - 构建后自动清空 `/etc/machine-id`，防止虚拟机克隆导致的网络与日志冲突。
  - 自动屏蔽 `cloud-init` 源生成与 GRUB 的 `OS_PROBER` 回环侦测死锁。
  - 构建结束自动执行缓存垃圾清理。

## 如何构建

### 本地构建部署 (适用含有 libguestfs-tools 的 Linux 系统)

首先，通过该仓库签出所有的构建脚本文件：

```bash
git clone https://github.com/iWangJiaxiang/NoCloud-QCOW2-image
cd NoCloud-QCOW2-image
```

如果你使用的是类似于 Debian/Ubuntu 系统的 Linux 环境，你需要安装依赖工具包：

```bash
sudo apt update
sudo apt install libguestfs-tools qemu-utils wget curl
```

直接触发主构建脚本：

```bash
bash build.sh
```

整个过程会自动下载最新的 Debian QCOW2 镜像文件、应用构建补丁列表并输出至 `release/debian-13-nocloud-amd64.qcow2`。

### GitHub Actions 自动化云端构建
本库中自带了 `.github/workflows/build.yml` 的持续集成文件。
你只需要：
1. Fork 本仓库到你的账号下。
2. 转到 **Actions** 分页内并开启 Workflow 执行权限。
3. 点击 **Build Custom Debian QCOW2** 选择运行！
构建成功后，在代码库的 **Release** 中即可自动获得最终打包好的 `.qcow2` 文件供你无限重用。

## 如何使用

生成的 `debian-13-nocloud-amd64.qcow2` 可直接作为普通系统的引导盘插入你的虚拟机管理器中：

1. 挂载 QCOW2 镜像并启动虚拟机。
2. 用户名填写 `root`。
3. 密码直接输入 `root`。
4. 现在可以开始愉快的玩耍！🥳