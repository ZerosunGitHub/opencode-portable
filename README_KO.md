# opencode-portable
[English](README_EN.md) | [简体中文](README.md) | [繁體中文](README_ZH_TW.md) | 한국어

공식 [anomalyco/opencode](https://github.com/anomalyco/opencode)를 기반으로 제작된 휴대용 버전입니다. **Linux glibc/musl 듀얼 버전 + x86_64/arm64 듀얼 아키텍처 + Windows 듀얼 런타임**을 완벽하게 지원하며 모든 플랫폼을 커버합니다. 압축만 해제하면 바로 사용할 수 있으며 별도의 컴파일 환경이 필요하지 않습니다.

공식 [anomalyco/opencode](https://github.com/anomalyco/opencode) 상위 저장소의 최신 버전을 자동으로 동기화합니다.

---

## ✨ 주요 기능
- **자동 상위 저장소 동기화**: 매일 공식 업데이트를 자동으로 감지하여 최신 버전을 빌드하고 릴리즈합니다
- **전 플랫폼 지원**:
  - **Linux**: x86_64/arm64 듀얼 아키텍처, glibc/musl 듀얼 버전
  - **Windows**: x64 아키텍처, Bun/Node.js 듀얼 런타임
- **제로 의존성 휴대용 패키징**: 통일된 디렉토리 구조로 공식 명령어와 완벽하게 호환됩니다
- **mise 버전 관리 지원**: 한 번의 클릭으로 설치/전환/업데이트가 가능합니다
- **즉시 사용 가능**: Node.js, Bun 또는 기타 어떤 의존성도 설치할 필요가 없습니다

---

## 🆚 공식 버전과의 차이점
| 기능 | 공식 버전 | 이 휴대용 버전 |
|------|----------|----------------|
| 의존성 요구사항 | Node.js 또는 Bun 설치 필요 | 완전 제로 의존성, 런타임 내장 |
| 시스템 지원 | 주류 시스템만 지원 | CentOS 7, NAS 등 구식 시스템 지원 |
| 아키텍처 지원 | 일부 아키텍처만 지원 | x86_64 + arm64 전 아키텍처 지원 |
| 설치 방식 | npm/brew 등 패키지 매니저 | 직접 압축 해제하여 사용 |
| 업데이트 주기 | 공식 릴리즈 주기 | 매일 자동으로 최신 버전 동기화 |

---

## 📦 설치 방법 (세 가지 방법 중 선택)

### 방법 1: mise로 한 번에 설치 (Linux/macOS 권장 ✅)

1. mise 도구 설치

```bash
curl https://mise.run | sh
```

2. mise 환경 적용
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

3. 최신 버전 opencode-portable 전역 설치

```bash
mise install github:zeronesun/opencode-portable@latest
mise use -g opencode-portable@latest
```

4. 설치 확인

```bash
opencode --version
which opencode
```

### 방법 2: 수동 압축 해제 설치 (모든 플랫폼 공통)

#### Linux
```bash
# 디렉토리 생성
mkdir -p ~/opencode-portable

# 압축 해제 (다운로드한 파일명으로 교체하세요)
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz -C ~/opencode-portable

# 환경 변수에 추가
echo 'export PATH="$HOME/opencode-portable/opencode/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Windows
1. 해당 버전의 압축 파일 다운로드
2. 임의의 디렉토리에 압축 해제 (예: `C:\opencode-portable`)
3. `C:\opencode-portable`를 시스템 환경 변수 `PATH`에 추가
4. 새로운 명령 프롬프트 또는 PowerShell을 열어 사용하세요

### 방법 3: 설치 없이 직접 실행

#### Linux
```bash
# 다운로드 후 직접 실행
tar -xzf opencode-v1.15.10-portable-linux-glibc-x64.tar.gz
./opencode/bin/opencode
```

#### Windows
압축 해제한 디렉토리에서 `opencode.bat`을 더블 클릭하면 바로 실행됩니다.

---

## ✅ 완전한 확인 단계 (모든 설치 방법 공통)
다음 명령어를 실행하여 설치가 성공적으로 완료되었는지 확인하세요:

버전 확인
```bash
opencode --version
```

프로그램 경로 확인
```bash
which opencode  # Linux/macOS
where opencode  # Windows
```

직접 실행
```bash
opencode
```

---

## ❌ ~/.local/bin에 소프트 링크를 권장하지 않는 이유
`opencode`는 동일 디렉토리에 있는 바이너리 파일에 의존하는 스크립트 래퍼입니다.  
스크립트만 소프트 링크하면 **의존성 파일을 찾을 수 없음** 오류가 발생합니다. 완전한 bin 디렉토리를 PATH에 추가하는 것이 가장 안정적인 솔루션입니다.

---

## 📦 다운로드 링크
모든 버전은 [GitHub Releases](https://github.com/zeronesun/opencode-portable/releases)에 게시되어 있습니다

### Linux 버전
| 아키텍처 | 버전 |
|---------|------|
| x64 (Intel/AMD) | glibc (주류 시스템) |
| x64 (Intel/AMD) | musl (구식 시스템/NAS) |
| arm64 (라즈베리파이/ARM 서버) | glibc (주류 시스템) |
| arm64 (라즈베리파이/ARM 서버) | musl (구식 시스템/NAS) |

### Windows 버전
| 런타임 | 지원 시스템 |
|--------|------------|
| Bun | Windows 10 1809+/11 |
| Node.js | Windows 7/8/8.1/10/11 |

📝 **Windows 사용 안내**:
- 압축 해제 후 `opencode.bat`을 실행하기만 하면 됩니다
- 스크립트가 자동으로 Windows 버전을 감지하여 적절한 런타임을 선택합니다
- 별도의 소프트웨어 설치가 필요하지 않습니다

---

## ❓ 자주 묻는 질문
### 1. 버전 선택
- **주류 Linux (Ubuntu/Debian/Fedora)**: **glibc 버전**을 사용하세요
- **구식 시스템/NAS (CentOS 7, 시놀로지, QNAP)**: **musl 버전**을 사용하세요
- **Windows 10 1809+**: **Bun 버전**을 권장합니다 (시작 속도가 더 빠릅니다)
- **Windows 7/8**: **Node.js 버전**을 사용해야 합니다

### 2. musl 버전이 Ubuntu에서 오류가 발생하나요?
musl은 Ubuntu의 기본 라이브러리와 호환되지 않습니다. 일반 사용자는 **glibc 버전만 사용하시면 됩니다**.

### 3. 업데이트 방법은?
- **mise**: `mise upgrade opencode-portable`
- **수동**: 최신 압축 파일을 다시 다운로드하여 기존 디렉토리를 교체하세요

### 4. Windows 버전이 왜 이렇게 큰가요?
제로 의존성으로 즉시 사용할 수 있도록 완전한 Node.js 또는 Bun 런타임이 내장되어 있기 때문입니다.

---

## 📜 라이선스

MIT 라이선스를 따릅니다.

## Star History

<a href="https://www.star-history.com/?repos=zeronesun%2Fopencode-portable&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zeronesun/opencode-portable&type=date&legend=top-left" />
 </picture>
</a>

---

## 🤝 기여
Issue와 Pull Request를 환영합니다!

이 프로젝트가 도움이 되었다면 Star ⭐를 눌러주세요.
