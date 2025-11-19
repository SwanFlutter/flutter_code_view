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
  bool _showLineNumbers = true;

  final Map<Languages, String> _codeSamples = {
    Languages.dart: '''void main() {
  // This is a comment
  print('Hello, World!');

  int sum = calculateSum(10, 20);
  print('Sum: \$sum');
  
  List<String> items = ['Apple', 'Banana', 'Orange'];
  for (var item in items) {
    print(item);
  }
}

int calculateSum(int a, int b) {
  return a + b;
}

class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print('Hi, I am \$name and I am \$age years old.');
  }
}''',
    Languages.javascript: '''function main() {
  // This is a comment
  console.log('Hello, World!');

  const sum = calculateSum(10, 20);
  console.log('Sum: ' + sum);
  
  const items = ['Apple', 'Banana', 'Orange'];
  items.forEach(item => console.log(item));
}

function calculateSum(a, b) {
  return a + b;
}

class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
  
  introduce() {
    console.log(`Hi, I am \${this.name} and I am \${this.age} years old.`);
  }
}''',
    Languages.python: '''def main():
    # This is a comment
    print('Hello, World!')
    
    sum_result = calculate_sum(10, 20)
    print(f'Sum: {sum_result}')
    
    items = ['Apple', 'Banana', 'Orange']
    for item in items:
        print(item)

def calculate_sum(a, b):
    return a + b

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def introduce(self):
        print(f'Hi, I am {self.name} and I am {self.age} years old.')''',
    Languages.java: '''public class Main {
    public static void main(String[] args) {
        // This is a comment
        System.out.println("Hello, World!");
        
        int sum = calculateSum(10, 20);
        System.out.println("Sum: " + sum);
        
        String[] items = {"Apple", "Banana", "Orange"};
        for (String item : items) {
            System.out.println(item);
        }
    }
    
    static int calculateSum(int a, int b) {
        return a + b;
    }
}''',
    Languages.cpp: '''#include <iostream>
#include <vector>
#include <string>
using namespace std;

int calculateSum(int a, int b) {
    return a + b;
}

int main() {
    // This is a comment
    cout << "Hello, World!" << endl;
    
    int sum = calculateSum(10, 20);
    cout << "Sum: " << sum << endl;
    
    vector<string> items = {"Apple", "Banana", "Orange"};
    for (const auto& item : items) {
        cout << item << endl;
    }
    
    return 0;
}''',
    Languages.swift: '''import Foundation

func calculateSum(_ a: Int, _ b: Int) -> Int {
    return a + b
}

class Person {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func introduce() {
        print("Hi, I am \\(name) and I am \\(age) years old.")
    }
}

func main() {
    // This is a comment
    print("Hello, World!")
    
    let sum = calculateSum(10, 20)
    print("Sum: \\(sum)")
    
    let items = ["Apple", "Banana", "Orange"]
    for item in items {
        print(item)
    }
}

main()''',
  };

  @override
  void initState() {
    super.initState();
  }

  String get _sampleCode =>
      _codeSamples[_currentLanguage] ?? _codeSamples[Languages.dart]!;

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
                      _codeSamples.keys
                          .toList()
                          .map<DropdownMenuItem<Languages>>((Languages value) {
                            return DropdownMenuItem<Languages>(
                              value: value,
                              child: Text(value.toString().split('.').last),
                            );
                          })
                          .toList(),
                ),
              ],
            ),

            // Line numbers toggle
            Row(
              children: [
                const Text('Show Line Numbers: '),
                const SizedBox(width: 8),
                Switch(
                  value: _showLineNumbers,
                  onChanged: (bool value) {
                    setState(() {
                      _showLineNumbers = value;
                    });
                  },
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
                fontSize: 14,
                width: double.infinity,
                borderColor: Colors.transparent,
                showLineNumbers: _showLineNumbers,
                selectionColor: Colors.blue.withValues(alpha: 0.3),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Syntax highlighting for multiple languages'),
            const Text('• 90+ built-in themes available'),
            const Text('• Improved text selection with smart color contrast'),
            const Text('• Optional line numbers display'),
            const Text('• Customizable selection colors'),
            const Text('• Customizable appearance and styling'),
            const Text('• Auto-detection of language (optional)'),
            const Text('• Type-safe theme and language definitions'),
          ],
        ),
      ),
    );
  }
}
