#!/bin/bash
# stellar-coding-agent — Session Bootstrap (git-tracked)
# Self-heals skill files and starts dev server. Run once per session.
#
# Usage:  cd ~/my-project && bash boot.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill/stellar-coding-agent"
INSTALL_DIR="$SCRIPT_DIR/skills/stellar-coding-agent"

# ── 1. Self-heal: copy git-tracked skill/ → platform skills/ ─────
if [ ! -f "$INSTALL_DIR/SKILL.md" ] || ! grep -q "Phase State Machine" "$INSTALL_DIR/SKILL.md" 2>/dev/null; then
  if [ -d "$SOURCE_DIR" ]; then
    echo "[boot] Healing skill files → skills/"
    rm -rf "${INSTALL_DIR:?}"
    cp -R "$SOURCE_DIR" "$INSTALL_DIR"
    echo "[boot] Done"
  else
    echo "[boot] ERROR: skill/ not found. Is this the repo root?"
    exit 1
  fi
else
  echo "[boot] Skill files OK"
fi

# ── 2. Deploy custom splash ──────────────────────────────────────
# Assets are gitignored — only exist if previously bootstrapped
SPLASH="$INSTALL_DIR/assets/page.tsx"
TARGET="$SCRIPT_DIR/src/app/page.tsx"
DEV_SCRIPT="$SCRIPT_DIR/.zscripts/dev.sh"

if [ -f "$SPLASH" ]; then
  mkdir -p "$(dirname "$TARGET")"
  cp "$SPLASH" "$TARGET"
  echo "[boot] Splash deployed → src/app/page.tsx"
fi

# ── 3. Dev server ────────────────────────────────────────────────
if curl -s --connect-timeout 2 "http://localhost:3000" >/dev/null 2>&1; then
  echo "[boot] Dev server running on :3000"
  exit 0
fi

if [ -f "$DEV_SCRIPT" ]; then
  echo "[boot] Starting dev server..."
  chmod +x "$DEV_SCRIPT"
  DATABASE_URL="${DATABASE_URL:-file:${SCRIPT_DIR}/db/custom.db}"
  (
    cd "$SCRIPT_DIR"
    nohup bash "$DEV_SCRIPT" >>"$SCRIPT_DIR/.zscripts/dev.log" 2>&1 </dev/null &
    echo "$!" >"$SCRIPT_DIR/.zscripts/dev.pid"
  )
  for i in $(seq 1 30); do
    if curl -s --connect-timeout 2 "http://localhost:3000" >/dev/null 2>&1; then
      echo "[boot] Ready on :3000"
      exit 0
    fi
    sleep 1
  done
  echo "[boot] WARNING: health check timed out"
  exit 1
else
  echo "[boot] No .zscripts/dev.sh — run fullstack-dev init first"
  exit 1
fi
