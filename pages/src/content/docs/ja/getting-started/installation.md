---
title: インストール
description: Purusコンパイラのインストール方法。
---

## npmでインストール

```sh
npm install -g purus
```

## 確認

```sh
purus version
```

## 最初のプログラム

`hello.purus` を作成:

```
const message be ///Hello, World///
console.log[message]
```

コンパイルして実行:

```sh
purus build hello.purus
node hello.js
```

## ファイル拡張子

| 拡張子 | 出力 | 用途 |
|---|---|---|
| `.purus` | `.js` | 標準JavaScript |
| `.cpurus` | `.cjs` | CommonJSモジュール |
| `.mpurus` | `.mjs` | ESモジュール |
