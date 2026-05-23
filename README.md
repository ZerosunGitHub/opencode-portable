[English](README_EN.md) | 简体中文 | [繁體中文](README_ZH_TW.md) | [한국어](README_KO.md)

# opencode-portable
OpenCode 的第三方便携构建版，自动同步 [anomalyco/opencode](https://github.com/anomalyco/opencode) 上游最新版本，提供 **glibc/musl 双版本 + x86_64/arm64 双架构**，适配所有主流 Linux 发行版，解压即用，无需编译环境。

---

## ✨ Features
- **自动同步上游**：每小时自动检测官方更新，构建并发布最新版本
- **双版本适配**：
  - `glibc` 版：适配 Ubuntu/Debian 等主流系统，开箱即用
  - `musl` 版：静态编译，适配 CentOS 7、NAS 等旧系统
- **双架构支持**：x86_64 + arm64 全平台覆盖
- **零依赖便携封装**：统一目录结构，与官方命令完全兼容
- **支持 mise 版本管理**：一键安装/切换/更新

---

## 📦 安装方式（两种方案任选）

### 方式 1：mise 一键安装（推荐 ✅）

1. 安装 mise 工具

```bash
curl https://mise.run | sh
```

2. 生效 mise 环境
```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
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

### 方式 2：手动解压安装（无依赖环境）

1. 创建目录并解压

```bash
mkdir -p ~/opencode-portable
tar -xzf opencode-*-portable-linux-*.tar.gz -C ~/opencode-portable
```

2. 添加环境变量
```bash
echo 'export PATH="$HOME/opencode-portable/opencode/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

3. 验证安装

```bash
opencode --version
which opencode
```

---

## ✅ 完整验证步骤（所有安装方式通用）
执行以下命令，确认安装成功：

查看版本

```bash
opencode --version
```

查看程序路径
```bash
which opencode
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

## ❓ FAQ
### 1. 版本选择
- 主流 Linux（Ubuntu/Debian）：使用 **glibc 版**
- 旧系统/NAS：使用 **musl 版**

### 2. musl 版在 Ubuntu 报错？
musl 与 Ubuntu 原生库不兼容，普通用户**仅使用 glibc 版**即可。

### 3. 如何更新？
- mise：`mise upgrade opencode-portable`
- 手动：重新下载最新压缩包替换

---

## 📜 License
基于官方 [anomalyco/opencode](https://github.com/anomalyco/opencode) 构建，遵循 MIT 协议

## Star History

<a href="https://www.star-history.com/?repos=zeronesun%2Fopencode-portable&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
 </picture>
</a>
## 📦 下载地址

### Linux 版本
| 架构 | 版本 | 下载链接 |
|------|------|----------|
|  | glibc (主流系统) | [下载](https://github.com/zeronesun/opencode-portable/releases/download/v1.15.10-portable/opencode-v1.15.10-portable-linux--glibc-arm64.tar.gz) |
|  | glibc (主流系统) | [下载](https://github.com/zeronesun/opencode-portable/releases/download/v1.15.10-portable/opencode-v1.15.10-portable-linux--glibc-x64.tar.gz) |
|  | musl (旧系统/NAS) | [下载](https://github.com/zeronesun/opencode-portable/releases/download/v1.15.10-portable/opencode-v1.15.10-portable-linux--musl-arm64.tar.gz) |
|  | musl (旧系统/NAS) | [下载](https://github.com/zeronesun/opencode-portable/releases/download/v1.15.10-portable/opencode-v1.15.10-portable-linux--musl-x64.tar.gz) |

### Windows 版本
| 运行时 | 支持系统 | 下载链接 |
|--------|----------|----------|
| Node.js | Windows 7/8/8.1/10/11 | [下载](https://github.com/zeronesun/opencode-portable/releases/download/v1.15.10-portable/opencode-v1.15.10-portable-windows-legacy-x64.tar.gz) |
| Bun | Windows 10 1809+/11 | [下载](https://github.com/zeronesun/opencode-portable/releases/download/v1.15.10-portable/opencode-v1.15.10-portable-windows-modern-x64.tar.gz) |

📝 使用说明：解压后直接运行对应脚本即可，无需安装任何依赖
