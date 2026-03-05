#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const { lint, defaultRules } = require("./index.js");

const args = process.argv.slice(2);

if (args.length === 0 || args.includes("--help") || args.includes("-h")) {
  console.log("purus-lint - Linter for the Purus language");
  console.log("");
  console.log("Usage: purus-lint <file.purus|.cpurus|.mpurus> [options]");
  console.log("");
  console.log("Options:");
  console.log("  --config <file>  Path to config JSON file");
  console.log("  --fix            (not yet implemented)");
  console.log("  --help           Show this help");
  process.exit(0);
}

// Collect files and options
let configPath = null;
const files = [];

for (let i = 0; i < args.length; i++) {
  if (args[i] === "--config" && i + 1 < args.length) {
    configPath = args[++i];
  } else if (!args[i].startsWith("-")) {
    files.push(args[i]);
  }
}

// Load config
let ruleOverrides = {};
if (configPath) {
  try {
    ruleOverrides = JSON.parse(fs.readFileSync(configPath, "utf8"));
  } catch (err) {
    console.error(`Error reading config: ${err.message}`);
    process.exit(1);
  }
}

// Also check for .puruslint.json in cwd
if (!configPath) {
  const defaultConfig = path.join(process.cwd(), ".puruslint.json");
  if (fs.existsSync(defaultConfig)) {
    try {
      ruleOverrides = JSON.parse(fs.readFileSync(defaultConfig, "utf8"));
    } catch {
      // ignore
    }
  }
}

let totalIssues = 0;

for (const file of files) {
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
} else if (files.length > 0) {
  console.log("No issues found.");
}
