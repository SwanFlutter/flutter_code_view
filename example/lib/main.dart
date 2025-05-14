import 'package:flutter/material.dart';
import 'package:flutter_code_view/flutter_code_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code View Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CodeViewDemo(),
    );
  }
}

class CodeViewDemo extends StatefulWidget {
  const CodeViewDemo({super.key});

  @override
  State<CodeViewDemo> createState() => _CodeViewDemoState();
}

class _CodeViewDemoState extends State<CodeViewDemo> {
  ThemeType _currentTheme = ThemeType.monokaiSublime;
  Languages _currentLanguage = Languages.dart;

  final String _sampleCode = '''
void main() {
  // This is a comment
  print('Hello, World!');

  int sum = calculateSum(10, 20);
  print('Sum: \$sum');
}

int calculateSum(int a, int b) {
  return a + b;
}
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Code View Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Code View with Syntax Highlighting',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Theme selection
            Row(
              children: [
                const Text('Theme: '),
                const SizedBox(width: 8),
                DropdownButton<ThemeType>(
                  value: _currentTheme,
                  onChanged: (ThemeType? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _currentTheme = newValue;
                      });
                    }
                  },
                  items:
                      [
                        ThemeType.monokaiSublime,
                        ThemeType.a11yDark,
                        ThemeType.a11yLight,
                        ThemeType.atomOneDark,
                        ThemeType.github,
                        ThemeType.vs,
                        ThemeType.xcode,
                      ].map<DropdownMenuItem<ThemeType>>((ThemeType value) {
                        return DropdownMenuItem<ThemeType>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                ),
              ],
            ),

            // Language selection
            Row(
              children: [
                const Text('Language: '),
                const SizedBox(width: 8),
                DropdownButton<Languages>(
                  value: _currentLanguage,
                  onChanged: (Languages? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _currentLanguage = newValue;
                      });
                    }
                  },
                  items:
                      [
                        Languages.dart,
                        Languages.javascript,
                        Languages.python,
                        Languages.java,
                        Languages.cs,
                        Languages.cpp,
                        Languages.swift,
                      ].map<DropdownMenuItem<Languages>>((Languages value) {
                        return DropdownMenuItem<Languages>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Code view widget
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FlutterCodeView(
                source: _sampleCode,
                language: _currentLanguage,
                themeType: _currentTheme,
                fontSize: 16,
                width: double.infinity,
                borderColor: Colors.transparent,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Syntax highlighting for multiple languages'),
            const Text('• Multiple themes available'),
            const Text('• Selectable text with proper highlighting'),
            const Text('• Customizable appearance'),
            const Text('• Auto-detection of language (optional)'),
          ],
        ),
      ),
    );
  }
}
