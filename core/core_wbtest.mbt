// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

// ============================================================
// Lexer tests
// ============================================================

test "lexer: integer literals" {
  let lexer = Lexer::new("42")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Int(42))
  assert_eq(tokens[2].kind, Eof)
}

test "lexer: float literals" {
  let lexer = Lexer::new("3.14")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Float(3.14))
}

test "lexer: negative integer" {
  let lexer = Lexer::new("-5")
  let tokens = lexer.tokenize()
  // At start of input, - followed by digit is a negative literal
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Int(-5))
}

test "lexer: string" {
  let lexer = Lexer::new("///hello world///")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Str("hello world"))
}

test "lexer: string with escape" {
  let lexer = Lexer::new("///line1\\nline2///")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Str("line1\nline2"))
}

test "lexer: regex" {
  let lexer = Lexer::new("/abc/gi")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Regex("abc", "gi"))
}

test "lexer: keywords" {
  let lexer = Lexer::new("const let var be fn return if else")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Const_)
  assert_eq(tokens[2].kind, Let_)
  assert_eq(tokens[3].kind, Var_)
  assert_eq(tokens[4].kind, Be)
  assert_eq(tokens[5].kind, Fn)
  assert_eq(tokens[6].kind, Return_)
  assert_eq(tokens[7].kind, If_)
  assert_eq(tokens[8].kind, Else_)
}

test "lexer: operators" {
  let lexer = Lexer::new("add sub mul div mod eq ne lt gt le ge and or not neg")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Add)
  assert_eq(tokens[2].kind, Sub)
  assert_eq(tokens[3].kind, Mul)
  assert_eq(tokens[4].kind, Div)
  assert_eq(tokens[5].kind, Mod)
  assert_eq(tokens[6].kind, Eq)
  assert_eq(tokens[7].kind, Ne)
  assert_eq(tokens[8].kind, Lt)
  assert_eq(tokens[9].kind, Gt)
  assert_eq(tokens[10].kind, Le)
  assert_eq(tokens[11].kind, Ge)
  assert_eq(tokens[12].kind, And)
  assert_eq(tokens[13].kind, Or)
  assert_eq(tokens[14].kind, Not)
  assert_eq(tokens[15].kind, Neg)
}

test "lexer: punctuation" {
  let lexer = Lexer::new("[a, b; c]")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, LBracket)
  assert_eq(tokens[2].kind, Ident("a"))
  assert_eq(tokens[3].kind, Comma)
  assert_eq(tokens[4].kind, Ident("b"))
  assert_eq(tokens[5].kind, Semicolon)
  assert_eq(tokens[6].kind, Ident("c"))
  assert_eq(tokens[7].kind, RBracket)
}

test "lexer: dot access" {
  let lexer = Lexer::new("console.log")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Ident("console"))
  assert_eq(tokens[2].kind, Dot)
  assert_eq(tokens[3].kind, Ident("log"))
}

test "lexer: line comment" {
  let lexer = Lexer::new("x -- this is a comment")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Ident("x"))
  assert_eq(tokens[2].kind, Comment(" this is a comment"))
}

test "lexer: block comment" {
  let lexer = Lexer::new("---block comment---")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, BlockComment("block comment"))
}

test "lexer: indentation" {
  let lexer = Lexer::new("a\n  b\n    c\n  d\ne")
  let tokens = lexer.tokenize()
  // Line 1: Indent(0), Ident(a), Newline
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Ident("a"))
  assert_eq(tokens[2].kind, Newline)
  // Line 2: Indent(2), Ident(b), Newline
  assert_eq(tokens[3].kind, Indent(2))
  assert_eq(tokens[4].kind, Ident("b"))
  assert_eq(tokens[5].kind, Newline)
  // Line 3: Indent(4), Ident(c), Newline
  assert_eq(tokens[6].kind, Indent(4))
  assert_eq(tokens[7].kind, Ident("c"))
  assert_eq(tokens[8].kind, Newline)
  // Line 4: Indent(2), Ident(d), Newline
  assert_eq(tokens[9].kind, Indent(2))
  assert_eq(tokens[10].kind, Ident("d"))
  assert_eq(tokens[11].kind, Newline)
  // Line 5: Indent(0), Ident(e)
  assert_eq(tokens[12].kind, Indent(0))
  assert_eq(tokens[13].kind, Ident("e"))
}

test "lexer: var decl" {
  let lexer = Lexer::new("const x be 10")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Const_)
  assert_eq(tokens[2].kind, Ident("x"))
  assert_eq(tokens[3].kind, Be)
  assert_eq(tokens[4].kind, Int(10))
}

