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

Or run directly without generating files:

```sh
purus run hello.purus
```

## Create a project

Use `purus new` to set up a project with configuration, scripts, and dependencies:

```sh
purus new my-project
cd my-project
npm run build
```

## File extensions

| Extension | Output | Use case |
|---|---|---|
| `.purus` | `.js` | Standard JavaScript |
| `.cpurus` | `.cjs` | CommonJS module |
| `.mpurus` | `.mjs` | ES Module |
