#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const { lint, defaultRules } = require("./index.js");
const { loadConfig } = require("./config.js");

const args = process.argv.slice(2);

if (args.includes("--help") || args.includes("-h")) {
  console.log("purus-lint - Linter for the Purus language");
  console.log("");
  console.log("Usage:");
  console.log("  purus-lint [file...]                 Lint specific files");
  console.log("  purus-lint --directory <dir>         Lint all files in directory");
  console.log("  purus-lint                           Lint using config.purus");
  console.log("");
  console.log("Options:");
  console.log("  --config <file>  Path to config JSON file");
  console.log("  --directory, -d  Directory to lint");
  console.log("  --fix            (not yet implemented)");
  console.log("  --help           Show this help");
  process.exit(0);
}

// Collect files and options
let configPath = null;
let directory = null;
const files = [];

for (let i = 0; i < args.length; i++) {
  if (args[i] === "--config" && i + 1 < args.length) {
    configPath = args[++i];
  } else if ((args[i] === "--directory" || args[i] === "-d") && i + 1 < args.length) {
    directory = args[++i];
  } else if (!args[i].startsWith("-")) {
    files.push(args[i]);
  }
}

// Load rule overrides
let ruleOverrides = {};

if (configPath) {
  try {
    ruleOverrides = JSON.parse(fs.readFileSync(configPath, "utf8"));
  } catch (err) {
    console.error(`Error reading config: ${err.message}`);
    process.exit(1);
  }
} else {
  // Try config.purus for lint settings
  const result = loadConfig();
  if (result && result.config.lint) {
    ruleOverrides = {};
    const lintConfig = result.config.lint;
    for (const [key, value] of Object.entries(lintConfig)) {
      if (typeof value === "string") {
        ruleOverrides[key] = { severity: value };
      } else if (typeof value === "number") {
        // For numeric values like indent-size, set as the relevant property
        if (key === "indent-size") {
          ruleOverrides[key] = { severity: "warn", size: value };
        } else if (key === "max-line-length") {
          ruleOverrides[key] = { severity: "warn", max: value };
        }
      } else if (typeof value === "object") {
        ruleOverrides[key] = value;
      }
    }
  }

  // Also check for .puruslint.json in cwd
  if (Object.keys(ruleOverrides).length === 0) {
    const defaultConfig = path.join(process.cwd(), ".puruslint.json");
    if (fs.existsSync(defaultConfig)) {
      try {
        ruleOverrides = JSON.parse(fs.readFileSync(defaultConfig, "utf8"));
      } catch {
        // ignore
      }
    }
  }
}

// Determine files to lint
let filesToLint = files;

if (filesToLint.length === 0 && directory) {
  filesToLint = findPurusFiles(path.resolve(directory));
}

if (filesToLint.length === 0) {
  // Try config.purus entry
  const result = loadConfig();
  if (result) {
    const entryDir = path.resolve(result.configDir, result.config.entry || "src");
    if (fs.existsSync(entryDir)) {
      filesToLint = findPurusFiles(entryDir);
    }
  }
}

if (filesToLint.length === 0) {
  console.log("purus-lint - Linter for the Purus language");
  console.log("");
  console.log("Usage:");
  console.log("  purus-lint [file...]                 Lint specific files");
  console.log("  purus-lint --directory <dir>         Lint all files in directory");
  console.log("  purus-lint                           Lint using config.purus");
  process.exit(0);
}

let totalIssues = 0;

for (const file of filesToLint) {
  let source;
  try {
    source = fs.readFileSync(file, "utf8");
  } catch (err) {
    console.error(`Error: ${err.message}`);
    continue;
  }

  const diagnostics = lint(source, ruleOverrides);
  totalIssues += diagnostics.length;

  for (const d of diagnostics) {
    const icon = d.severity === "error" ? "error" : "warn";
    console.log(`${file}:${d.line}:${d.col} ${icon} ${d.message} (${d.rule})`);
  }
}

if (totalIssues > 0) {
  console.log(`\n${totalIssues} issue${totalIssues === 1 ? "" : "s"} found.`);
  process.exit(1);
} else if (filesToLint.length > 0) {
  console.log("No issues found.");
}

function findPurusFiles(dir) {
  const results = [];
  if (!fs.existsSync(dir)) return results;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...findPurusFiles(fullPath));
    } else if (/\.(c|m)?purus$/.test(entry.name) && entry.name !== "config.purus") {
      results.push(fullPath);
    }
  }
  return results;
}
