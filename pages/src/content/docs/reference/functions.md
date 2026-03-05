---
title: Functions
description: Function declarations and expressions in Purus.
---

## Named function (block body)

```
fn greet name
  console.log[name]
```

Compiles to:

```js
function greet(name) {
  console.log(name);
}
```

## Named function (expression body)

```
fn double x to x mul 2
```

```js
function double(x) {
  return x * 2;
}
```

## Multiple parameters

Use `;` to separate parameters:

```
fn add a; b
  return a add b
```

```js
function add(a, b) {
  return a + b;
}
```

## Anonymous functions

```
const double be fn x to x mul 2
```

```js
const double = (x) => x * 2;
```

## Async functions

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

## Function calls

Use `[]` instead of `()`:

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

## Type annotations (erased)

```
fn add a of Number; b of Number gives Number to a add b
```

Type annotations with `of` and `gives` are erased in the JavaScript output.

## Return

```
fn get-value
  return 42
```
