---
title: 関数
description: Purusの関数宣言と式。
---

## 名前付き関数（ブロック本体）

```
fn greet name
  console.log[name]
```

コンパイル結果:

```js
function greet(name) {
  console.log(name);
}
```

## 名前付き関数（式本体）

```
fn double x to x mul 2
```

```js
function double(x) {
  return x * 2;
}
```

## 複数パラメータ

パラメータの区切りには `;` を使います:

```
fn add a; b
  return a add b
```

```js
function add(a, b) {
  return a + b;
}
```

## 無名関数

```
const double be fn x to x mul 2
```

```js
const double = (x) => x * 2;
```

## 非同期関数

```
async fn fetch-data url
  const res be await fetch[url]
  return res
```

```js
async function fetchData(url) {
  const res = await fetch(url);
  return res;
}
```

## 関数呼び出し

`()` の代わりに `[]` を使います:

```
greet[///world///]
add[1; 2]
console.log[///hello///]
```

```js
greet("world");
add(1, 2);
console.log("hello");
```

## 型注釈（消去される）

```
fn add a of Number; b of Number gives Number to a add b
```

`of` と `gives` による型注釈はJavaScript出力では消去されます。

## return

```
fn get-value
  return 42
```
