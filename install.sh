#!/bin/bash
# swiftmcp 설치 스크립트
# curl -fsSL https://raw.githubusercontent.com/oozoofrog/swiftmcp/main/install.sh | bash
set -euo pipefail

REPO="oozoofrog/swiftmcp"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="swiftmcp"

# 색상 (tty일 때만)
if [ -t 1 ]; then
  BOLD='\033[1m'
  GREEN='\033[32m'
  RED='\033[31m'
  RESET='\033[0m'
else
  BOLD='' GREEN='' RED='' RESET=''
fi

info()  { printf "${BOLD}==>${RESET} %s\n" "$1"; }
error() { printf "${RED}error:${RESET} %s\n" "$1" >&2; exit 1; }

# macOS 전용
[ "$(uname -s)" = "Darwin" ] || error "swiftmcp는 현재 macOS만 지원합니다."

# 아키텍처 감지
ARCH="$(uname -m)"
case "$ARCH" in
  arm64)  ASSET="swiftmcp-macos-arm64.tar.gz" ;;
  x86_64) ASSET="swiftmcp-macos-x86_64.tar.gz" ;;
  *)      error "지원하지 않는 아키텍처: $ARCH" ;;
esac

# 최신 릴리스 태그 가져오기
info "최신 릴리스 확인 중..."
LATEST_TAG=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
[ -n "$LATEST_TAG" ] || error "릴리스를 찾을 수 없습니다."
info "버전: ${LATEST_TAG}"

# 다운로드
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${ASSET}"
TMPDIR_PATH=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PATH"' EXIT

info "${ARCH} 바이너리 다운로드 중..."
curl -fsSL -o "${TMPDIR_PATH}/${ASSET}" "$DOWNLOAD_URL" \
  || error "다운로드 실패: ${DOWNLOAD_URL}"

# 압축 해제
info "압축 해제 중..."
tar xzf "${TMPDIR_PATH}/${ASSET}" -C "$TMPDIR_PATH"
[ -f "${TMPDIR_PATH}/${BINARY_NAME}" ] || error "바이너리를 찾을 수 없습니다."

# 설치
info "${INSTALL_DIR}/${BINARY_NAME} 설치 중..."
if [ -w "$INSTALL_DIR" ]; then
  mv "${TMPDIR_PATH}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
  sudo mv "${TMPDIR_PATH}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# 검증
if command -v "$BINARY_NAME" >/dev/null 2>&1; then
  VERSION=$("$BINARY_NAME" --version 2>/dev/null || echo "$LATEST_TAG")
  printf "\n${GREEN}${BOLD}✓ swiftmcp ${VERSION} 설치 완료${RESET}\n"
  echo "  실행: swiftmcp --help"
else
  printf "\n${GREEN}${BOLD}✓ 설치 완료${RESET} (${INSTALL_DIR}/${BINARY_NAME})\n"
  echo "  PATH에 ${INSTALL_DIR}이 포함되어 있는지 확인하세요."
fi