test "lexer: true false null nil undefined" {
  let lexer = Lexer::new("true false null nil undefined")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, True_)
  assert_eq(tokens[2].kind, False_)
  assert_eq(tokens[3].kind, Null_)
  assert_eq(tokens[4].kind, Nil_)
  assert_eq(tokens[5].kind, Undefined_)
}

test "lexer: list and object keywords" {
  let lexer = Lexer::new("list object")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, List_)
  assert_eq(tokens[2].kind, Object_)
}

test "lexer: multiline function" {
  let src = "fn greet name\n  console.log[///hello///]"
  let lexer = Lexer::new(src)
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Fn)
  assert_eq(tokens[2].kind, Ident("greet"))
  assert_eq(tokens[3].kind, Ident("name"))
  assert_eq(tokens[4].kind, Newline)
  assert_eq(tokens[5].kind, Indent(2))
  assert_eq(tokens[6].kind, Ident("console"))
  assert_eq(tokens[7].kind, Dot)
  assert_eq(tokens[8].kind, Ident("log"))
  assert_eq(tokens[9].kind, LBracket)
  assert_eq(tokens[10].kind, Str("hello"))
  assert_eq(tokens[11].kind, RBracket)
}

test "lexer: hyphenated ident" {
  let lexer = Lexer::new("my-var")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Ident("my-var"))
}

test "lexer: negative after operator" {
  // After an identifier, `-5` should be parsed as Sub token then Int(5)
  // (not a negative literal)
  let lexer = Lexer::new("x -5")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Ident("x"))
  // After Ident, '-' is not neg literal context, so '-' is skipped as unknown
  // and 5 is a separate number
}

test "lexer: negative after be" {
  let lexer = Lexer::new("const x be -3")
  let tokens = lexer.tokenize()
  assert_eq(tokens[0].kind, Indent(0))
  assert_eq(tokens[1].kind, Const_)
  assert_eq(tokens[2].kind, Ident("x"))
  assert_eq(tokens[3].kind, Be)
  assert_eq(tokens[4].kind, Int(-3))
}

// ============================================================
// Parser tests
// ============================================================

///|
fn tokenize(src : String) -> Array[Token] {
  Lexer::new(src).tokenize()
}

///|
fn parse(src : String) -> Array[Stmt] {
  Parser::new(tokenize(src)).parse()
}

test "parser: const declaration" {
  let stmts = parse("const x be 42")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Const_, name, IntLit(42)) => assert_eq(name, "x")
    _ => fail("expected VarDecl")
  }
}

test "parser: let declaration" {
  let stmts = parse("let y be 3.14")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Let_, name, FloatLit(_)) => assert_eq(name, "y")
    _ => fail("expected VarDecl with Let")
  }
}

test "parser: var declaration with string" {
  let stmts = parse("var msg be ///hello///")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Var_, name, StrLit(s)) => {
      assert_eq(name, "msg")
      assert_eq(s, "hello")
    }
    _ => fail("expected VarDecl with Var")
  }
}

test "parser: assignment" {
  let stmts = parse("x be 10")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    Assign(Ident(name), IntLit(10)) => assert_eq(name, "x")
    _ => fail("expected Assign")
  }
}

test "parser: binary add" {
  let stmts = parse("const r be 1 add 2")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Const_, _, BinOp(Add, IntLit(1), IntLit(2))) => ()
    _ => fail("expected BinOp Add")
  }
}

test "parser: binary precedence mul over add" {
  let stmts = parse("const r be 1 add 2 mul 3")
  assert_eq(stmts.length(), 1)
  // Should parse as: 1 add (2 mul 3)
  match stmts[0] {
    VarDecl(Const_, _, BinOp(Add, IntLit(1), BinOp(Mul, IntLit(2), IntLit(3)))) => ()
    _ => fail("expected Add(1, Mul(2,3))")
  }
}

test "parser: comparison and logic" {
  let stmts = parse("const r be x lt 10 and y gt 5")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Const_, _, BinOp(And, BinOp(Lt, _, IntLit(10)), BinOp(Gt, _, IntLit(5)))) => ()
    _ => fail("expected And(Lt, Gt)")
  }
}

test "parser: unary not" {
  let stmts = parse("const r be not true")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Const_, _, UnaryNot(BoolLit(true))) => ()
    _ => fail("expected UnaryNot")
  }
}

