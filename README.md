# Flutter Code View

A Flutter package for displaying and highlighting code snippets with syntax highlighting and customizable themes.

## Features

- **Syntax Highlighting**: Supports syntax highlighting for various programming languages.
- **Customizable Themes**: Choose from 90+ built-in themes to style your code snippets.
- **Auto Detection**: Automatically detect the programming language of the code snippet.
- **Selectable and Copyable**: Users can select and copy the code snippet easily with improved selection visibility.
- **Line Numbers**: Optional line numbers display for better code readability.
- **Smart Selection Colors**: Automatic selection color adjustment based on theme background for optimal contrast.
- **Type-Safe**: Full type safety with proper TypeScript-like type definitions.

## Getting started

To use this package, add `flutter_code_view` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  flutter_code_view: ^0.0.4

```

```yaml
dependencies:
  flutter_code_view:
    git:
      url: https://github.com/SwanFlutter/flutter_code_view.git
```

## Usage

 - import the package in your Dart code:

```dart

import 'package:flutter_code_view/flutter_code_view.dart';

```

- Here is a simple example of how to use FlutterCodeView in your Flutter app:

![Screenshot 2024-11-23 223843](https://github.com/user-attachments/assets/3a556117-9708-4fd3-b770-f47f88a36489)


```dart
import 'package:flutter/material.dart';
import 'package:flutter_code_view/flutter_code_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Code View Example'),
        ),
        body: Center(
          child: FlutterCodeView(
            source: '''
List<AssetEntity> selectedAssetList = [];

ElevatedButton(
  onPressed: () {
    var picker = const CustomPicker(
      maxCount: 5,
      requestType: MyRequestType.image,
    ).instagram(context);
    picker.then((value) {
      selectedAssetList = value;
      convertToFileList();
    });
  },
  child: const Text("CustomPickers"),
),
''',
            themeType: ThemeType.dark,
            language: Languages.dart,
            autoDetection: true,
            height: 300,
            width: MediaQuery.of(context).size.width * 0.35,
            borderColor: Colors.grey.shade400,
            // New features
            showLineNumbers: true,
            selectionColor: Colors.blue.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
```

### Advanced Usage

```dart
FlutterCodeView(
  source: yourCodeString,
  language: Languages.dart,
  themeType: ThemeType.dracula,
  
  // Display options
  showLineNumbers: true,
  fontSize: 14,
  
  // Selection customization
  selectionColor: Colors.amber.withValues(alpha: 0.3),
  
  // Layout customization
  width: 600,
  height: 400,
  padding: EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(12),
  borderColor: Colors.grey.shade300,
  
  // Line number styling
  lineNumberStyle: TextStyle(
    color: Colors.grey,
    fontSize: 12,
  ),
)
```

## Available Themes

The package includes 90+ themes including:
- `monokaiSublime` (default)
- `dracula`
- `github`
- `atomOneDark`
- `vs2015`
- `nightOwl`
- `nord`
- `solarizedDark`
- `solarizedLight`
- And many more...

See `ThemeType` enum for the complete list.

## API Reference

### FlutterCodeView Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `source` | `String` | required | The source code to display |
| `language` | `Languages?` | `Languages.dart` | Programming language for syntax highlighting. Set to `null` with `autoDetection: true` for auto-detection |
| `themeType` | `ThemeType` | `ThemeType.monokaiSublime` | Color theme for syntax highlighting |
| `autoDetection` | `bool` | `false` | Enable automatic language detection |
| `showLineNumbers` | `bool` | `false` | Display line numbers on the left side |
| `selectionColor` | `Color?` | `null` | Custom color for text selection (auto-calculated if null) |
| `fontSize` | `double?` | `16` | Font size for the code text |
| `textStyle` | `TextStyle?` | `null` | Base text style (merged with theme styles) |
| `lineNumberStyle` | `TextStyle?` | `null` | Custom style for line numbers |
| `width` | `double?` | `null` | Width of the code view container |
| `height` | `double?` | `null` | Height of the code view container |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(8.0)` | Padding around the code |
| `borderColor` | `Color` | `Color(0xFFF5F5F5)` | Color of the outer border |
| `borderRadius` | `BorderRadiusGeometry?` | `null` | Border radius of outer container |
| `borderRadiusCodeView` | `BorderRadiusGeometry?` | `null` | Border radius of code view |
| `paddingBorder` | `EdgeInsetsGeometry?` | `null` | Padding inside the border |
| `tabSize` | `int` | `4` | Number of spaces to replace tab characters |

## Features in Detail

### Smart Text Selection
The widget automatically calculates the best selection color based on the theme's background luminance, ensuring optimal contrast and readability on both light and dark themes.

### Line Numbers
When `showLineNumbers: true`, line numbers are displayed with automatic width calculation based on the total number of lines. The line numbers are styled to match the theme with reduced opacity.

### Type Safety
All themes and language definitions are fully typed with proper TypeScript-like type definitions, providing excellent IDE support and compile-time safety.

## Contributors

* flutter_highlight (Ongoing maintenance and updates)
* https://pub.dev/packages/flutter_highlight
* Rongjian Zhang(Original creator)


