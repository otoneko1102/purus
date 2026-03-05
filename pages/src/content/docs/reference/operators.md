---
title: Operators
description: Purus operators and precedence.
---

## Operator Precedence (low to high)

1. `pipe` — Pipeline
2. `or` — Logical OR
3. `and` — Logical AND
4. `eq` / `ne` / `is` / `instanceof` — Equality / Type check
5. `lt` / `gt` / `le` / `ge` — Comparison
6. `add` / `sub` — Addition / Subtraction
7. `mul` / `div` / `mod` — Multiplication / Division / Modulo
8. Unary: `not` / `neg` / `typeof` / `await` / `delete` / `new`
9. Postfix: `.` access / `[args]` call / `as` cast
10. Primary: literals, identifiers, brackets

## Pipeline

```
data pipe filter
data pipe filter pipe map
data pipe transform[extra-arg]
data pipe .method[arg]
```

Compiles to:

```js
filter(data)
map(filter(data))
transform(data, extraArg)
data.method(arg)
```

## Assignment

```
const x be 42
let y be 10
y be 20
```

## Arithmetic

```
a add b    -- a + b
a sub b    -- a - b
a mul b    -- a * b
a div b    -- a / b
a mod b    -- a % b
neg x      -- -x
```

## Comparison

```
a eq b     -- a === b
a ne b     -- a !== b
a lt b     -- a < b
a gt b     -- a > b
a le b     -- a <= b
a ge b     -- a >= b
```

## Logical

```
a and b    -- a && b
a or b     -- a || b
not x      -- !x
```

## Type Checks

```
x is string          -- typeof x === "string"
x is null            -- x === null
x is MyClass         -- x instanceof MyClass
x instanceof Y       -- x instanceof Y
typeof x             -- typeof x
```
