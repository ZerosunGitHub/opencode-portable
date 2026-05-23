# opencode-portable
[English](README_EN.md) | [简体中文](README.md) | 繁體中文 | [한국어](README_KO.md)

基於官方 [anomalyco/opencode](https://github.com/anomalyco/opencode) 建構的便攜版本，完美支援 **Linux glibc/musl 雙版本 + x86_64/arm64 雙架構 + Windows 雙執行環境**，全平台覆蓋，解壓即可使用，不需要任何編譯環境。

自動同步 [anomalyco/opencode](https://github.com/anomalyco/opencode) 上游最新版本。

---

## ✨ 功能特色
- **自動同步上游**：每天自動偵測官方更新，建構並發布最新版本
- **全平台支援**：
  - **Linux**: x86_64/arm64 雙架構，glibc/musl 雙版本
  - **Windows**: x64 架構，Bun/Node.js 雙執行環境
- **零依賴便攜封裝**：統一目錄結構，與官方指令完全相容
- **支援 mise 版本管理**：一鍵安裝/切換/更新
- **開箱即用**：不需要安裝 Node.js、Bun 或任何其他依賴

---

## 🆚 與官方版本的差異
| 特性 | 官方版本 | 本便攜版 |
|------|----------|----------|
| 依賴要求 | 需要安裝 Node.js 或 Bun | 完全零依賴，內建執行環境 |
| 系統支援 | 僅主流系統 | 支援 CentOS 7、NAS 等舊系統 |
| 架構支援 | 部分架構 | x86_64 + arm64 全架構支援 |
| 安裝方式 | npm/brew 等套件管理器 | 直接解壓即可使用 |
| 更新頻率 | 官方發布週期 | 每天自動同步最新版 |

---

## 📦 安裝方式（三種方案任選）

### 方式 1：mise 一鍵安裝（Linux/macOS 推薦 ✅）

1. 安裝 mise 工具

```bash
curl https://mise.run | sh
```

2. 生效 mise 環境
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

3. 全域安裝最新版 opencode-portable

```bash
mise install github:zeronesun/opencode-portable@latest
mise use -g opencode-portable@latest
```

4. 驗證安裝

```bash
opencode --version
which opencode
```

### 方式 2：手動解壓安裝（全平台通用）

#### Linux
```bash
# 建立目錄
mkdir -p ~/opencode-portable

# 解壓（替換為你下載的檔名）
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz -C ~/opencode-portable

# 加入環境變數
echo 'export PATH="$HOME/opencode-portable/opencode/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Windows
1. 下載對應版本的壓縮檔
2. 解壓到任意目錄（例如 `C:\opencode-portable`）
3. 將 `C:\opencode-portable` 加入到系統環境變數 `PATH` 中
4. 打開新的命令提示字元或 PowerShell 即可使用

### 方式 3：直接執行（不需要安裝）
#### Linux
```bash
# 下載後直接執行
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz
./opencode/bin/opencode
```

#### Windows
雙擊解壓目錄中的 `opencode.bat` 即可直接執行。

---

## ✅ 完整驗證步驟（所有安裝方式通用）
執行以下指令，確認安裝成功：

檢視版本
```bash
opencode --version
```

檢視程式路徑
```bash
which opencode  # Linux/macOS
where opencode  # Windows
```

直接啟動
```bash
opencode
```

---

## ❌ 不建議軟連結到 ~/.local/bin 的原因
`opencode` 是一個指令碼包裝器，依賴同一目錄下的二進制檔案。  
僅軟連結指令碼會導致**找不到依賴檔案**的錯誤，將完整的 bin 目錄加入 PATH 是最穩定的解決方案。

---

## 📦 下載位址
所有版本皆已發布至 [GitHub Releases](https://github.com/zeronesun/opencode-portable/releases)

### Linux 版本
| 架構 | 版本 |
|------|------|
| x64 (Intel/AMD) | glibc (主流系統) |
| x64 (Intel/AMD) | musl (舊系統/NAS) |
| arm64 (樹莓派/ARM 伺服器) | glibc (主流系統) |
| arm64 (樹莓派/ARM 伺服器) | musl (舊系統/NAS) |

### Windows 版本
| 執行環境 | 支援系統 |
|--------|----------|
| Bun | Windows 10 1809+/11 |
| Node.js | Windows 7/8/8.1/10/11 |

📝 **Windows 使用說明**：
- 解壓後直接執行 `opencode.bat` 即可
- 指令碼會自動偵測你的 Windows 版本並選擇合適的執行環境
- 不需要安裝任何額外軟體

---

## ❓ 常見問題
### 1. 版本選擇
- **主流 Linux（Ubuntu/Debian/Fedora）**：使用 **glibc 版**
- **舊系統/NAS（CentOS 7、群暉、威聯通）**：使用 **musl 版**
- **Windows 10 1809+**：推薦使用 **Bun 版**（啟動速度更快）
- **Windows 7/8**：必須使用 **Node.js 版**

### 2. musl 版在 Ubuntu 出現錯誤？
musl 與 Ubuntu 原生函式庫不相容，一般使用者**僅使用 glibc 版**即可。

### 3. 如何更新？
- **mise**: `mise upgrade opencode-portable`
- **手動**: 重新下載最新壓縮檔替換原有目錄

### 4. 為什麼 Windows 版本這麼大？
因為內建了完整的 Node.js 或 Bun 執行環境，這樣才能做到零依賴開箱即用。

---

## 📜 授權條款

遵循 MIT 授權條款。

## Star History

<a href="https://www.star-history.com/?repos=zeronesun%2Fopencode-portable&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
 </picture>
</a>

---

## 🤝 貢獻
歡迎提交 Issue 和 Pull Request！

如果你覺得這個專案對你有幫助，請給個 Star ⭐ 支持一下。