test "parser: unary neg" {
  let stmts = parse("const r be neg x")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    VarDecl(Const_, _, UnaryNeg(Ident(name))) => assert_eq(name, "x")
    _ => fail("expected UnaryNeg")
  }
}

test "parser: dot access" {
  let stmts = parse("console.log")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    ExprStmt(DotAccess(Ident(obj), field)) => {
      assert_eq(obj, "console")
      assert_eq(field, "log")
    }
    _ => fail("expected DotAccess")
  }
}

test "parser: meth call" {
  let stmts = parse("console.log[///hi///]")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    ExprStmt(MethodCall(Ident(obj), meth, args)) => {
      assert_eq(obj, "console")
      assert_eq(meth, "log")
      assert_eq(args.length(), 1)
    }
    _ => fail("expected MethodCall")
  }
}

test "parser: function call" {
  let stmts = parse("greet[///world///]")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    ExprStmt(Call(Ident(name), args)) => {
      assert_eq(name, "greet")
      assert_eq(args.length(), 1)
    }
    _ => fail("expected Call")
  }
}

test "parser: fn declaration with to" {
  let stmts = parse("fn double x to x mul 2")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    FnDecl(decl) => {
      assert_eq(decl.name, Some("double"))
      assert_eq(decl.params.length(), 1)
      assert_eq(decl.params[0], "x")
      match decl.body {
        ToExpr(BinOp(Mul, Ident(_), IntLit(2))) => ()
        _ => fail("expected ToExpr body")
      }
    }
    _ => fail("expected FnDecl")
  }
}

test "parser: fn block declaration" {
  let stmts = parse("fn greet name\n  console.log[name]")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    FnDecl(decl) => {
      assert_eq(decl.name, Some("greet"))
      assert_eq(decl.params.length(), 1)
      match decl.body {
        Block(body) => assert_true(body.length() > 0)
        _ => fail("expected Block body")
      }
    }
    _ => fail("expected FnDecl")
  }
}

test "parser: return statement" {
  let stmts = parse("return 42")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    Return(Some(IntLit(42))) => ()
    _ => fail("expected Return")
  }
}

test "parser: return without value" {
  let stmts = parse("return")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    Return(None) => ()
    _ => fail("expected Return without value")
  }
}

test "parser: break and continue" {
  let stmts = parse("break")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    Break => ()
    _ => fail("expected Break")
  }
}

test "parser: true false null undefined" {
  let stmts = parse("true")
  match stmts[0] {
    ExprStmt(BoolLit(true)) => ()
    _ => fail("expected BoolLit true")
  }
  let stmts2 = parse("null")
  match stmts2[0] {
    ExprStmt(NullLit) => ()
    _ => fail("expected NullLit")
  }
  let stmts3 = parse("undefined")
  match stmts3[0] {
    ExprStmt(UndefinedLit) => ()
    _ => fail("expected UndefinedLit")
  }
}

test "parser: empty array" {
  let stmts = parse("const a be []")
  match stmts[0] {
    VarDecl(Const_, _, ArrayLit(elems)) => assert_eq(elems.length(), 0)
    _ => fail("expected empty ArrayLit")
  }
}

test "parser: array with elements" {
  let stmts = parse("const a be [1, 2, 3]")
  match stmts[0] {
    VarDecl(Const_, _, ArrayLit(elems)) => assert_eq(elems.length(), 3)
    _ => fail("expected ArrayLit with 3 elements")
  }
}

test "parser: empty object" {
  let stmts = parse("const o be [be]")
  match stmts[0] {
    VarDecl(Const_, _, ObjectLit(pairs)) => assert_eq(pairs.length(), 0)
    _ => fail("expected empty ObjectLit")
  }
}

test "parser: object with entries" {
  let stmts = parse("const o be [x be 1, y be 2]")
  match stmts[0] {
    VarDecl(Const_, _, ObjectLit(pairs)) => {
      assert_eq(pairs.length(), 2)
      assert_eq(pairs[0].0, "x")
      assert_eq(pairs[1].0, "y")
    }
    _ => fail("expected ObjectLit")
  }
}

test "parser: list literal" {
  let stmts = parse("const a be list[1, 2]")
  match stmts[0] {
    VarDecl(Const_, _, ArrayLit(elems)) => assert_eq(elems.length(), 2)
    _ => fail("expected list ArrayLit")
  }
}

test "parser: object literal" {
  let stmts = parse("const o be object[name be ///hi///]")
  match stmts[0] {
    VarDecl(Const_, _, ObjectLit(pairs)) => {
      assert_eq(pairs.length(), 1)
      assert_eq(pairs[0].0, "name")
    }
    _ => fail("expected object ObjectLit")
  }
}

