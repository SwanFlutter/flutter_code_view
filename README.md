# Flutter Code View

A Flutter package for displaying and highlighting code snippets with syntax highlighting and customizable themes.

## Features

- **Syntax Highlighting**: Supports syntax highlighting for various programming languages.
- **Customizable Themes**: Choose from a variety of themes to style your code snippets.
- **Auto Detection**: Automatically detect the programming language of the code snippet.
- **Selectable and Copyable**: Users can select and copy the code snippet easily.

## Getting started

To use this package, add `flutter_code_view` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  flutter_code_view: ^0.0.1

```

```yaml
dependencies:
  flutter_code_view:
    git:
      url: https://github.com/yourusername/flutter_code_view.git
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
          child:  FlutterCodeView(
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
    language : Languages.dart
    autoDetection: true,
    height: 300,
    width: size.width * 0.35,
    borderColor: Colors.grey.shade400,
    ),
      ),
    );
  }
}
```

## Contributors

* flutter_highlight (Ongoing maintenance and updates)
* https://pub.dev/packages/flutter_highlight
* Rongjian Zhang(Original creator)


