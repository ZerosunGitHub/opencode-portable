#!/bin/bash
set -euo pipefail
# 开启严格模式 + 友好的错误输出
trap 'echo "❌ 构建失败：在第 $LINENO 行执行 $BASH_COMMAND 出错"; exit 1' ERR

# ======================
# 基础配置 & 参数校验
# ======================
# 参数说明：版本号 架构 构建类型(normal/musl/modern/legacy)
if [ $# -lt 2 ]; then
  echo "用法: $0 <版本号> <架构> [构建类型(normal/musl/modern/legacy)]"
  echo "示例: $0 v1.0.0 x86_64 normal"
  echo "示例: $0 v1.0.0 x64 modern"
  exit 1
fi

VERSION="$1"
ARCH="$2"
BUILD_TYPE="${3:-normal}"
OUTPUT_DIR="dist"
BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)  # 脚本所在目录（绝对路径）
ROOT_DIR=$(cd "$BASE_DIR/.." && pwd)                   # 项目根目录
OUTPUT_ABS_DIR="$ROOT_DIR/$OUTPUT_DIR"

# 架构统一（x86_64 → x64）
if [ "$ARCH" = "x86_64" ]; then
  ARCH="x64"
elif [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x64" ]; then
  echo "❌ 不支持的架构：$ARCH，仅支持 x86_64/x64、arm64"
  exit 1
fi

# 清理临时文件（保留输出目录）
rm -rf "$ROOT_DIR/tmp" "$ROOT_DIR/extracted" "$ROOT_DIR/opencode"
mkdir -p "$ROOT_DIR/tmp" "$ROOT_DIR/extracted" "$OUTPUT_ABS_DIR" "$ROOT_DIR/opencode/bin"

echo "========================================"
echo "📦 构建 OpenCode $VERSION | 架构:$ARCH | 类型:$BUILD_TYPE"
echo "========================================"

# ======================
# Linux 版本构建（normal/musl）
# ======================
build_linux() {
  local VERSION=$1
  local ARCH=$2
  local BUILD_TYPE=$3
  local FILE_URL=""
  local FILE_SUFFIX=""

  # 下载地址 & 后缀统一
  if [ "$BUILD_TYPE" = "musl" ]; then
    FILE_URL="https://github.com/anomalyco/opencode/releases/download/${VERSION}/opencode-linux-${ARCH}-musl.tar.gz"
    FILE_SUFFIX="-musl"
  else
    FILE_URL="https://github.com/anomalyco/opencode/releases/download/${VERSION}/opencode-linux-${ARCH}.tar.gz"
    FILE_SUFFIX="-glibc"  # 普通版强制添加 -glibc 后缀
  fi

  # 下载二进制包（带进度提示）
  echo "🔻 下载官方包：$FILE_URL"
  wget --progress=bar:force:noscroll "$FILE_URL" -O "$ROOT_DIR/tmp/opencode.tar.gz"

  # 解压
  echo "📂 解压包到临时目录..."
  tar -xzf "$ROOT_DIR/tmp/opencode.tar.gz" -C "$ROOT_DIR/extracted/"

  # 查找并复制二进制文件（健壮性增强）
  OPCODE_PATH=$(find "$ROOT_DIR/extracted" -type f -name "opencode" -print -quit)
  if [ -z "$OPCODE_PATH" ]; then
    echo "❌ 未找到 opencode 二进制文件"
    exit 1
  fi
  cp "$OPCODE_PATH" "$ROOT_DIR/opencode/bin/opencode"
  chmod +x "$ROOT_DIR/opencode/bin/opencode"

  # 打包（命名和Windows统一）
  FINAL_FILENAME="opencode-${VERSION}-portable-linux-${ARCH}${FILE_SUFFIX}.tar.gz"
  echo "📦 打包为：$FINAL_FILENAME"
  tar -czf "${OUTPUT_ABS_DIR}/${FINAL_FILENAME}" -C "$ROOT_DIR" opencode/

  # 清理临时文件
  rm -rf "$ROOT_DIR/tmp" "$ROOT_DIR/extracted" "$ROOT_DIR/opencode"
  echo "✅ Linux 版本构建完成！输出：$OUTPUT_ABS_DIR/$FINAL_FILENAME"
}

# ======================
# Windows 版本构建（modern/legacy）
# ======================
build_windows() {
  local VERSION=$1
  local ARCH=$2  # 固定 x64（Windows 主流）
  local RUNTIME=$3  # modern(bun) / legacy(node)
  local WIN_TMP_DIR="$ROOT_DIR/tmp/windows-$RUNTIME"

  # 强制限定架构为x64
  if [ "$ARCH" != "x64" ]; then
    echo "⚠️ Windows 仅支持 x64 架构，自动切换为 x64"
    ARCH="x64"
  fi

  # 创建临时目录
  rm -rf "$WIN_TMP_DIR"
  mkdir -p "$WIN_TMP_DIR/runtime"

  # 1. 下载官方 OpenCode 源码包
  echo "🔻 下载 OpenCode $VERSION 源码包..."
  wget --progress=bar:force:noscroll "https://github.com/anomalyco/opencode/archive/refs/tags/$VERSION.tar.gz" -O "$WIN_TMP_DIR/$VERSION.tar.gz"
  tar xf "$WIN_TMP_DIR/$VERSION.tar.gz" --strip 1 -C "$WIN_TMP_DIR"
  rm -f "$WIN_TMP_DIR/$VERSION.tar.gz"

  # 2. 下载对应运行时（便携版）
  if [ "$RUNTIME" = "modern" ]; then
    # Win10+ : Bun 便携版
    echo "🔻 下载 Bun 便携版（Win10+）..."
    wget --progress=bar:force:noscroll "https://github.com/oven-sh/bun/releases/latest/download/bun-windows-x64.zip" -O "$WIN_TMP_DIR/bun.zip"
    unzip -q "$WIN_TMP_DIR/bun.zip" -d "$WIN_TMP_DIR/runtime/bun"
    rm -f "$WIN_TMP_DIR/bun.zip"
  else
    # Win7/8/8.1 : Node.js 18 LTS（最后支持旧版Windows）
    echo "🔻 下载 Node.js 18 LTS 便携版（Win7/8）..."
    wget --progress=bar:force:noscroll "https://nodejs.org/dist/v18.20.4/node-v18.20.4-win-x64.zip" -O "$WIN_TMP_DIR/node.zip"
    unzip -q "$WIN_TMP_DIR/node.zip" -d "$WIN_TMP_DIR/runtime/node"
    # 简化Node路径（统一调用方式）
    mv "$WIN_TMP_DIR/runtime/node/node-v18.20.4-win-x64"/* "$WIN_TMP_DIR/runtime/node/"
    rm -rf "$WIN_TMP_DIR/runtime/node/node-v18.20.4-win-x64"
    rm -f "$WIN_TMP_DIR/node.zip"
  fi

  # 3. 生成 Windows 自动启动脚本（增强兼容性）
  echo "📝 生成 Windows 启动脚本..."
  cat > "$WIN_TMP_DIR/opencode.bat" << 'EOF'
@echo off
setlocal enabledelayedexpansion

:: 隐藏命令行窗口（可选，注释掉则显示窗口）
:: if not "%1"=="hide" start mshta vbscript:CreateObject("WScript.Shell").Run("""%~0"" hide %*",0)(window.close)&&exit

:: 自动检测 Windows 版本（更精准）
set "win_version=0"
for /f "tokens=2 delims=[]" %%i in ('ver') do (
  for /f "tokens=2" %%j in ('echo %%i ^| findstr /C:"Version"') do set "win_version=%%j"
)

:: 版本对比：Win10+ 版本号 ≥ 10.0.17763
if "!win_version!" geq "10.0.17763" (
    echo [INFO] Running on Windows 10+/Server 2019+ with Bun runtime...
    if exist "runtime\bun\bun.exe" (
        runtime\bun\bun.exe index.js %*
    ) else (
        echo [ERROR] Bun runtime not found!
        pause
        exit 1
    )
) else (
    echo [INFO] Running on Windows 7/8/8.1 with Node.js runtime...
    if exist "runtime\node\node.exe" (
        runtime\node\node.exe index.js %*
    ) else (
        echo [ERROR] Node.js runtime not found!
        pause
        exit 1
    )
)
EOF

  # 4. 打包压缩（命名和Linux统一）
  FINAL_FILENAME="opencode-${VERSION}-portable-windows-${RUNTIME}-${ARCH}.tar.gz"
  echo "📦 打包为：$FINAL_FILENAME"
  tar -czf "${OUTPUT_ABS_DIR}/${FINAL_FILENAME}" -C "$ROOT_DIR/tmp" "windows-$RUNTIME"

  # 清理Windows临时文件
  rm -rf "$WIN_TMP_DIR"
  echo "✅ Windows 版本构建完成！输出：$OUTPUT_ABS_DIR/$FINAL_FILENAME"
}

# ======================
# 主逻辑：根据构建类型分发任务
# ======================
case "$BUILD_TYPE" in
  normal|musl)
    build_linux "$VERSION" "$ARCH" "$BUILD_TYPE"
    ;;
  modern|legacy)
    build_windows "$VERSION" "$ARCH" "$BUILD_TYPE"
    ;;
  *)
    echo "❌ 不支持的构建类型：$BUILD_TYPE"
    echo "支持的类型：normal(musl)（Linux）、modern/legacy（Windows）"
    exit 1
    ;;
esac

echo "========================================"
echo "🎉 所有构建任务完成！输出目录：$OUTPUT_ABS_DIR"
echo "========================================"
