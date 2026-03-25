# Break Wit Skill — 動画カット検出、音声＆テキスト抽出、表生成

動画ファイルから最終的にカット表（PDF/PPTX）を自動生成できるAIスキル。
Claude Code、Codex、Gemini CLI、OpenCode、Droid、OpenClawに対応。

## クイックインストール

```bash
bash skills/install.sh
```

対応プラットフォームを自動検出してスキルファイルをインストールします。

## 手動インストール

### Claude Code

```bash
mkdir -p ~/.claude/skills/break-wit
cp skills/SKILL.md ~/.claude/skills/break-wit/SKILL.md
export BREAKWIT_DIR=/path/to/cut-sheet-app
```

### OpenCode

```bash
mkdir -p ~/.config/opencode/skills/break-wit
cp skills/SKILL.md ~/.config/opencode/skills/break-wit/SKILL.md
export BREAKWIT_DIR=/path/to/cut-sheet-app
```

### Codex

```bash
cp skills/AGENTS.md ~/.codex/AGENTS.md
export BREAKWIT_DIR=/path/to/cut-sheet-app
```

### Gemini CLI

```bash
cp skills/AGENTS.md ~/.gemini/GEMINI.md
export BREAKWIT_DIR=/path/to/cut-sheet-app
```

### OpenClaw

```bash
mkdir -p ~/.openclaw/workspace/skills/break-wit
cp skills/openclaw/SKILL.md ~/.openclaw/workspace/skills/break-wit/SKILL.md
export BREAKWIT_DIR=/path/to/cut-sheet-app
```

### Droid

```bash
mkdir -p .factory/skills/break-wit
cp skills/SKILL.md .factory/skills/break-wit/SKILL.md
export BREAKWIT_DIR=/path/to/cut-sheet-app
```

## 必要なもの

- **[Break Wit](https://github.com/MundusCaeli/BreakWit)**（本体アプリ）
- **FFmpeg** — 動画解析
- **bun** — Node.jsランタイム（サーバー起動）
- **jq** — JSON処理
- **curl** — API通信
- **whisper.cpp**（任意）— 高精度な音声起こし

## 使い方

スキルインストール後、AIに動画ファイルのパスを伝えるだけ。

```
この動画のカット表を作って: /path/to/video.mp4
```

### オプション指定の例

```
パワポで横置き3列にして: /path/to/video.mp4
```

```
カット多めで、音声起こしなしで: /path/to/video.mp4
```

```
台本付き: /path/to/video.mp4 (台本: /path/to/script.txt)
```

## 対応プラットフォーム

| プラットフォーム | スキルファイル | 配置先 |
|--------------|-------------|--------|
| Claude Code | `SKILL.md` | `~/.claude/skills/break-wit/` |
| OpenCode | `SKILL.md` | `~/.config/opencode/skills/break-wit/` |
| Droid | `SKILL.md` | `.factory/skills/break-wit/` |
| Codex | `AGENTS.md` | `~/.codex/` |
| Gemini CLI | `GEMINI.md`* | `~/.gemini/` |
| OpenClaw | `openclaw/SKILL.md` | `~/.openclaw/workspace/skills/break-wit/` |

\* Gemini CLI用は `AGENTS.md` を `GEMINI.md` にリネームしてコピー

## ファイル構成

```
skills/
├── README.md               ← このファイル
├── install.sh              ← 自動インストーラー
├── SKILL.md                ← Claude Code / OpenCode / Droid 用
├── AGENTS.md               ← Codex / Gemini CLI 用
└── openclaw/
    └── SKILL.md            ← OpenClaw 用
```
