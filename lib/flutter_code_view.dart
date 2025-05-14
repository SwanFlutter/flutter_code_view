/// A Flutter package for displaying and highlighting code snippets with syntax highlighting and customizable themes.
///
/// This library provides a widget for rendering code with syntax highlighting,
/// supporting various programming languages and visual themes.
/// It allows for customization of appearance, including colors, fonts, and layout.
library flutter_code_view;

//import 'package:base_cod_view/base_code_view.dart';
import 'package:base_cod_view/base_code_view.dart' show Highlight, Node;
import 'package:base_cod_view/languages/language/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_view/src/theme_map.dart';

export 'package:base_cod_view/base_code_view.dart' show Languages;
export 'package:flutter_code_view/src/theme_map.dart';

/// A widget that displays code with syntax highlighting.
///
/// This widget renders source code with syntax highlighting based on the specified
/// programming language and theme. It supports various customization options
/// for appearance and layout.
///
/// Example usage:
/// ```dart
/// FlutterCodeView(
///   source: 'void main() { print("Hello, world!"); }',
///   language: Languages.dart,
///   themeType: ThemeType.monokaiSublime,
/// )
/// ```
class FlutterCodeView extends StatefulWidget {
  /// The processed source code with tabs replaced by spaces.
  final String input;

  /// Language used for syntax highlighting.
  ///
  /// Specifies the programming language for syntax highlighting.
  /// If null and [autoDetection] is true, the language will be auto-detected.
  final Languages? language;

  /// The theme for syntax highlighting.
  ///
  /// Determines the color scheme used for syntax highlighting.
  /// See [ThemeType] for available themes.
  final ThemeType themeType;

  /// Whether to automatically detect the programming language.
  ///
  /// The default value is false. Pass true to enable language auto detection.
  /// Note that this may cause performance issues because it will try to parse
  /// the source with all registered languages and use the most relevant one.
  final bool autoDetection;

  /// Padding around the code.
  ///
  /// Specifies the padding inside the code view container.
  final EdgeInsetsGeometry? padding;

  /// Text style for code.
  ///
  /// Base text style for the code. Theme-specific styles will be applied on top of this.
  final TextStyle? textStyle;

  /// Width of the code view.
  ///
  /// If null, the code view will size itself to fit its parent's width.
  final double? width;

  /// Height of the code view.
  ///
  /// If null, the code view will size itself to fit its content.
  final double? height;

  /// The color of the border.
  ///
  /// Specifies the color of the outer border of the code view.
  final Color borderColor;

  /// The border radius applied to the element.
  ///
  /// If [borderRadiusCodeView] is non-null and the element is a code view,
  /// [borderRadiusCodeView] will be used instead.
  final BorderRadiusGeometry? borderRadius;

  /// The border radius specifically applied to code views.
  ///
  /// If this is non-null and the element is a code view, this value will
  /// be used for the border radius instead of [borderRadius].
  final BorderRadiusGeometry? borderRadiusCodeView;

  /// The padding applied within the border.
  ///
  /// This padding is added to the content of the element, inside the border.
  final EdgeInsetsGeometry? paddingBorder;

  /// Font size for the code text.
  ///
  /// Specifies the font size to use for the code text.
  final double? fontSize;

  /// Constructor for FlutterCodeView
  ///
  /// Takes the original source input and processes it by replacing
  /// tab characters with spaces (for consistent indentation).
  ///
  /// Parameters:
  ///   * [source] - The source code to display
  ///   * [language] - The programming language for syntax highlighting
  ///   * [themeType] - The theme to use for syntax highlighting
  ///   * [padding] - Padding around the code
  ///   * [textStyle] - Base text style for the code
  ///   * [autoDetection] - Whether to auto-detect the programming language
  ///   * [width] - Width of the code view
  ///   * [height] - Height of the code view
  ///   * [borderColor] - Color of the border
  ///   * [borderRadius] - Border radius of the outer container
  ///   * [borderRadiusCodeView] - Border radius of the code view
  ///   * [paddingBorder] - Padding inside the border
  ///   * [fontSize] - Font size for the code text
  ///   * [tabSize] - Number of spaces to replace each tab character with
  FlutterCodeView({
    super.key,
    required String source,
    this.language = Languages.dart,
    this.themeType = ThemeType.monokaiSublime,
    this.padding = const EdgeInsets.all(8.0),
    this.textStyle,
    this.autoDetection = false,
    this.width,
    this.height,
    this.borderColor = const Color(0xFFF5F5F5),
    this.borderRadius,
    this.borderRadiusCodeView,
    this.paddingBorder,
    this.fontSize = 16,
    int tabSize = 4,
  }) : input = source.replaceAll('\t', ' ' * tabSize);

  @override
  State<FlutterCodeView> createState() => _FlutterCodeViewState();
}

/// State class for FlutterCodeView widget.
class _FlutterCodeViewState extends State<FlutterCodeView> {
  /// Highlight instance used for syntax highlighting.
  Highlight highlight = Highlight();

  @override
  Widget build(BuildContext context) {
    final theme = themeMap[widget.themeType] ?? monokaiSublimeTheme;

    var baseStyle = TextStyle(
      fontSize: widget.fontSize,
      fontFamily: 'monospace',
    ).merge(widget.textStyle);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        color: widget.borderColor,
      ),
      padding: widget.paddingBorder ?? const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadiusCodeView ?? BorderRadius.circular(4),
          color: theme['root']?.backgroundColor ?? Colors.black,
        ),
        padding: widget.padding,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            // Using a semi-transparent selection color to make it more visible
            // while still allowing the code to be readable
            // Alpha 102 is approximately 40% opacity
            selectionColor: Colors.blue.withAlpha(102),
            cursorColor: Colors.pink,
            selectionHandleColor: Colors.blue,
          ),
          child: SelectableText.rich(
            TextSpan(
              style: baseStyle,
              children: _highlightCode(),
            ),
            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              );
            },
            enableInteractiveSelection: true,
          ),
        ),
      ),
    );
  }

  /// Processes the input code and returns a list of TextSpans with syntax highlighting.
  ///
  /// This method parses the input code using the specified language (or auto-detection)
  /// and returns a list of TextSpans with appropriate styling for syntax highlighting.
  List<TextSpan> _highlightCode() {
    final nodes = highlight
            .parse(
              source: widget.input,
              language: widget.language,
              autoDetection: widget.autoDetection,
            )
            .nodes ??
        [];
    return _convertToSpans(nodes);
  }

  /// Converts a list of syntax nodes to a list of TextSpans.
  ///
  /// This method recursively processes the syntax tree and applies the appropriate
  /// styling to each node based on the selected theme.
  ///
  /// Parameters:
  ///   * [nodes] - The list of syntax nodes to convert
  ///
  /// Returns a list of TextSpans with appropriate styling for syntax highlighting.
  List<TextSpan> _convertToSpans(List<Node> nodes) {
    List<TextSpan> spans = [];
    final theme = themeMap[widget.themeType] ?? monokaiSublimeTheme;

    for (var node in nodes) {
      if (node.value != null) {
        spans.add(TextSpan(
          text: node.value,
          style: theme[node.className] ?? theme['root'],
        ));
      } else if (node.children != null) {
        spans.add(TextSpan(
          children: _convertToSpans(node.children!),
          style: theme[node.className],
        ));
      }
    }
    return spans;
  }
}
