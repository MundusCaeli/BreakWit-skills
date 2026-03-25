#!/usr/bin/env bash
# ==============================================================================
# Break Wit Skill インストーラー
#
# 使い方:
#   bash skills/install.sh
#
# 対応プラットフォーム:
#   - Claude Code (~/.claude/skills/)
#   - Codex (~/.codex/)
#   - Gemini CLI (~/.gemini/)
#   - OpenCode (~/.config/opencode/skills/ or ~/.claude/skills/)
#   - Droid (.factory/skills/)
#   - OpenClaw (~/.openclaw/workspace/skills/)
# ==============================================================================
set -euo pipefail

# --- 色定義 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- BREAKWIT_DIR を自動判定 ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREAKWIT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE} Break Wit Skill インストーラー${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "プロジェクトディレクトリ: ${GREEN}$BREAKWIT_DIR${NC}"
echo ""

# --- インストール結果の記録 ---
INSTALLED=()

# --- プラットフォーム検出 & インストール ---

# Claude Code
if [ -d "$HOME/.claude" ]; then
  DEST="$HOME/.claude/skills/break-wit"
  mkdir -p "$DEST"
  cp "$SCRIPT_DIR/SKILL.md" "$DEST/SKILL.md"
  INSTALLED+=("Claude Code → $DEST/SKILL.md")
  echo -e "${GREEN}✓${NC} Claude Code: インストール完了"
fi

# Codex
if [ -d "$HOME/.codex" ]; then
  DEST_FILE="$HOME/.codex/AGENTS.md"
  if [ -f "$DEST_FILE" ]; then
    echo -e "${YELLOW}⚠${NC} 既存の $DEST_FILE を検出"
    cp "$DEST_FILE" "${DEST_FILE}.bak.$(date +%Y%m%d%H%M%S)"
    echo -e "  バックアップ: ${DEST_FILE}.bak.*"
  fi
  cp "$SCRIPT_DIR/AGENTS.md" "$DEST_FILE"
  INSTALLED+=("Codex → $DEST_FILE")
  echo -e "${GREEN}✓${NC} Codex: インストール完了"
fi

# Gemini CLI
if [ -d "$HOME/.gemini" ]; then
  DEST_FILE="$HOME/.gemini/GEMINI.md"
  if [ -f "$DEST_FILE" ]; then
    echo -e "${YELLOW}⚠${NC} 既存の $DEST_FILE を検出"
    cp "$DEST_FILE" "${DEST_FILE}.bak.$(date +%Y%m%d%H%M%S)"
    echo -e "  バックアップ: ${DEST_FILE}.bak.*"
  fi
  cp "$SCRIPT_DIR/AGENTS.md" "$DEST_FILE"
  INSTALLED+=("Gemini CLI → $DEST_FILE")
  echo -e "${GREEN}✓${NC} Gemini CLI: インストール完了"
fi

# OpenCode
if [ -d "$HOME/.config/opencode" ]; then
  DEST="$HOME/.config/opencode/skills/break-wit"
  mkdir -p "$DEST"
  cp "$SCRIPT_DIR/SKILL.md" "$DEST/SKILL.md"
  INSTALLED+=("OpenCode → $DEST/SKILL.md")
  echo -e "${GREEN}✓${NC} OpenCode: インストール完了"
fi

# Droid (project-local)
if [ -d "$BREAKWIT_DIR/.factory" ]; then
  DEST="$BREAKWIT_DIR/.factory/skills/break-wit"
  mkdir -p "$DEST"
  cp "$SCRIPT_DIR/SKILL.md" "$DEST/SKILL.md"
  INSTALLED+=("Droid → $DEST/SKILL.md")
  echo -e "${GREEN}✓${NC} Droid: インストール完了"
fi

# OpenClaw
if [ -d "$HOME/.openclaw" ]; then
  DEST="$HOME/.openclaw/workspace/skills/break-wit"
  mkdir -p "$DEST"
  cp "$SCRIPT_DIR/openclaw/SKILL.md" "$DEST/SKILL.md"
  INSTALLED+=("OpenClaw → $DEST/SKILL.md")
  echo -e "${GREEN}✓${NC} OpenClaw: インストール完了"
fi

echo ""

# --- 結果表示 ---
if [ ${#INSTALLED[@]} -eq 0 ]; then
  echo -e "${YELLOW}⚠ 対応プラットフォームが検出されませんでした。${NC}"
  echo "手動インストールは skills/README.md を参照してください。"
  exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} インストール完了（${#INSTALLED[@]} プラットフォーム）${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
for item in "${INSTALLED[@]}"; do
  echo -e "  ${GREEN}✓${NC} $item"
done

# --- BREAKWIT_DIR の環境変数設定 ---
echo ""
echo -e "${BLUE}--- 環境変数の設定 ---${NC}"
echo ""

# 現在の設定を確認
if [ -n "${BREAKWIT_DIR:-}" ]; then
  CURRENT_IN_PROFILE=false

  for PROFILE in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
    if [ -f "$PROFILE" ] && grep -q "BREAKWIT_DIR" "$PROFILE" 2>/dev/null; then
      CURRENT_IN_PROFILE=true
      break
    fi
  done

  if [ "$CURRENT_IN_PROFILE" = true ]; then
    echo -e "${GREEN}✓${NC} BREAKWIT_DIR は既にシェルプロファイルに設定されています。"
  else
    echo "以下のコマンドをシェルプロファイルに追加してください："
    echo ""
    echo -e "  ${YELLOW}export BREAKWIT_DIR=\"$BREAKWIT_DIR\"${NC}"
    echo ""

    # 自動追加の提案
    SHELL_RC=""
    if [ -f "$HOME/.zshrc" ]; then
      SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
      SHELL_RC="$HOME/.bashrc"
    fi

    if [ -n "$SHELL_RC" ]; then
      echo -n "自動で $SHELL_RC に追加しますか？ [y/N]: "
      read -r REPLY
      if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
        if ! grep -q "export BREAKWIT_DIR=" "$SHELL_RC" 2>/dev/null; then
          echo "" >> "$SHELL_RC"
          echo "# Break Wit" >> "$SHELL_RC"
          echo "export BREAKWIT_DIR=\"$BREAKWIT_DIR\"" >> "$SHELL_RC"
        else
          # 既存のパスを更新
          sed -i '' "s|export BREAKWIT_DIR=.*|export BREAKWIT_DIR=\"$BREAKWIT_DIR\"|" "$SHELL_RC"
        fi
        echo -e "${GREEN}✓${NC} $SHELL_RC に追加しました。"
        echo -e "  ${YELLOW}source $SHELL_RC${NC} で反映してください。"
      else
        echo "スキップしました。手動で追加してください。"
      fi
    fi
  fi
fi

echo ""
echo -e "${GREEN}セットアップ完了！${NC} 動画ファイルのパスを指定してカット表を生成できます。"
