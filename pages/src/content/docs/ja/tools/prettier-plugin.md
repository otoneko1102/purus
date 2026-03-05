---
title: Prettierプラグイン
description: "@puruslang/prettier-plugin-purus — PrettierでPurusコードをフォーマット。"
---

## インストール

```sh
npm install -D prettier @puruslang/prettier-plugin-purus
```

## 使い方

### CLI

```sh
npx prettier --plugin @puruslang/prettier-plugin-purus --write "**/*.{purus,cpurus,mpurus}"
```

### 設定ファイル

`.prettierrc` に追加:

```json
{
  "plugins": ["@puruslang/prettier-plugin-purus"],
  "tabWidth": 2
}
```

## フォーマット内容

- **インデント**: 一貫したインデントに正規化（スペースまたはタブ）
- **スペース**: トークン間の空白を正規化
- **括弧**: 関数呼び出しの `[]` 内にスペースを入れない
- **区切り文字**: `,` と `;` の後にスペースを確保
- **末尾の空白**: 末尾のスペースを削除
- **末尾の改行**: ファイルが改行で終わることを保証

## 例

フォーマット前:

```
const x   be   42
fn greet   name
    console.log[  name  ]
```

フォーマット後:

```
const x be 42
fn greet name
  console.log[name]
```
