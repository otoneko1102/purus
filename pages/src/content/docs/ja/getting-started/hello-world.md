---
title: Hello World
description: 初めてのPurusプログラム。
---

## Hello World

```
const message be ///Hello, World///
console.log[message]
```

コンパイル結果:

```js
const message = "Hello, World";
console.log(message);
```

## JavaScriptとの主な違い

| JavaScript | Purus |
|---|---|
| `=` | `be` |
| `"string"` | `///string///` |
| `fn(args)` | `fn[args]` |
| `{ }` ブロック | インデント |
| `function` | `fn` |
| `+` `-` `*` `/` | `add` `sub` `mul` `div` |
| `===` `!==` | `eq` `ne` |
| `&&` `\|\|` `!` | `and` `or` `not` |

## 変数

```
const x be 42
let y be 3.14
y be 100
```

## 関数

```
fn greet name
  console.log[///Hello/// add name]

greet[///World///]
```

式本体（`to`を使用）:

```
fn double x to x mul 2
```
