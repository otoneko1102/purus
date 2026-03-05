---
title: 演算子
description: Purusの演算子と優先順位。
---

## 演算子の優先順位（低い順）

1. `pipe` — パイプライン
2. `or` — 論理OR
3. `and` — 論理AND
4. `eq` / `ne` / `is` / `instanceof` — 等価 / 型チェック
5. `lt` / `gt` / `le` / `ge` — 比較
6. `add` / `sub` — 加算 / 減算
7. `mul` / `div` / `mod` — 乗算 / 除算 / 剰余
8. 単項: `not` / `neg` / `typeof` / `await` / `delete` / `new`
9. 後置: `.` アクセス / `[args]` 呼び出し / `as` キャスト
10. 基本: リテラル、識別子、括弧

## パイプライン

```
data pipe filter
data pipe filter pipe map
data pipe transform[extra-arg]
data pipe .method[arg]
```

コンパイル結果:

```js
filter(data)
map(filter(data))
transform(data, extraArg)
data.method(arg)
```

## 代入

```
const x be 42
let y be 10
y be 20
```

## 算術

```
a add b    -- a + b
a sub b    -- a - b
a mul b    -- a * b
a div b    -- a / b
a mod b    -- a % b
neg x      -- -x
```

## 比較

```
a eq b     -- a === b
a ne b     -- a !== b
a lt b     -- a < b
a gt b     -- a > b
a le b     -- a <= b
a ge b     -- a >= b
```

## 論理

```
a and b    -- a && b
a or b     -- a || b
not x      -- !x
```

## 型チェック

```
x is string          -- typeof x === "string"
x is null            -- x === null
x is MyClass         -- x instanceof MyClass
x instanceof Y       -- x instanceof Y
typeof x             -- typeof x
```
