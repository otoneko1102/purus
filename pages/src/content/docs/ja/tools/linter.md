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
purus-lint src/main.purus
```

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

プロジェクトルートに `.puruslint.json` を作成します:

```json
{
  "no-var": { "severity": "error" },
  "max-line-length": { "severity": "warn", "max": 80 },

}
```

## プログラマティックAPI

```js
const { lint } = require("@puruslang/linter");

const diagnostics = lint("var x be 42");
// [{ rule: "no-var", severity: "warn", line: 1, col: 1, message: "..." }]
```
