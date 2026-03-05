---
title: VS Code拡張機能
description: Visual Studio Code向けPurus言語サポート。
---

## インストール

VS Code拡張機能マーケットプレイスで **Purus** を検索するか、コマンドラインからインストール:

```sh
code --install-extension otoneko1102.purus
```

## 機能

### シンタックスハイライト

`.purus`、`.cpurus`、`.mpurus` ファイル向けの完全なTextMate文法:

- キーワード (`fn`, `const`, `let`, `if`, `for`, `match` など)
- 演算子 (`be`, `add`, `sub`, `eq`, `and`, `pipe` など)
- 文字列 (`///...///`)
- コメント (`--` 行コメント, `---` ブロックコメント)
- 数値（整数、浮動小数点数）
- 関数定義と呼び出し
- 正規表現

### スニペット

| プレフィックス | 説明 |
|---|---|
| `fn` | 関数宣言 |
| `fnt` | 式本体の関数 |
| `afn` | 非同期関数 |
| `const` | 定数宣言 |
| `let` | 変数宣言 |
| `if` | if文 |
| `ife` | if-else文 |
| `unless` | unless文 |
| `for` | for-inループ |
| `forr` | for-rangeループ |
| `while` | whileループ |
| `until` | untilループ |
| `match` | マッチ式 |
| `try` | try-catchブロック |
| `imp` | import文 |
| `impn` | 名前付きimport |
| `pub` | エクスポート (pub) |
| `mod` | モジュール名前空間 |
| `log` | console.log |

### ファイルアイコン

`.purus`、`.cpurus`、`.mpurus` ファイルには自動的にPurusアイコンが適用されます。settings.jsonの変更は不要です。

### 言語設定

- **コメントトグル**: `Ctrl+/` で `--` 行コメントを挿入
- **ブロックコメント**: `--- ... ---`
- **自動閉じ**: `[]` 括弧と `///` 文字列
- **折りたたみ**: インデントベースの折りたたみ（オフサイドルール）
- **ワードパターン**: `kebab-case` 識別子をサポート
