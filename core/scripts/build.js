/**
 * Build script: copies the MoonBit JS-compiled purus compiler
 * from core/_build/js/debug/build/cmd/main/main.js to lib/purus-compiler.js
 */

const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const src = path.join(
  root,
  "_build",
  "js",
  "debug",
  "build",
  "cmd",
  "main",
  "main.js"
);
const dest = path.join(root, "lib", "purus-compiler.js");

if (!fs.existsSync(src)) {
  console.error(
    "Error: MoonBit JS build not found. Run `moon build --target js` in core/ first."
  );
  process.exit(1);
}

// Ensure lib/ exists
fs.mkdirSync(path.dirname(dest), { recursive: true });

fs.copyFileSync(src, dest);
console.log(`Copied ${src} -> ${dest}`);
