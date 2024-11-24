library flutter_code_view;

import 'package:base_cod_view/base_code_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_view/src/theme_map.dart';

export 'package:flutter_code_view/src/theme_map.dart';

class FlutterCodeView extends StatefulWidget {
  /// The processed source code with tabs replaced by spaces.
  final String input;

  /// Language used for syntax highlighting.
  final Languages? language;

  /// The theme for syntax highlighting.
  final ThemeType themeType;

  /// autoDetect: The default value is false. Pass true to enable language auto detection.
  /// Notice that this may cause performance issue because it will try to parse source with all
  /// registered languages and use the most relevant one
  final bool autoDetection;

  /// Padding around the code.
  final EdgeInsetsGeometry? padding;

  /// Text style for code.
  final TextStyle? textStyle;

  /// Width of the code view.
  final double? width;

  /// Height of the code view.
  final double? height;

  /// The color of the border.
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

  /// fontSize source
  final double? fontSize;

  /// Constructor for FlutterCodeView
  ///
  /// Takes the original source input and processes it by replacing
  /// tab characters with spaces (for consistent indentation).
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

class _FlutterCodeViewState extends State<FlutterCodeView> {
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
          data: const TextSelectionThemeData(
            selectionColor: Colors.blueAccent,
            cursorColor: Colors.pink,
            selectionHandleColor: Colors.grey,
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
            //enableInteractiveSelection: true,
          ),
        ),
      ),
    );
  }

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
