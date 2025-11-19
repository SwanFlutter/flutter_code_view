import 'package:flutter/material.dart';
import 'package:flutter_code_view/flutter_code_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterCodeView', () {
    testWidgets('renders with basic configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterCodeView(
              source: 'void main() { print("Hello"); }',
              language: Languages.dart,
              themeType: ThemeType.monokaiSublime,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterCodeView), findsOneWidget);
    });

    testWidgets('renders with line numbers', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterCodeView(
              source: 'line 1\nline 2\nline 3',
              language: Languages.dart,
              themeType: ThemeType.github,
              showLineNumbers: true,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterCodeView), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders with null language (auto-detection)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterCodeView(
              source: 'const x = 10;',
              language: null,
              autoDetection: true,
              themeType: ThemeType.dracula,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterCodeView), findsOneWidget);
    });

    testWidgets('renders with custom selection color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterCodeView(
              source: 'print("test");',
              language: Languages.dart,
              themeType: ThemeType.atomOneDark,
              selectionColor: Colors.amber.withValues(alpha: 0.3),
            ),
          ),
        ),
      );

      expect(find.byType(FlutterCodeView), findsOneWidget);
    });

    test('ThemeType enum has correct values', () {
      expect(ThemeType.values.length, greaterThan(80));
      expect(ThemeType.values.contains(ThemeType.monokaiSublime), true);
      expect(ThemeType.values.contains(ThemeType.dracula), true);
      expect(ThemeType.values.contains(ThemeType.github), true);
    });

    test('themeMap contains all ThemeType values', () {
      for (final themeType in ThemeType.values) {
        expect(themeMap.containsKey(themeType), true,
            reason: 'themeMap should contain $themeType');
      }
    });
  });
}
