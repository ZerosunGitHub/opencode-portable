#!/bin/bash
set -euo pipefail

# 参数：版本号 架构 版本类型(normal/musl，可选，默认normal)
VERSION="$1"
ARCH="$2"
BUILD_TYPE="${3:-normal}"
OUTPUT_DIR="dist"

# 架构适配
if [ "$ARCH" = "x86_64" ]; then
  ARCH="x64"
fi

# 仅清理临时文件，不删除输出目录
rm -rf tmp extracted opencode
mkdir -p tmp extracted "$OUTPUT_DIR" opencode/bin

echo "========================================"
echo "构建 OpenCode $VERSION | 架构:$ARCH | 类型:$BUILD_TYPE"
echo "========================================"

# 关键修正：强制确保普通版带 -glibc 后缀
if [ "$BUILD_TYPE" = "musl" ]; then
  FILE_URL="https://github.com/anomalyco/opencode/releases/download/${VERSION}/opencode-linux-${ARCH}-musl.tar.gz"
  FILE_SUFFIX="-musl"
else
  FILE_URL="https://github.com/anomalyco/opencode/releases/download/${VERSION}/opencode-linux-${ARCH}.tar.gz"
  FILE_SUFFIX="-glibc"  # 普通版强制添加 -glibc 后缀
fi

# 下载 + 解压
wget -q "$FILE_URL" -O tmp/opencode.tar.gz
tar -xzf tmp/opencode.tar.gz -C extracted/

# 自动查找二进制文件
OPCODE_PATH=$(find extracted -type f -name "opencode" -print -quit)
cp "$OPCODE_PATH" opencode/bin/opencode
chmod +x opencode/bin/opencode

# 打包（强制拼接后缀）
FINAL_FILENAME="opencode-${VERSION}-portable-linux-${ARCH}${FILE_SUFFIX}.tar.gz"
tar -czf "${OUTPUT_DIR}/${FINAL_FILENAME}" opencode/

# 清理临时文件
rm -rf tmp extracted opencode

echo "✅ 构建完成！"
echo "📦 输出文件：${FINAL_FILENAME}"
echo "========================================"

# ======================
# 新增：Windows 便携版构建（Bun + Node.js 双运行时）
# ======================
build_windows() {
  local TAG=$1
  local ARCH=$2  # 固定 x64（Windows 主流）
  local RUNTIME=$3  # modern(bun) / legacy(node)

  mkdir -p dist/opencode-windows-$RUNTIME-x64/runtime
  cd dist/opencode-windows-$RUNTIME-x64

  # 1. 下载官方 OpenCode CLI
  wget -q https://github.com/anomalyco/opencode/archive/refs/tags/$TAG.tar.gz
  tar xf $TAG.tar.gz --strip 1
  rm -f $TAG.tar.gz

  # 2. 下载对应运行时（便携版，免安装）
  if [ "$RUNTIME" = "modern" ]; then
    # Win10+ : Bun 便携版
    wget -q https://github.com/oven-sh/bun/releases/latest/download/bun-windows-x64.zip
    unzip -q bun-windows-x64.zip -d runtime/bun
    rm -f bun-windows-x64.zip
  else
    # Win7/8/8.1 : Node.js 18 LTS (最后支持旧版Windows)
    wget -q https://nodejs.org/dist/v18.20.4/node-v18.20.4-win-x64.zip
    unzip -q node-v18.20.4-win-x64.zip -d runtime/node
    rm -f node-v18.20.4-win-x64.zip
  fi

  # 3. 生成 Windows 自动启动脚本（核心：自动识别系统版本）
  cat > opencode.bat << 'EOF'
@echo off
setlocal enabledelayedexpansion

:: 自动检测 Windows 版本
for /f "tokens=2 delims=[]" %%i in ('ver') do set version=%%i
if "!version!" geq "10.0.17763" (
    :: Win10+ 使用 Bun
    echo Running on Windows 10+ with Bun runtime...
    runtime\bun\bun.exe index.js %*
) else (
    :: Win7/8/8.1 使用 Node.js
    echo Running on Windows 7/8 with Node.js runtime...
    runtime\node\node.exe index.js %*
)
EOF

  # 4. 打包压缩
  cd ..
  # 修复后：带版本号，和Linux命名统一
  tar -zcf "${TAG}-windows-${RUNTIME}-x64.tar.gz" opencode-windows-$RUNTIME-x64  rm -rf opencode-windows-$RUNTIME-x64
  cd ../..
}
