"use strict";

const fs = require("fs");
const path = require("path");
const { loadConfig } = require("./config.js");
const { compile } = require("./purus-core.js");

const args = process.argv.slice(3);

let file = null;
let directory = null;
let output = null;
let noHeader = false;
let toStdout = false;

for (let i = 0; i < args.length; i++) {
  if (args[i] === "--no-header") {
    noHeader = true;
  } else if (args[i] === "--stdout") {
    toStdout = true;
  } else if (args[i] === "--directory" || args[i] === "-d") {
    directory = args[++i];
  } else if (args[i] === "--output" || args[i] === "-o") {
    output = args[++i];
  } else if (!args[i].startsWith("-")) {
    file = args[i];
  }
}

if (file) {
  // Single file - delegate to MoonBit compiler
  require("./purus-compiler.js");
} else {
  let entryDir;
  let outputDir;
  let useHeader;

  if (directory) {
    entryDir = path.resolve(directory);
    outputDir = output ? path.resolve(output) : path.resolve("dist");
    useHeader = !noHeader;

    const result = loadConfig();
    if (result) {
      if (!output) {
        outputDir = path.resolve(
          result.configDir,
          result.config.output || "dist"
        );
      }
      useHeader = result.config.header !== false && !noHeader;
    }
  } else {
    const result = loadConfig();
    if (!result) {
      console.log("Error: no input file specified and no config.purus found");
      console.log("");
      console.log("Usage:");
      console.log("  purus build <file>              Compile a single file");
      console.log(
        "  purus build --directory <dir>   Compile all files in directory"
      );
      console.log(
        "  purus build                     Compile using config.purus"
      );
      process.exit(1);
    }

    const { config, configDir } = result;
    entryDir = path.resolve(configDir, config.entry || "src");
    outputDir = output
      ? path.resolve(output)
      : path.resolve(configDir, config.output || "dist");
    useHeader = config.header !== false && !noHeader;
  }

  if (!fs.existsSync(entryDir)) {
    console.log(`Error: entry directory '${entryDir}' not found`);
    process.exit(1);
  }

  const stat = fs.statSync(entryDir);
  let files;

  if (stat.isFile()) {
    files = [entryDir];
    // For single file entry, output is a file too
    if (!fs.existsSync(path.dirname(outputDir))) {
      fs.mkdirSync(path.dirname(outputDir), { recursive: true });
    }
  } else {
    files = findPurusFiles(entryDir);
  }

  if (files.length === 0) {
    console.log(`No .purus files found in ${entryDir}`);
    process.exit(0);
  }

  let count = 0;
  for (const f of files) {
    const source = fs.readFileSync(f, "utf8");
    const js = compile(source, { header: useHeader });
    let outputPath;

    if (stat.isFile()) {
      outputPath = outputDir;
    } else {
      outputPath = getOutputPath(f, entryDir, outputDir);
    }

    fs.mkdirSync(path.dirname(outputPath), { recursive: true });
    fs.writeFileSync(outputPath, js);
    console.log(
      `Compiled ${path.relative(process.cwd(), f)} -> ${path.relative(process.cwd(), outputPath)}`
    );
    count++;
  }
  console.log(`\n${count} file${count === 1 ? "" : "s"} compiled.`);
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

function getOutputPath(inputFile, inputBase, outputBase) {
  const relative = path.relative(inputBase, inputFile);
  let ext = ".js";
  if (inputFile.endsWith(".cpurus")) ext = ".cjs";
  else if (inputFile.endsWith(".mpurus")) ext = ".mjs";
  const base = relative.replace(/\.(c|m)?purus$/, "");
  return path.join(outputBase, base + ext);
}