test "parser: if-then-else expression" {
  let stmts = parse("const r be if true then 1 else 2")
  match stmts[0] {
    VarDecl(Const_, _, IfExpr(BoolLit(true), IntLit(1), IntLit(2))) => ()
    _ => fail("expected IfExpr")
  }
}

test "parser: pipe" {
  let stmts = parse("const r be x pipe f")
  match stmts[0] {
    VarDecl(Const_, _, Pipe(Ident(x), Ident(f))) => {
      assert_eq(x, "x")
      assert_eq(f, "f")
    }
    _ => fail("expected Pipe")
  }
}

test "parser: while loop" {
  let stmts = parse("while true\n  break")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    While(BoolLit(true), body) => {
      assert_eq(body.length(), 1)
      match body[0] {
        Break => ()
        _ => fail("expected Break in while body")
      }
    }
    _ => fail("expected While")
  }
}

test "parser: for-in loop" {
  let stmts = parse("for x in items\n  console.log[x]")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    ForIn(name, None, Ident(iter), body) => {
      assert_eq(name, "x")
      assert_eq(iter, "items")
      assert_eq(body.length(), 1)
    }
    _ => fail("expected ForIn")
  }
}

test "parser: throw" {
  let stmts = parse("throw ///error///")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    Throw(StrLit(s)) => assert_eq(s, "error")
    _ => fail("expected Throw")
  }
}

test "parser: postfix if" {
  let stmts = parse("console.log[///hi///] if debug")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    PostfixIf(_, Ident(cond)) => assert_eq(cond, "debug")
    _ => fail("expected PostfixIf")
  }
}

test "parser: postfix unless" {
  let stmts = parse("console.log[///hi///] unless quiet")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    PostfixUnless(_, Ident(cond)) => assert_eq(cond, "quiet")
    _ => fail("expected PostfixUnless")
  }
}

test "parser: typeof" {
  let stmts = parse("const t be typeof x")
  match stmts[0] {
    VarDecl(Const_, _, UnaryTypeof(Ident(name))) => assert_eq(name, "x")
    _ => fail("expected UnaryTypeof")
  }
}

test "parser: is check" {
  let stmts = parse("const r be x is string")
  match stmts[0] {
    VarDecl(Const_, _, IsCheck(Ident(name), type_name)) => {
      assert_eq(name, "x")
      assert_eq(type_name, "string")
    }
    _ => fail("expected IsCheck")
  }
}

test "parser: as cast" {
  let stmts = parse("const r be x as number")
  match stmts[0] {
    VarDecl(Const_, _, AsCast(Ident(name), type_name)) => {
      assert_eq(name, "x")
      assert_eq(type_name, "number")
    }
    _ => fail("expected AsCast")
  }
}

test "parser: regex literal" {
  let stmts = parse("const r be /abc/gi")
  match stmts[0] {
    VarDecl(Const_, _, RegexLit(pattern, flags)) => {
      assert_eq(pattern, "abc")
      assert_eq(flags, "gi")
    }
    _ => fail("expected RegexLit")
  }
}

test "parser: delete statement" {
  let stmts = parse("delete x")
  match stmts[0] {
    DeleteStmt(Ident(name)) => assert_eq(name, "x")
    _ => fail("expected DeleteStmt")
  }
}

test "parser: new expression" {
  let stmts = parse("const d be new Date[]")
  match stmts[0] {
    VarDecl(Const_, _, NewExpr(Ident(name), args)) => {
      assert_eq(name, "Date")
      assert_eq(args.length(), 0)
    }
    _ => fail("expected NewExpr")
  }
}

test "parser: this" {
  let stmts = parse("this.x")
  match stmts[0] {
    ExprStmt(DotAccess(ThisExpr, field)) => assert_eq(field, "x")
    _ => fail("expected this.x")
  }
}

test "parser: import default" {
  let stmts = parse("import fs from ///fs///")
  assert_eq(stmts.length(), 1)
  match stmts[0] {
    ImportDecl(EsImport(Some(default_name), None, None, module_name)) => {
      assert_eq(default_name, "fs")
      assert_eq(module_name, "fs")
    }
    _ => fail("expected ImportDecl")
  }
}

test "parser: multiple statements" {
  let stmts = parse("const x be 1\nconst y be 2\nconst z be x add y")
  assert_eq(stmts.length(), 3)
}
