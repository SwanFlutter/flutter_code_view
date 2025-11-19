## 0.0.1

*  Describe initial release.

## 0.0.2

*  Fix text selection issue.
*  Add more documentation.
*  Add example app.

## 0.0.4

*  **FIX**: Fixed issue where only line numbers were selectable instead of the actual code.
*  **FIX**: Fixed theme and language not updating when changed dynamically.
*  **IMPROVED**: Line numbers are now non-selectable, only code content can be selected.
*  **IMPROVED**: Added proper lifecycle management with `didUpdateWidget` to handle dynamic changes.

## 0.0.3

*  **BREAKING**: Added proper type definitions for all themes (`Map<String, TextStyle>`).
*  **BREAKING**: Added type definition for `themeMap` (`Map<ThemeType, Map<String, TextStyle>>`).
*  **NEW**: Added `showLineNumbers` parameter to display line numbers alongside code.
*  **NEW**: Added `selectionColor` parameter for custom text selection color.
*  **NEW**: Added `lineNumberStyle` parameter for customizing line number appearance.
*  **IMPROVED**: Enhanced text selection visibility with automatic color calculation based on theme background.
*  **IMPROVED**: Better contrast for selected text on both light and dark themes.
*  **IMPROVED**: Smart selection color that adapts to background luminance.
*  **IMPROVED**: Replaced `SelectableText.rich` with `SelectionArea` + `Text.rich` for better text selection rendering.
*  **FIX**: Fixed text selection not highlighting the text background properly.
*  **FIX**: Fixed text selection color not being visible on dark themes.
*  **FIX**: Replaced deprecated `withOpacity` with `withValues` for better precision.
*  **FIX**: Improved type safety across the entire codebase.