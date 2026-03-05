"use strict";

const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");
const { loadConfig } = require("./config.js");
const { compile } = require("./purus-core.js");

const args = process.argv.slice(3);

let file = null;
let directory = null;
let noHeader = false;

for (let i = 0; i < args.length; i++) {
  if (args[i] === "--no-header") {
    noHeader = true;
  } else if (args[i] === "--directory" || args[i] === "-d") {
    directory = args[++i];
  } else if (!args[i].startsWith("-")) {
    file = args[i];
  }
}

if (file) {
  // Single file - compile and run
  const source = fs.readFileSync(file, "utf8");
  const js = compile(source, { header: false });
  const m = new (require("module"))();
  m._compile(js, file);
} else {
  let entryDir;
  let useHeader;

  if (directory) {
    entryDir = path.resolve(directory);
    useHeader = false;
  } else {
    const result = loadConfig();
    if (!result) {
      console.log("Error: no input file specified and no config.purus found");
      console.log("");
      console.log("Usage:");
      console.log("  purus run <file>              Run a single file");
      console.log(
        "  purus run --directory <dir>   Run all files in directory"
      );
      console.log("  purus run                     Run using config.purus");
      process.exit(1);
    }

    const { config, configDir } = result;
    entryDir = path.resolve(configDir, config.entry || "src");
    useHeader = false;
  }

  if (!fs.existsSync(entryDir)) {
    console.log(`Error: entry directory '${entryDir}' not found`);
    process.exit(1);
  }

  const stat = fs.statSync(entryDir);
  let files;

  if (stat.isFile()) {
    files = [entryDir];
  } else {
    files = findPurusFiles(entryDir);
  }

  if (files.length === 0) {
    console.log(`No .purus files found in ${entryDir}`);
    process.exit(0);
  }

  for (const f of files) {
    const source = fs.readFileSync(f, "utf8");
    const js = compile(source, { header: false });

    const tmpFile = path.join(
      require("os").tmpdir(),
      `purus_run_${Date.now()}_${Math.random().toString(36).slice(2)}.js`
    );
    try {
      fs.writeFileSync(tmpFile, js, "utf8");
      execFileSync(process.execPath, [tmpFile], {
        stdio: "inherit",
        cwd: path.dirname(f),
      });
    } finally {
      try {
        fs.unlinkSync(tmpFile);
      } catch {
        // ignore cleanup errors
      }
    }
  }
}

function findPurusFiles(dir) {
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...findPurusFiles(fullPath));
    } else if (/\.(c|m)?purus$/.test(entry.name)) {
      results.push(fullPath);
    }
  }
  return results;
}
