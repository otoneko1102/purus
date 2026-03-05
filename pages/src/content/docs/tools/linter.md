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
# Lint specific files
purus-lint src/main.purus

# Lint all files in a directory
purus-lint --directory src

# Lint using config.purus settings
purus-lint
```

When no files are specified, `purus-lint` reads `config.purus` and lints all files in the `entry` directory.

### Options

| Option | Alias | Description |
|---|---|---|
| `--directory <dir>` | `-d` | Lint all Purus files in the directory |
| `--config <file>` | | Path to config JSON file (`.puruslint.json`) |
| `--help` | `-h` | Show help |

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

### config.purus

Linter settings can be configured in `config.purus` alongside build settings:

```
-- Linter settings
const lint.no-var be ///warn///
const lint.indent-size be 2
const lint.max-line-length be ///off///
```

### .puruslint.json

Alternatively, create `.puruslint.json` in your project root:

```json
{
  "no-var": { "severity": "error" },
  "max-line-length": { "severity": "warn", "max": 80 }
}
```

`config.purus` takes priority. If no `config.purus` is found, `.puruslint.json` is used as a fallback.

## Programmatic API

```js
const { lint } = require("@puruslang/linter");

const diagnostics = lint("var x be 42");
// [{ rule: "no-var", severity: "warn", line: 1, col: 1, message: "..." }]
```
