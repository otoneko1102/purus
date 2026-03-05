---
title: Prettier Plugin
description: "@puruslang/prettier-plugin-purus — format Purus code with Prettier."
---

## Installation

```sh
npm install -D prettier @puruslang/prettier-plugin-purus
```

## Usage

### CLI

```sh
npx prettier --plugin @puruslang/prettier-plugin-purus --write "**/*.{purus,cpurus,mpurus}"
```

### Config file

Add to your `.prettierrc`:

```json
{
  "plugins": ["@puruslang/prettier-plugin-purus"],
  "tabWidth": 2
}
```

## What it formats

- **Indentation**: normalizes to consistent indent (spaces or tabs)
- **Spacing**: normalizes whitespace between tokens
- **Brackets**: no spaces inside `[]` for function calls
- **Separators**: ensures space after `,` and `;`
- **Trailing whitespace**: removes trailing spaces
- **Trailing newline**: ensures file ends with newline

## Example

Before:

```
const x   be   42
fn greet   name
    console.log[  name  ]
```

After:

```
const x be 42
fn greet name
  console.log[name]
```
