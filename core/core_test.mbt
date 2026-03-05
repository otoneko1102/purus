// Blackbox tests run against the package's public API. Use `@core` to import.
// Prefer high-level behaviors over implementation details.
// Run `moon test` to execute and `moon test --update` to refresh snapshots.

// Integration tests: full source ↁElex ↁEparse pipeline

test "integration: hello world" {
  let src = "console.log[///Hello, World///]"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: variable + arithmetic" {
  let src =
    #|const x be 10
    #|const y be 20
    #|const z be x add y
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 3)
}

test "integration: function definition" {
  let src =
    #|fn add a; b
    #|  return a add b
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: arrow function with to" {
  let src = "fn double x to x mul 2"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: if-elif-else" {
  let src =
    #|if x lt 0
    #|  console.log[///negative///]
    #|elif x eq 0
    #|  console.log[///zero///]
    #|else
    #|  console.log[///positive///]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: while loop" {
  let src =
    #|let i be 0
    #|while i lt 10
    #|  i be i add 1
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 2)
}

test "integration: for-in loop" {
  let src =
    #|for item in items
    #|  console.log[item]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: array and object" {
  let src =
    #|const arr be [1, 2, 3]
    #|const obj be [name be ///alice///, age be 30]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 2)
}

test "integration: pipe" {
  let src = "const result be data pipe filter pipe map"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: try-catch" {
  let src =
    #|try
    #|  risky[]
    #|catch e
    #|  console.log[e]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: postfix if" {
  let src = "console.log[///debug///] if verbose"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: import" {
  let src = "import express from ///express///"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: match" {
  let src =
    #|match x
    #|  when 1 then ///one///
    #|  when 2 then ///two///
    #|  else ///other///
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

// ===== Codegen tests: purus source → JavaScript output =====

fn compile(src : String) -> String {
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  @core.JsCodegen::new().generate(stmts)
}

test "codegen: const declaration" {
  let js = compile("const x be 42")
  assert_eq(js, "const x = 42;\n")
}

test "codegen: let declaration" {
  let js = compile("let name be ///hello///")
  assert_eq(js, "let name = \"hello\";\n")
}

test "codegen: var declaration" {
  let js = compile("var count be 0")
  assert_eq(js, "var count = 0;\n")
}

test "codegen: arithmetic operators" {
  let js = compile("const z be x add y")
  assert_eq(js, "const z = x + y;\n")
}

test "codegen: comparison operators" {
  let js = compile("const r be a lt b")
  assert_eq(js, "const r = a < b;\n")
}

test "codegen: function call" {
  let js = compile("console.log[///Hello, World///]")
  assert_eq(js, "console.log(\"Hello, World\");\n")
}

test "codegen: named function" {
  let src =
    #|fn greet a; b
    #|  return a add b
  let js = compile(src)
  assert_true(js.contains("function greet"))
  assert_true(js.contains("return a + b;"))
}

test "codegen: arrow function with to" {
  let js = compile("fn double x to x mul 2")
  assert_true(js.contains("function double(x) { return x * 2; }"))
}

test "codegen: if-else" {
  let src =
    #|if x gt 0
    #|  console.log[///positive///]
    #|else
    #|  console.log[///negative///]
  let js = compile(src)
  assert_true(js.contains("if (x > 0)"))
  assert_true(js.contains("} else {"))
}

test "codegen: while loop" {
  let src =
    #|while i lt 10
    #|  i be i add 1
  let js = compile(src)
  assert_true(js.contains("while (i < 10)"))
}

test "codegen: for-in loop" {
  let src =
    #|for item in items
    #|  console.log[item]
  let js = compile(src)
  assert_true(js.contains("for (const item of items)"))
}

test "codegen: pipe" {
  let js = compile("const result be data pipe filter")
  assert_eq(js, "const result = filter(data);\n")
}

test "codegen: try-catch" {
  let src =
    #|try
    #|  risky[]
    #|catch e
    #|  console.log[e]
  let js = compile(src)
  assert_true(js.contains("try {"))
  assert_true(js.contains("} catch (e) {"))
}

test "codegen: postfix if" {
  let js = compile("console.log[///debug///] if verbose")
  assert_true(js.contains("if (verbose)"))
  assert_true(js.contains("console.log(\"debug\")"))
}

test "codegen: import default" {
  let js = compile("import express from ///express///")
  assert_eq(js, "import express from \"express\";\n")
}

test "codegen: array literal" {
  let js = compile("const arr be [1, 2, 3]")
  assert_eq(js, "const arr = [1, 2, 3];\n")
}

test "codegen: object literal" {
  let js = compile("const obj be [name be ///alice///, age be 30]")
  assert_true(js.contains("name: \"alice\""))
  assert_true(js.contains("age: 30"))
}

test "codegen: boolean and null" {
  let js = compile("const a be true")
  assert_eq(js, "const a = true;\n")
  let js2 = compile("const b be null")
  assert_eq(js2, "const b = null;\n")
}

test "codegen: return statement" {
  let src =
    #|fn foo
    #|  return 42
  let js = compile(src)
  assert_true(js.contains("return 42;"))
}

test "codegen: hyphenated ident becomes underscore" {
  let js = compile("const my-var be 10")
  assert_eq(js, "const my_var = 10;\n")
}

test "codegen: assignment" {
  let js = compile("x be 42")
  assert_eq(js, "x = 42;\n")
}

test "codegen: unary not" {
  let js = compile("const r be not x")
  assert_eq(js, "const r = !x;\n")
}

test "codegen: unary neg" {
  let js = compile("const r be neg x")
  assert_eq(js, "const r = -x;\n")
}

test "lexer: shebang at start of file" {
  let src = "#!/usr/bin/env node\nconst x be 1"
  let tokens = @core.Lexer::new(src).tokenize()
  match tokens[0].kind {
    @core.Shebang(s) => assert_eq(s, "#!/usr/bin/env node")
    _ => fail("expected Shebang token")
  }
}

test "lexer: no shebang without #!" {
  let src = "const x be 1"
  let tokens = @core.Lexer::new(src).tokenize()
  match tokens[0].kind {
    @core.Shebang(_) => fail("should not have shebang")
    _ => () // ok
  }
}

test "codegen: header comment" {
  let stmts = @core.Parser::new(
    @core.Lexer::new("const x be 1").tokenize(),
  ).parse()
  let js = @core.JsCodegen::new().generate(
    stmts,
    header="// Generated by Purus 0.1.0",
  )
  assert_true(js.has_prefix("// Generated by Purus 0.1.0\n"))
  assert_true(js.contains("const x = 1;"))
}

test "codegen: shebang before header" {
  let stmts = @core.Parser::new(
    @core.Lexer::new("const x be 1").tokenize(),
  ).parse()
  let js = @core.JsCodegen::new().generate(
    stmts,
    header="// Generated by Purus 0.1.0",
    shebang="#!/usr/bin/env node",
  )
  assert_true(js.has_prefix("#!/usr/bin/env node\n// Generated by Purus 0.1.0\n"))
}

test "codegen: no header when empty" {
  let js = compile("const x be 1")
  assert_eq(js, "const x = 1;\n")
}
