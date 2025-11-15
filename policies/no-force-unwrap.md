---
id: ios.swift.no-force-unwrap
version: 2025.01.15
scope: repo
role: pr
title: No Force Unwrapping in Swift
description: Prevent crashes by catching force unwraps in Swift code
owner: ios-team
severity: error
tags: [ios, swift, safety]
channel: stable
---

# No Force Unwrapping Policy

## Purpose
---
Force unwrapping (`!`) in Swift causes **immediate crashes** when the value is `nil`. This policy detects force unwraps in production code and suggests safer alternatives.
---

## Detection
---
This policy flags:
- `variable!` patterns (e.g., `user!.name`)
- `array[index]!` patterns (e.g., `items[0]!`)
- `as!` force casts (e.g., `value as! String`)
- `try!` force try (e.g., `try! decodeJSON()`)

Applies to: `.swift` files in production code (not test files)
---

## Exceptions
---
Force unwrapping is acceptable in:
- Test code (`*Tests.swift`, `*Test.swift`)
- IBOutlets (which are guaranteed to exist after loading)
- Cases with `fatalError()` for truly impossible conditions
---

## Examples
---
❌ BAD - Will crash if user is nil:
```swift
let name = user!.name
```

✅ GOOD - Safe unwrapping:
```swift
if let user = user {
    let name = user.name
}
```

✅ GOOD - Guard statement:
```swift
guard let user = user else { return }
let name = user.name
```

✅ GOOD - Nil coalescing:
```swift
let name = user?.name ?? "Guest"
```
---

