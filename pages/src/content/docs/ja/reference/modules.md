---
title: モジュール
description: Purusのインポート、エクスポート、モジュールシステム。
---

## ESMインポート

```
import express from ///express///
import [useState, useEffect] from ///react///
import React, [Component] from ///react///
import all as fs from ///fs///
```

## Use（ドットパスインポート）

```
use std.math
from std.math use sin, cos
```

```js
import * as math from "std/math";
import { sin, cos } from "std/math";
```

## エクスポート

```
pub fn helper to 42
pub const VERSION be ///1.0///
export default fn main
  console.log[///hi///]
```

## モジュール名前空間（mod）

```
mod utils
  fn helper to 42
```

```js
const utils = (() => {
  function helper() { return 42; }
})();
```

## CommonJS

```
const fs be require[///fs///]
```

```js
const fs = require("fs");
```
