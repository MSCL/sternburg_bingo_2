# Coding Guidelines & Rules

Always follow these rules when generating or refactoring Dart/Flutter code in this project:

## 0. Dart

- never use `dynamic`, always use `Object?` instead
- if possible use `await` and not `.then` notation

## 1. Closure / Tear-off Simplification

- Always simplify redundant lambda closures like `() => function()` or `(arg) => function(arg)` to
  direct function tear-offs (`function`) whenever possible.

## 2. Expression Function Bodies

- Use expression function body syntax (`=>`) whenever possible instead of block bodies
  `{ return ...; }`.

## 3. Strict & Optimal Class Modifiers

When creating classes or type definitions, always choose the most strict, explicit, and optimal Dart
3 modifier option:

- **`final class`**: Default choice for concrete classes that should not be extended, implemented,
  or mixed in outside this library.
- **`abstract interface class`**: Preferred choice for pure abstract contracts/interfaces meant
  strictly to be implemented (`implements`), preventing direct instantiation or subclassing.
- **`interface class`**: For concrete classes that can be implemented as an interface outside the
  library, but not extended.
- **`base class`**: For classes designed for extension (`extends`) to share implementation, while
  preventing `implements` outside the library.
- **`sealed class`**: For algebraic data types and closed state/event hierarchies, enabling
  exhaustive pattern matching in `switch` statements/expressions.
- **`abstract final class`**: For static utility namespaces, helpers, or constant collections
  (prevents instantiation, extension, and implementation).
- **`mixin class` / `mixin`**: For reusable modular behavior intended to be composed using `with`.
- **`extension type`**: (Dart 3.3+) Preferred choice for zero-cost static wrapping and typed
  wrappers without runtime object allocation overhead.

*Avoid plain `class` declarations whenever a more restrictive or explicit modifier fits the
architecture.*
