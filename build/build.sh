#!/bin/bash
set -euo pipefail

# ======================================
# 🔧 配置区（所有可修改的参数都在这里）
# ======================================
# 项目基础配置
PROJECT_NAME="opencode"
OUTPUT_DIR="dist"
TEMP_DIR="tmp"

# 官方仓库配置
UPSTREAM_REPO="anomalyco/opencode"
UPSTREAM_BASE_URL="https://github.com/${UPSTREAM_REPO}/releases/download"
UPSTREAM_ARCHIVE_URL="https://github.com/${UPSTREAM_REPO}/archive/refs/tags"

# 运行时版本配置（集中管理，更新时只需改这里）
BUN_VERSION="latest"
NODE_VERSION="v18.20.4"  # 最后支持Win7的LTS版本

# 运行时下载地址模板
BUN_DOWNLOAD_URL="https://github.com/oven-sh/bun/releases/${BUN_VERSION}/download/bun-windows-x64.zip"
NODE_DOWNLOAD_URL="https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-win-x64.zip"

# 文件名模板（统一管理所有命名规则）
FILENAME_TEMPLATE="${PROJECT_NAME}-{{VERSION}}-portable-{{OS}}-{{TYPE}}-{{ARCH}}.tar.gz"

# ======================================
# 🛠️ 工具函数层（通用功能）
# ======================================
# 错误处理函数
trap 'echo -e "\n❌ 构建失败：在第 $LINENO 行执行命令 \"$BASH_COMMAND\" 出错"; cleanup; exit 1' ERR

# 清理函数（无论成功失败都会执行）
cleanup() {
  echo "🧹 清理临时文件..."
  rm -rf "$TEMP_DIR" "extracted" "opencode"
  echo "✅ 清理完成"
}

# 带进度和重试的下载函数
download_file() {
  local url="$1"
  local output="$2"
  local retries=3
  local retry_delay=5

  echo "🔻 下载: $url"
  for i in $(seq 1 $retries); do
    if wget --progress=bar:force:noscroll --tries=1 "$url" -O "$output"; then
      echo "✅ 下载成功"
      return 0
    fi
    echo "⚠️ 第 $i 次下载失败，${retry_delay}秒后重试..."
    sleep $retry_delay
  done

  echo "❌ 下载失败，已重试 $retries 次"
  exit 1
}

# 替换模板变量
render_filename() {
  local template="$1"
  local version="$2"
  local os="$3"
  local type="$4"
  local arch="$5"

  echo "$template" | \
    sed "s/{{VERSION}}/$version/g" | \
    sed "s/{{OS}}/$os/g" | \
    sed "s/{{TYPE}}/$type/g" | \
    sed "s/{{ARCH}}/$arch/g"
}

# ======================================
# 📦 构建函数层（按平台分组）
# ======================================
# Linux 版本构建
build_linux() {
  local version="$1"
  local arch="$2"
  local build_type="$3"

  # 确定下载地址和后缀
  if [ "$build_type" = "musl" ]; then
    local file_url="${UPSTREAM_BASE_URL}/${version}/opencode-linux-${arch}-musl.tar.gz"
    local file_suffix="-musl"
  else
    local file_url="${UPSTREAM_BASE_URL}/${version}/opencode-linux-${arch}.tar.gz"
    local file_suffix="-glibc"
  fi

  # 生成最终文件名
  local final_filename=$(render_filename "$FILENAME_TEMPLATE" "$version" "linux" "$file_suffix" "$arch")

  echo "========================================"
  echo "🐧 构建 Linux 版本 | $version | $arch | $build_type"
  echo "========================================"

  # 修复：添加 extracted 目录创建
  mkdir -p "$TEMP_DIR/linux" "$TEMP_DIR/linux/extracted" "opencode/bin"

  # 下载和解压
  download_file "$file_url" "$TEMP_DIR/linux/opencode.tar.gz"
  tar -xzf "$TEMP_DIR/linux/opencode.tar.gz" -C "$TEMP_DIR/linux/extracted"

  # 复制二进制文件
  local opcode_path=$(find "$TEMP_DIR/linux/extracted" -type f -name "opencode" -print -quit)
  if [ -z "$opcode_path" ]; then
    echo "❌ 未找到 opencode 二进制文件"
    exit 1
  fi
  cp "$opcode_path" "opencode/bin/opencode"
  chmod +x "opencode/bin/opencode"

  # 打包
  echo "📦 打包为: $final_filename"
  tar -czf "${OUTPUT_DIR}/${final_filename}" opencode/

  echo "✅ Linux 版本构建完成"
}

