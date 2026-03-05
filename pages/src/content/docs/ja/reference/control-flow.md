---
title: 制御フロー
description: Purusの条件分岐、ループ、パターンマッチ。
---

## If / Elif / Else

```
if x lt 0
  console.log[///negative///]
elif x eq 0
  console.log[///zero///]
else
  console.log[///positive///]
```

## Unless

`if` の否定:

```
unless done
  keep-going[]
```

```js
if (!(done)) {
  keepGoing();
}
```

## インラインif（三項演算子）

```
const result be if condition then 1 else 2
```

```js
const result = condition ? 1 : 2;
```

## 後置修飾子

```
console.log[///debug///] if verbose
console.log[///skip///] unless done
console.log[item] for item in list
```

## While / Until

```
while i lt 10
  i be i add 1

until finished
  do-work[]
```

## For-in

```
for item in items
  console.log[item]
```

```js
for (const item of items) {
  console.log(item);
}
```

インデックス付き:

```
for i; item in items
  console.log[i; item]
```

```js
for (let [i, item] of items.entries()) {
  console.log(i, item);
}
```

## For-range

```
for i in range 0; 10
  console.log[i]
```

```js
for (let i = 0; i < 10; i++) {
  console.log(i);
}
```

## Match / When

```
match x
  when 1 then ///one///
  when 2 then ///two///
  else ///other///
```

ガード付き:

```
match value
  when n if n gt 0
    console.log[///positive///]
  else
    console.log[///non-positive///]
```

## try / catch / finally

```
try
  risky[]
catch e
  console.log[e]
finally
  cleanup[]
```

### 式としてのtry

```
const result be try
  risky[]
catch e
  default-value
```

## Throw

```
throw new Error[///something went wrong///]
throw err if condition
```
