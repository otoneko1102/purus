#!/usr/bin/env node
"use strict";

const VERSION = require("../package.json").version;
const cmd = process.argv[2];

function printHelp() {
  console.log(`purus v${VERSION} - A language that compiles to JavaScript`);
  console.log("");
  console.log("Usage:");
  console.log("  purus build [file]                  Compile to JavaScript");
  console.log("  purus build --directory <dir>        Compile all files in directory");
  console.log("  purus build --output <dir>           Specify output directory");
  console.log("  purus build                          Compile using config.purus");
  console.log("    .purus  -> .js");
  console.log("    .cpurus -> .cjs (CommonJS)");
  console.log("    .mpurus -> .mjs (ES Module)");
  console.log("  purus build --no-header [file]       Compile without header comment");
  console.log("  purus run [file]                     Run without generating files");
  console.log("  purus run --directory <dir>           Run all files in directory");
  console.log("  purus run                            Run using config.purus");
  console.log("  purus check <file>                   Syntax check only");
  console.log("  purus new [name] [-y]                Create a new project");
  console.log("  purus init                           Initialize project in current directory");
  console.log("  purus version                        Show version");
  console.log("  purus help                           Show this help");
  console.log("");
  console.log("Aliases: compile = build, create = new");
}

switch (cmd) {
  case "new":
  case "create":
    require("../lib/create.js");
    break;
  case "build":
  case "compile":
    require("../lib/build-wrapper.js");
    break;
  case "run":
    require("../lib/run-wrapper.js");
    break;
  case "help":
  case "--help":
  case "-h":
  case undefined:
    printHelp();
    break;
  default:
    require("../lib/purus-compiler.js");
    break;
}