# Windows 版本构建
build_windows() {
  local version="$1"
  local arch="$2"
  local runtime="$3"

  # Windows 仅支持x64
  if [ "$arch" != "x64" ]; then
    echo "⚠️ Windows 仅支持 x64 架构，自动切换为 x64"
    arch="x64"
  fi

  # 生成最终文件名
  local final_filename=$(render_filename "$FILENAME_TEMPLATE" "$version" "windows" "$runtime" "$arch")

  echo "========================================"
  echo "🪟 构建 Windows 版本 | $version | $arch | $runtime"
  echo "========================================"

  # 准备目录
  local win_temp_dir="$TEMP_DIR/windows-$runtime"
  mkdir -p "$win_temp_dir/runtime"

  # 1. 下载 OpenCode 源码
  download_file "${UPSTREAM_ARCHIVE_URL}/${version}.tar.gz" "$win_temp_dir/source.tar.gz"
  tar xf "$win_temp_dir/source.tar.gz" --strip 1 -C "$win_temp_dir"
  rm -f "$win_temp_dir/source.tar.gz"

  # 2. 下载对应运行时
  if [ "$runtime" = "modern" ]; then
    echo "🔻 下载 Bun 运行时"
    download_file "$BUN_DOWNLOAD_URL" "$win_temp_dir/bun.zip"
    unzip -q "$win_temp_dir/bun.zip" -d "$win_temp_dir/runtime/bun"
    rm -f "$win_temp_dir/bun.zip"
  else
    echo "🔻 下载 Node.js 运行时"
    download_file "$NODE_DOWNLOAD_URL" "$win_temp_dir/node.zip"
    unzip -q "$win_temp_dir/node.zip" -d "$win_temp_dir/runtime/node"
    # 简化Node路径
    mv "$win_temp_dir/runtime/node/node-${NODE_VERSION}-win-x64"/* "$win_temp_dir/runtime/node/"
    rm -rf "$win_temp_dir/runtime/node/node-${NODE_VERSION}-win-x64"
    rm -f "$win_temp_dir/node.zip"
  fi

  # 3. 生成启动脚本
  echo "📝 生成 Windows 启动脚本"
  cat > "$win_temp_dir/opencode.bat" << 'EOF'
@echo off
setlocal enabledelayedexpansion

:: 自动检测 Windows 版本
set "win_version=0"
for /f "tokens=2 delims=[]" %%i in ('ver') do (
  for /f "tokens=2" %%j in ('echo %%i ^| findstr /C:"Version"') do set "win_version=%%j"
)

:: 选择运行时
if "!win_version!" geq "10.0.17763" (
    echo [INFO] Windows 10+/Server 2019+ detected, using Bun runtime
    if exist "runtime\bun\bun.exe" (
        runtime\bun\bun.exe index.js %*
    ) else (
        echo [ERROR] Bun runtime not found!
        pause
        exit 1
    )
) else (
    echo [INFO] Windows 7/8/8.1 detected, using Node.js runtime
    if exist "runtime\node\node.exe" (
        runtime\node\node.exe index.js %*
    ) else (
        echo [ERROR] Node.js runtime not found!
        pause
        exit 1
    )
)
EOF

  # 4. 打包
  echo "📦 打包为: $final_filename"
  tar -czf "${OUTPUT_DIR}/${final_filename}" -C "$TEMP_DIR" "windows-$runtime"

  echo "✅ Windows 版本构建完成"
}

# ======================================
# 🚀 主逻辑层
# ======================================
# 参数校验
if [ $# -lt 2 ]; then
  echo "用法: $0 <版本号> <架构> [构建类型]"
  echo "构建类型:"
  echo "  normal  - Linux glibc 版本（默认）"
  echo "  musl    - Linux musl 版本"
  echo "  modern  - Windows Bun 版本（Win10+）"
  echo "  legacy  - Windows Node.js 版本（Win7+）"
  echo ""
  echo "示例:"
  echo "  $0 v1.15.5 x86_64 normal"
  echo "  $0 v1.15.5 x64 modern"
  exit 1
fi

# 解析参数
VERSION="$1"
ARCH="$2"
BUILD_TYPE="${3:-normal}"

# 架构统一
if [ "$ARCH" = "x86_64" ]; then
  ARCH="x64"
elif [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x64" ]; then
  echo "❌ 不支持的架构: $ARCH"
  echo "支持的架构: x86_64/x64, arm64"
  exit 1
fi

# 准备目录
mkdir -p "$OUTPUT_DIR"

# 注册清理函数（脚本退出时自动执行）
trap cleanup EXIT

# 根据构建类型分发任务
case "$BUILD_TYPE" in
  normal|musl)
    build_linux "$VERSION" "$ARCH" "$BUILD_TYPE"
    ;;
  modern|legacy)
    build_windows "$VERSION" "$ARCH" "$BUILD_TYPE"
    ;;
  *)
    echo "❌ 不支持的构建类型: $BUILD_TYPE"
    echo "支持的类型: normal, musl, modern, legacy"
    exit 1
    ;;
esac

# 构建完成
echo "========================================"
echo "🎉 所有构建任务完成！"
echo "📁 输出目录: $OUTPUT_DIR"
echo "📋 构建产物:"
ls -lh "$OUTPUT_DIR"
echo "========================================"
