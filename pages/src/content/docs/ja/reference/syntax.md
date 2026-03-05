---
title: 構文の概要
description: Purusの構文の概要。
---

## ファイル拡張子

| 拡張子 | 出力 | 説明 |
|---|---|---|
| `.purus` | `.js` | 標準JavaScript |
| `.cpurus` | `.cjs` | CommonJSモジュール |
| `.mpurus` | `.mjs` | ESモジュール |

## コメント

```
-- これは行コメントです

--- これはブロック
コメントです ---
```

## 文字列

文字列はトリプルスラッシュ `///` で囲みます:

```
const greeting be ///Hello, World///
```

### エスケープシーケンス

| エスケープ | 結果 |
|---|---|
| `\n` | 改行 |
| `\t` | タブ |
| `\\` | バックスラッシュ |
| `\/` | `/` |
| `\[` | `[` |
| `\]` | `]` |

## 数値

```
const i be 42
const f be 3.14
```

## 真偽値とnull

```
const a be true
const b be false
const c be null
const d be nil       -- nullのエイリアス
const e be undefined
```

## 配列

```
const arr be [1, 2, 3]
const arr2 be [1; 2; 3]   -- セミコロンも使用可能
const empty be []
```

## オブジェクト

```
const obj be [name be ///Alice///, age be 30]
const empty-obj be [be]    -- 空のオブジェクト
```

## 括弧は`[]`のみ

Purusでは関数呼び出し、配列、オブジェクト、グループ化のすべてに `[]` を使用します。`()` や `{}` は使いません。

## インデント

ブロックはインデントで定義されます（2スペース推奨）:

```
if x gt 0
  console.log[///positive///]
else
  console.log[///non-positive///]
```

## 識別子

識別子にはハイフン（`-`）を含めることができ、JavaScript出力ではアンダースコアに変換されます:

```
const my-variable be 42
-- コンパイル結果: const my_variable = 42;
```
