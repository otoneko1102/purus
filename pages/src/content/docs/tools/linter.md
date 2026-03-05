---
title: Linter
description: "@puruslang/linter — static analysis for Purus."
---

## Installation

```sh
npm install -D @puruslang/linter
```

Or globally:

```sh
npm install -g @puruslang/linter
```

## Usage

```sh
purus-lint src/main.purus
```

## Rules

| Rule | Default | Description |
|---|---|---|
| `no-var` | `warn` | Avoid `var`; use `const` or `let` |
| `no-nil` | `warn` | Use `null` instead of `nil` |

| `indent-size` | `warn` (2) | Indentation must be a multiple of N spaces |
| `no-trailing-whitespace` | `warn` | No trailing whitespace |
| `max-line-length` | `off` (100) | Maximum line length |
| `consistent-naming` | `warn` (kebab-case) | Naming convention |

## Configuration

Create `.puruslint.json` in your project root:

```json
{
  "no-var": { "severity": "error" },
  "max-line-length": { "severity": "warn", "max": 80 },

}
```

## Programmatic API

```js
const { lint } = require("@puruslang/linter");

const diagnostics = lint("var x be 42");
// [{ rule: "no-var", severity: "warn", line: 1, col: 1, message: "..." }]
```
