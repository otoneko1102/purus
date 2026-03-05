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

またはファイルを生成せずに直接実行:

```sh
purus run hello.purus
```

## プロジェクトを作成

`purus new` で設定、スクリプト、依存関係を含むプロジェクトをセットアップ:

```sh
purus new my-project
cd my-project
npm run build
```

## ファイル拡張子

| 拡張子 | 出力 | 用途 |
|---|---|---|
| `.purus` | `.js` | 標準JavaScript |
| `.cpurus` | `.cjs` | CommonJSモジュール |
| `.mpurus` | `.mjs` | ESモジュール |
