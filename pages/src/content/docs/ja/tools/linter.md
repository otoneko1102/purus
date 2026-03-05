---
title: リンター
description: "@puruslang/linter — Purusの静的解析ツール。"
---

## インストール

```sh
npm install -D @puruslang/linter
```

グローバルインストール:

```sh
npm install -g @puruslang/linter
```

## 使い方

```sh
# 特定のファイルをリント
purus-lint src/main.purus

# ディレクトリ内の全ファイルをリント
purus-lint --directory src

# config.purusの設定を使用してリント
purus-lint
```

ファイルが指定されていない場合、`purus-lint` は `config.purus` を読み込み、`entry` ディレクトリ内の全ファイルをリントします。

### オプション

| オプション | エイリアス | 説明 |
|---|---|---|
| `--directory <dir>` | `-d` | ディレクトリ内の全Purusファイルをリント |
| `--config <file>` | | 設定JSONファイルのパス（`.puruslint.json`） |
| `--help` | `-h` | ヘルプを表示 |

## ルール

| ルール | デフォルト | 説明 |
|---|---|---|
| `no-var` | `warn` | `var`を避け、`const`や`let`を使用する |
| `no-nil` | `warn` | `nil`の代わりに`null`を使用する |
| `indent-size` | `warn` (2) | インデントはNスペースの倍数であること |
| `no-trailing-whitespace` | `warn` | 末尾の空白を禁止 |
| `max-line-length` | `off` (100) | 行の最大長 |
| `consistent-naming` | `warn` (kebab-case) | 命名規則 |

## 設定

### config.purus

リンターの設定は `config.purus` でビルド設定と一緒に設定できます:

```
-- Linter settings
const lint.no-var be ///warn///
const lint.indent-size be 2
const lint.max-line-length be ///off///
```

### .puruslint.json

または、プロジェクトルートに `.puruslint.json` を作成:

```json
{
  "no-var": { "severity": "error" },
  "max-line-length": { "severity": "warn", "max": 80 }
}
```

`config.purus` が優先されます。`config.purus` が見つからない場合、`.puruslint.json` がフォールバックとして使用されます。

## プログラマティックAPI

```js
const { lint } = require("@puruslang/linter");

const diagnostics = lint("var x be 42");
// [{ rule: "no-var", severity: "warn", line: 1, col: 1, message: "..." }]
```
