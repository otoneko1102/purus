---
title: Installation
description: How to install the Purus compiler.
---

## Install via npm

```sh
npm install -g purus
```

## Verify

```sh
purus version
```

## Your first program

Create a file `hello.purus`:

```
const message be ///Hello, World///
console.log[message]
```

Compile and run:

```sh
purus build hello.purus
node hello.js
```

## File extensions

| Extension | Output | Use case |
|---|---|---|
| `.purus` | `.js` | Standard JavaScript |
| `.cpurus` | `.cjs` | CommonJS module |
| `.mpurus` | `.mjs` | ES Module |
