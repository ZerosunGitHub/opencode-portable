# opencode-portable
[English](README_EN.md) | 简体中文 | [繁體中文](README_ZH_TW.md) | [한국어](README_KO.md)

基于官方 [anomalyco/opencode](https://github.com/anomalyco/opencode) 构建便捷版本，完美适配 **Linux glibc/musl 双版本 + x86_64/arm64 双架构 + Windows 双运行时**，全平台覆盖，解压即用，无需任何编译环境。
同步官方 [anomalyco/opencode](https://github.com/anomalyco/opencode) 上游最新版本，

---

## ✨ Features
- **自动同步上游**：自动检测官方更新，构建并发布最新版本
- **全平台支持**：
  - **Linux**: x86_64/arm64 双架构，glibc/musl 双版本
  - **Windows**: x64 架构，Bun/Node.js 双运行时
- **零依赖便携封装**：统一目录结构，与官方命令完全兼容
- **支持 mise 版本管理**：一键安装/切换/更新
- **开箱即用**：无需安装 Node.js、Bun 或任何其他依赖

---

## 🆚 与官方版本的区别
| 特性 | 官方版本 | 本便携版 |
|------|----------|----------|
| 依赖要求 | 需要安装 Node.js 或 Bun | 完全零依赖，内置运行时 |
| 系统支持 | 仅主流系统 | 支持 CentOS 7、NAS 等旧系统 |
| 架构支持 | 部分架构 | x86_64 + arm64 全架构 |
| 安装方式 | npm/brew 等包管理器 | 直接解压即可使用 |
| 更新频率 | 官方发布周期 | 每天自动同步最新版 |

---

## 📦 安装方式（三种方案任选）

### 方式 1：mise 一键安装（Linux/macOS 推荐 ✅）

1. 安装 mise 工具

```bash
curl https://mise.run | sh
```

2. 生效 mise 环境
```bash
# Bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc

# Zsh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc

# Fish
echo '~/.local/bin/mise activate fish | source' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

3. 全局安装最新版 opencode-portable

```bash
mise install github:zeronesun/opencode-portable@latest
mise use -g opencode-portable@latest
```

4. 验证安装

```bash
opencode --version
which opencode
```

### 方式 2：手动解压安装（全平台通用）

#### Linux
```bash
# 创建目录
mkdir -p ~/opencode-portable

# 解压（替换为你下载的文件名）
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz -C ~/opencode-portable

# 添加环境变量
echo 'export PATH="$HOME/opencode-portable/opencode/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Windows
1. 下载对应版本的压缩包
2. 解压到任意目录（如 `C:\opencode-portable`）
3. 将 `C:\opencode-portable` 添加到系统环境变量 `PATH` 中
4. 打开新的命令提示符或 PowerShell 即可使用

### 方式 3：直接运行（无需安装）
#### Linux
```bash
# 下载后直接运行
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz
./opencode/bin/opencode
```

#### Windows
双击解压目录中的 `opencode.bat` 即可直接运行。

---

## ✅ 完整验证步骤（所有安装方式通用）
执行以下命令，确认安装成功：

查看版本
```bash
opencode --version
```

查看程序路径
```bash
which opencode  # Linux/macOS
where opencode  # Windows
```

直接启动
```bash
opencode
```

---

## ❌ 不推荐软链接到 ~/.local/bin 的原因
`opencode` 为脚本包装器，依赖同目录下的二进制文件。  
仅软链接脚本会导致**找不到依赖文件**报错，将完整 bin 目录加入 PATH 是最稳定方案。

---

## 📦 下载地址
所有版本均已发布到 [GitHub Releases](https://github.com/zeronesun/opencode-portable/releases)

### Linux 版本
| 架构 | 版本 |
|------|------|
| x64 (Intel/AMD) | glibc (主流系统) |
| x64 (Intel/AMD) | musl (旧系统/NAS) |
| arm64 (树莓派/ARM服务器) | glibc (主流系统) |
| arm64 (树莓派/ARM服务器) | musl (旧系统/NAS) |

### Windows 版本
| 运行时 | 支持系统 |
|--------|----------|
| Bun | Windows 10 1809+/11 |
| Node.js | Windows 7/8/8.1/10/11 |

📝 **Windows 使用说明**：
- 解压后直接运行 `opencode.bat` 即可
- 脚本会自动检测你的 Windows 版本并选择合适的运行时
- 无需安装任何额外软件

---

## ❓ FAQ
### 1. 版本选择
- **主流 Linux（Ubuntu/Debian/Fedora）**：使用 **glibc 版**
- **旧系统/NAS（CentOS 7、群晖、威联通）**：使用 **musl 版**
- **Windows 10 1809+**：推荐使用 **Bun 版**（启动速度更快）
- **Windows 7/8**：必须使用 **Node.js 版**

### 2. musl 版在 Ubuntu 报错？
musl 与 Ubuntu 原生库不兼容，普通用户**仅使用 glibc 版**即可。

### 3. 如何更新？
- **mise**: `mise upgrade opencode-portable`
- **手动**: 重新下载最新压缩包替换原有目录

### 4. 为什么 Windows 版本这么大？
因为内置了完整的 Node.js 或 Bun 运行时，这样才能做到零依赖开箱即用。

---

## 📜 License

遵循 MIT 协议。

## Star History

<a href="https://www.star-history.com/?repos=zeronesun%2Fopencode-portable&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
 </picture>
</a>

---

## 🤝 贡献
欢迎提交 Issue 和 Pull Request！

如果你觉得这个项目对你有帮助，请给个 Star ⭐ 支持一下。
