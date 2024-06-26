# Changelog

## [1.3.10] - 2024-04-16

- Syntax highlighting:
  + Fix: Replace all textmate scope `variable.other.livescript` to `''`.

## [1.3.9] - 2024-03-10

- Syntax highlighting:
  + Add: Backcall.
  + Add: Variable names with `$` and `_` signs will be highlighted separately from the name, making it easy to distinguish. Useful for private, temporary variables.

## [1.3.7] - 2023-12-19

- Syntax highlighting:
  + Fix bigint syntax when accessing properties without dots. For example: `4nvalueOf`.

## [1.3.6] - 2023-12-19

- Syntax highlighting:
  + Add: `then` and `=>` syntax after the named function, avoiding confusing variables after `then` with parameters.
  + Fix: In parameters, variables in parentheses will be like regular variables, not parameters.

## [1.3.5] - 2023-12-12

- Syntax highlighting:
  + Added syntax highlighting for escaped characters in regexp.
  + Changed some regexp and heregex syntax highlighting.

## [1.3.4] - 2023-12-07

- Syntax highlighting:
  + Added syntax highlighting for colons in object, escaped characters in heregex.

## [1.3.3] - 2023-11-30

- Fix some syntax highlighting.

## [1.3.2] - 2023-11-28

- Syntax highlighting:
  + Fixed: [Issue #2](https://github.com/tientq64/livescript-vscode/issues/2)

## [1.3.1] - 2023-11-16

- Syntax highlighting:
  + Fix named function parameters.
  + Fix properties with names similar to keywords.

## [1.3.0] - 2023-11-15
- Syntax highlighting:
  + Add syntax highlighting for function parameters. But there is still an error between the brackets and the arrow function.

## [1.2.5] - 2023-10-07

- Syntax highlighting:
  + Add: innerWidth, innerHeight.

## [1.2.4] - 2023-10-01

- Syntax highlighting:
  + Fix: Window methods are highlighted when they are properties of another object.
  + Change: Object property access syntax with a tilde will be highlighted as dot notation.

## [1.2.3] - 2023-09-30

- Syntax highlighting:
  + Add `event`.

## [1.2.2] - 2023-09-28

- Syntax highlighting:
  + Fix: `break`, `continue` are not highlighted when the label name begins with a keyword.

## [1.2.1] - 2023-09-27

- Syntax highlighting:
  + Rewrote syntax highlighting for strings to be more concise, also added highlighting for character escape sequences.
  + Fix: `break`, `continue` with the following keyword highlighted as label.
  + Fix: Remove highlights of objects that do not contain any static methods.
- Added the ability to use variables when writing syntax highlighting. Variable has the syntax &lt;&lt;name&gt;&gt;.

## [1.2.0] - 2023-09-26

- Fix: Wrong folder when publishing.

## [1.1.1] - 2023-09-26

- Syntax highlighting:
  + Add `window`.

## [1.1.0] - 2023-09-25

- Syntax highlighting:
  + Now all-caps variable or property names will be highlighted as constants, capitalized first letters will be highlighted as objects.
  + Add `continue` when used with label.
- Add more autocomplete.

## [1.0.2] - 2023-09-24

- Change my username in the LICENSE.

## [1.0.1] - 2023-09-24

- Add icon for this extension.
- Add `README.md` file.
- Add `.livescript` suffix name in syntax highlighting.

## [1.0.0] - 2023-09-24

- Initial release.
