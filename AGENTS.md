# Break Wit — 動画カット表自動生成

動画ファイルを解析してカット表（PDF/PPTX）を自動生成するスキル。

## Setup

### 必要な環境変数

```bash
export BREAKWIT_DIR=/path/to/cut-sheet-app   # Break Witプロジェクトのパス
export BREAKWIT_PORT=3001                     # サーバーポート（デフォルト: 3001）
```

### 必要なツール

- FFmpeg
- bun（Node.jsランタイム）
- jq, curl

## Usage

動画ファイルのパスを指定してカット表を生成する。

### トリガーキーワード

日本語: 「カット表」「動画解析」
英語: "cut sheet", "break wit", "scene detection"

### ワークフロー

0. **環境検証**: 実行前に `test -x "$BREAKWIT_DIR/scripts/break-wit-cli.sh"` で CLIスクリプトの存在を確認する。失敗した場合は `BREAKWIT_DIR` の設定を確認するよう案内する。
1. **サーバー確認**: `bash "$BREAKWIT_DIR/scripts/start-breakwit-server.sh" --status` で確認。停止中なら `bash "$BREAKWIT_DIR/scripts/start-breakwit-server.sh"` で起動。
2. **CLI実行**: `bash "$BREAKWIT_DIR/scripts/break-wit-cli.sh"` で処理。タイムアウトは最低5分。
3. **結果報告**: CLI出力のJSONからカット数・動画尺・解像度・出力パスをユーザーに報告。

## Commands

### 基本コマンド

```bash
bash "$BREAKWIT_DIR/scripts/break-wit-cli.sh" \
  --input "<動画ファイルのパス>" \
  --format <pdf|pptx> \
  --template <テンプレート名> \
  --output "<出力先パス>/<ファイル名>.<拡張子>"
```

### 台本テキスト付き

```bash
bash "$BREAKWIT_DIR/scripts/break-wit-cli.sh" \
  --input "<動画ファイルのパス>" \
  --format <pdf|pptx> \
  --template <テンプレート名> \
  --script "<台本ファイルのパス>" \
  --output "<出力先パス>/<ファイル名>.<拡張子>"
```

### オプション一覧

| オプション | 説明 | デフォルト |
|-----------|------|-----------|
| `--input PATH` | 入力動画ファイル（必須） | — |
| `--format FORMAT` | `pdf` または `pptx` | `pdf` |
| `--template ID` | テンプレートID | 自動選択 |
| `--script PATH` | 台本テキストファイル | なし |
| `--output PATH` | 出力先パス | 入力と同じディレクトリ |
| `--threshold NUM` | シーン検出しきい値 0.0〜1.0 | `0.3` |
| `--no-narration` | 音声起こしスキップ | — |
| `--no-ocr` | OCRスキップ | — |

### ユーザー意図の解析

| ユーザーの表現 | オプション |
|--------------|----------|
| 「PDFで」 | `--format pdf` |
| 「パワポで」「PPTXで」 | `--format pptx` |
| 「もっと細かく」「カット多め」 | `--threshold 0.2` |
| 「大まかに」「少なめ」 | `--threshold 0.5` |
| 「音声起こし不要」 | `--no-narration` |
| 「OCRなし」 | `--no-ocr` |
| 「カットだけ」「映像のみ」 | `--no-narration --no-ocr` |

### 出力ファイル名の命名規則

元の動画ファイル名をベースにする。例: `video.mp4` → `video_cutsheet.pdf`

## Templates

### 横動画用
| テンプレート名 | 説明 |
|---------------|------|
| `h-portrait-1col-10` | 縦置き・1列・1ページ10カット |
| `h-portrait-2col-12` | 縦置き・2列・1ページ12カット（デフォルト） |
| `h-portrait-2col-14` | 縦置き・2列・1ページ14カット |
| `h-landscape-2col-12` | 横置き・2列・1ページ12カット |
| `h-landscape-3col-21` | 横置き・3列・1ページ21カット |

### 縦動画用
| テンプレート名 | 説明 |
|---------------|------|
| `v-portrait-2col-10` | 縦置き・2列・1ページ10カット |
| `v-portrait-2col-12` | 縦置き・2列・1ページ12カット |
| `v-landscape-1row-6` | 横置き・1行・1ページ6カット |
| `v-landscape-2row-6` | 横置き・2行・1ページ6カット |

テンプレート指定なしの場合、動画のアスペクト比から自動選択する：
- 横動画 → `h-portrait-2col-12`
- 縦動画 → `v-portrait-2col-12`

## CLI Output Format

### 成功時（stdout）

```json
{
  "success": true,
  "outputPath": "/path/to/output.pdf",
  "cutCount": 15,
  "duration": 120.5,
  "resolution": "1920x1080",
  "format": "pdf"
}
```

### エラー時（stderr）

```json
{
  "success": false,
  "error": "Error message",
  "step": "detect"
}
```

## Error Handling

| エラー内容 | ユーザーへのメッセージ |
|-----------|---------------------|
| `BREAKWIT_DIR` 未設定 | 「`export BREAKWIT_DIR=/path/to/cut-sheet-app` を実行してください。」 |
| ファイルが見つからない | 「動画ファイルが見つかりませんでした。パスを確認してください。」 |
| FFmpeg関連 | 「動画の解析中にエラーが発生しました。別の形式で試していただけますか？」 |
| サーバー起動失敗 | 「サーバーの起動に失敗しました。`bash "$BREAKWIT_DIR/scripts/start-breakwit-server.sh"` を手動で実行してください。」 |
| その他 | 「処理中にエラーが発生しました。もう一度お試しください。」 |

## Response Guidelines

- **言語:** 日本語で応答。ユーザーが英語の場合は英語で応答。
- **トーン:** カジュアルだが丁寧。プロフェッショナルな信頼感を保つ。
- **簡潔に:** 処理状況と結果を簡潔に伝える。
- `duration`（秒数）は「○分○秒」形式に変換して表示する。
