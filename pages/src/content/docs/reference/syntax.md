---
title: Syntax Overview
description: Overview of Purus syntax.
---

## File Extensions

| Extension | Output | Description |
|---|---|---|
| `.purus` | `.js` | Standard JavaScript |
| `.cpurus` | `.cjs` | CommonJS module |
| `.mpurus` | `.mjs` | ES Module |

## Comments

```
-- This is a line comment

--- This is a
block comment ---
```

## Strings

Strings use triple slashes `///`:

```
const greeting be ///Hello, World///
```

### Escape sequences

| Escape | Result |
|---|---|
| `\n` | Newline |
| `\t` | Tab |
| `\\` | Backslash |
| `\/` | `/` |
| `\[` | `[` |
| `\]` | `]` |

## Numbers

```
const i be 42
const f be 3.14
```

## Booleans and null

```
const a be true
const b be false
const c be null
const d be nil       -- alias for null
const e be undefined
```

## Arrays

```
const arr be [1, 2, 3]
const arr2 be [1; 2; 3]   -- semicolons also work
const empty be []
```

## Objects

```
const obj be [name be ///Alice///, age be 30]
const empty-obj be [be]    -- empty object
```

## Brackets only

Purus uses `[]` for everything — function calls, arrays, objects, and grouping. No `()` or `{}`.

## Indentation

Blocks are defined by indentation (2 spaces recommended):

```
if x gt 0
  console.log[///positive///]
else
  console.log[///non-positive///]
```

## Identifiers

Identifiers can contain hyphens (`-`), which are converted to underscores in JavaScript output:

```
const my-variable be 42
-- compiles to: const my_variable = 42;
```
