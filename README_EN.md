# opencode-portable
English | [简体中文](README.md) | [繁體中文](README_ZH_TW.md) | [한국어](README_KO.md)

A third-party portable build of OpenCode, based on the official [anomalyco/opencode](https://github.com/anomalyco/opencode) repository. Provides **Linux glibc/musl dual versions + x86_64/arm64 dual architectures + Windows dual runtimes**, covering all major platforms. Extract and use immediately, no compilation environment required.

Automatically syncs with the latest upstream version from [anomalyco/opencode](https://github.com/anomalyco/opencode).

---

## ✨ Features
- **Automatic upstream sync**: Checks for official updates daily and builds/releases the latest version
- **Full platform support**:
  - **Linux**: x86_64/arm64 dual architectures, glibc/musl dual versions
  - **Windows**: x64 architecture, Bun/Node.js dual runtimes
- **Zero-dependency portable packaging**: Unified directory structure, fully compatible with official commands
- **mise version management support**: One-click install/switch/update
- **Out-of-the-box**: No need to install Node.js, Bun, or any other dependencies

---

## 🆚 Comparison with the official version
| Feature | Official Version | This Portable Version |
|---------|------------------|------------------------|
| Dependencies | Requires Node.js or Bun | Zero dependencies, runtime included |
| System Support | Only mainstream systems | Supports older systems like CentOS 7, NAS devices |
| Architecture Support | Partial architectures | Full x86_64 + arm64 architecture support |
| Installation Methods | npm/brew package managers | Direct extraction and use |
| Update Frequency | Official release cycle | Daily automatic sync with latest version |

---

## 📦 Installation Methods (Choose one of three options)

### Method 1: One-click installation with mise (Recommended for Linux/macOS ✅)

1. Install the mise tool

```bash
curl https://mise.run | sh
```

2. Activate the mise environment
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

3. Install the latest version of opencode-portable globally

```bash
mise install github:zeronesun/opencode-portable@latest
mise use -g opencode-portable@latest
```

4. Verify the installation

```bash
opencode --version
which opencode
```

### Method 2: Manual extraction installation (Universal for all platforms)

#### Linux
```bash
# Create directory
mkdir -p ~/opencode-portable

# Extract (replace with your downloaded filename)
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz -C ~/opencode-portable

# Add to environment variables
echo 'export PATH="$HOME/opencode-portable/opencode/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Windows
1. Download the corresponding version archive
2. Extract to any directory (e.g., `C:\opencode-portable`)
3. Add `C:\opencode-portable` to your system `PATH` environment variable
4. Open a new Command Prompt or PowerShell to use

### Method 3: Run directly (No installation required)
#### Linux
```bash
# Run directly after downloading
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz
./opencode/bin/opencode
```

#### Windows
Double-click `opencode.bat` in the extracted directory to run directly.

---

## ✅ Complete verification steps (Universal for all installation methods)
Run the following commands to confirm successful installation:

Check version
```bash
opencode --version
```

Check program path
```bash
which opencode  # Linux/macOS
where opencode  # Windows
```

Start directly
```bash
opencode
```

---

## ❌ Why soft linking to ~/.local/bin is not recommended
`opencode` is a script wrapper that depends on binary files in the same directory.  
Soft linking only the script will result in a **"dependency file not found"** error. Adding the complete bin directory to PATH is the most stable solution.

---

## 📦 Download Links
All versions are published to [GitHub Releases](https://github.com/zeronesun/opencode-portable/releases)

### Linux Versions
| Architecture | Version |
|--------------|---------|
| x64 (Intel/AMD) | glibc (Mainstream systems) |
| x64 (Intel/AMD) | musl (Older systems/NAS) |
| arm64 (Raspberry Pi/ARM servers) | glibc (Mainstream systems) |
| arm64 (Raspberry Pi/ARM servers) | musl (Older systems/NAS) |

### Windows Versions
| Runtime | Supported Systems | 
|---------|-------------------|
| Bun | Windows 10 1809+/11 |
| Node.js | Windows 7/8/8.1/10/11 |

📝 **Windows Usage Notes**:
- Just run `opencode.bat` after extraction
- The script will automatically detect your Windows version and select the appropriate runtime
- No additional software installation required

---

## ❓ FAQ
### 1. Version selection
- **Mainstream Linux (Ubuntu/Debian/Fedora)**: Use the **glibc version**
- **Older systems/NAS (CentOS 7, Synology, QNAP)**: Use the **musl version**
- **Windows 10 1809+**: Recommended to use the **Bun version** (faster startup)
- **Windows 7/8**: Must use the **Node.js version**

### 2. Why does the musl version throw errors on Ubuntu?
musl is incompatible with Ubuntu's native libraries. Regular users should **only use the glibc version**.

### 3. How to update?
- **mise**: `mise upgrade opencode-portable`
- **Manual**: Re-download the latest archive and replace the original directory

### 4. Why is the Windows version so large?
Because it includes the complete Node.js or Bun runtime, which allows for zero-dependency out-of-the-box usage.

---

## 📜 License

Licensed under the MIT License.

## Star History

<a href="https://www.star-history.com/?repos=zeronesun%2Fopencode-portable&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
 </picture>
</a>

---

## 🤝 Contributing
Issues and Pull Requests are welcome!

If you find this project helpful, please give it a Star ⭐ to show your support.
