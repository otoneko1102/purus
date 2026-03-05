---
title: Hello World
description: Your first Purus program.
---

## Hello World

```
const message be ///Hello, World///
console.log[message]
```

This compiles to:

```js
const message = "Hello, World";
console.log(message);
```

## Running

Compile to a file:

```sh
purus build hello.purus
node hello.js
```

Or run directly:

```sh
purus run hello.purus
```

## Key differences from JavaScript

| JavaScript | Purus |
|---|---|
| `=` | `be` |
| `"string"` | `///string///` |
| `fn(args)` | `fn[args]` |
| `{ }` blocks | indentation |
| `function` | `fn` |
| `+` `-` `*` `/` | `add` `sub` `mul` `div` |
| `===` `!==` | `eq` `ne` |
| `&&` `\|\|` `!` | `and` `or` `not` |

## Variables

```
const x be 42
let y be 3.14
y be 100
```

## Functions

```
fn greet name
  console.log[///Hello/// add name]

greet[///World///]
```

Expression body with `to`:

```
fn double x to x mul 2
```
