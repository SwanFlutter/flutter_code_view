/// A Flutter package for displaying and highlighting code snippets with syntax highlighting and customizable themes.
///
/// This library provides a widget for rendering code with syntax highlighting,
/// supporting various programming languages and visual themes.
/// It allows for customization of appearance, including colors, fonts, and layout.
// ignore_for_file: unreachable_switch_default

library;

import 'package:base_cod_view/base_code_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_view/src/theme_map.dart';

export 'package:base_cod_view/base_code_view.dart';
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

  /// Custom selection color for selected text.
  ///
  /// If null, a default semi-transparent blue color will be used.
  final Color? selectionColor;

  /// Whether to show line numbers.
  ///
  /// If true, line numbers will be displayed on the left side of the code.
  final bool showLineNumbers;

  /// Text style for line numbers.
  ///
  /// If null, a default style based on the theme will be used.
  final TextStyle? lineNumberStyle;

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
    this.selectionColor,
    this.showLineNumbers = false,
    this.lineNumberStyle,
    int tabSize = 4,
  }) : input = source.replaceAll('\t', ' ' * tabSize);

  @override
  State<FlutterCodeView> createState() => _FlutterCodeViewState();
}

class _FlutterCodeViewState extends State<FlutterCodeView> {
  @override
  Widget build(BuildContext context) {
    final theme = themeMap[widget.themeType] ?? monokaiSublimeTheme;
    final backgroundColor = theme['root']?.backgroundColor ?? Colors.black;
    final textColor = theme['root']?.color ?? Colors.white;

    var baseStyle = TextStyle(
      fontSize: widget.fontSize,
      fontFamily: 'monospace',
      color: textColor,
      height: 1.5,
    ).merge(widget.textStyle);

    final defaultSelectionColor = _calculateSelectionColor(backgroundColor);
    final effectiveSelectionColor =
        widget.selectionColor ?? defaultSelectionColor;

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
          color: backgroundColor,
        ),
        padding: widget.padding,
        child: widget.showLineNumbers
            ? _buildCodeWithLineNumbers(
                baseStyle, effectiveSelectionColor, textColor)
            : _buildCodeWithoutLineNumbers(baseStyle, effectiveSelectionColor),
      ),
    );
  }

  Color _calculateSelectionColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    if (luminance > 0.5) {
      return Colors.blue.withValues(alpha: 0.3);
    } else {
      return Colors.lightBlue.withValues(alpha: 0.4);
    }
  }

  Widget _buildCodeWithoutLineNumbers(
      TextStyle baseStyle, Color selectionColor) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: selectionColor,
      ),
      child: SelectableText.rich(
        _highlightCode(baseStyle),
        style: baseStyle,
      ),
    );
  }

  Widget _buildCodeWithLineNumbers(
      TextStyle baseStyle, Color selectionColor, Color textColor) {
    final lines = widget.input.split('\n');
    final lineNumberWidth = (lines.length.toString().length * 10.0) + 16.0;

    final effectiveLineNumberStyle = widget.lineNumberStyle ??
        TextStyle(
          fontSize: widget.fontSize,
          fontFamily: 'monospace',
          color: textColor.withValues(alpha: 0.5),
          height: 1.5,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: lineNumberWidth,
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              lines.length,
              (index) => Text(
                '${index + 1}',
                style: effectiveLineNumberStyle,
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          color: textColor.withValues(alpha: 0.2),
          margin: const EdgeInsets.only(right: 8.0),
        ),
        Expanded(
          child: TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionColor: selectionColor,
            ),
            child: SelectableText.rich(
              _highlightCode(baseStyle),
              style: baseStyle,
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _highlightCode(TextStyle baseStyle) {
    final highlight = Highlight();

    // ثبت زبان انتخاب شده
    final language = widget.language ?? Languages.dart;
    _registerLanguage(highlight, language);

    final result = highlight.parse(
      source: widget.input,
      language: language,
      autoDetection: widget.autoDetection,
    );

    // استفاده از toTextSpan از base_cod_view
    return result.toTextSpan(baseStyle: baseStyle);
  }

  void _registerLanguage(Highlight highlight, Languages language) {
    // تمام زبان‌های پشتیبانی‌شده را ثبت کنید
    try {
      switch (language) {
        case Languages.c1:
        case Languages.abnf:
        case Languages.accesslog:
        case Languages.actionscript:
        case Languages.ada:
        case Languages.angelscript:
        case Languages.apache:
        case Languages.applescript:
        case Languages.arcade:
        case Languages.arduino:
        case Languages.armasm:
        case Languages.asciidoc:
        case Languages.aspectj:
        case Languages.autohotkey:
        case Languages.autoit:
        case Languages.avrasm:
        case Languages.awk:
        case Languages.axapta:
        case Languages.bash:
        case Languages.basic:
        case Languages.bnf:
        case Languages.brainfuck:
        case Languages.cal:
        case Languages.capnproto:
        case Languages.ceylon:
        case Languages.clean:
        case Languages.clojureRepl:
        case Languages.clojure:
        case Languages.cmake:
        case Languages.coffeescript:
        case Languages.coq:
        case Languages.cos:
        case Languages.cpp:
        case Languages.crmsh:
        case Languages.crystal:
        case Languages.cs:
        case Languages.csp:
        case Languages.css:
        case Languages.d:
        case Languages.dart:
          highlight.registerLanguage(language, dart);
          break;
        case Languages.delphi:
        case Languages.diff:
        case Languages.django:
        case Languages.dns:
        case Languages.dockerfile:
        case Languages.dos:
        case Languages.dsconfig:
        case Languages.dts:
        case Languages.dust:
        case Languages.ebnf:
        case Languages.elixir:
        case Languages.elm:
        case Languages.erb:
        case Languages.erlangRepl:
        case Languages.erlang:
        case Languages.excel:
        case Languages.fix:
        case Languages.flix:
        case Languages.fortran:
        case Languages.fsharp:
        case Languages.gams:
        case Languages.gauss:
        case Languages.gcode:
        case Languages.gherkin:
        case Languages.glsl:
        case Languages.gml:
        case Languages.gn:
        case Languages.go:
          highlight.registerLanguage(language, go);
          break;
        case Languages.golo:
        case Languages.gradle:
        case Languages.graphql:
        case Languages.groovy:
        case Languages.haml:
        case Languages.handlebars:
        case Languages.haskell:
        case Languages.haxe:
        case Languages.hsp:
        case Languages.htmlbars:
        case Languages.http:
        case Languages.hy:
        case Languages.inform7:
        case Languages.ini:
        case Languages.irpf90:
        case Languages.isbl:
        case Languages.java:
          highlight.registerLanguage(language, java);
          break;
        case Languages.javascript:
          highlight.registerLanguage(language, javascript);
          break;
        case Languages.jbossCli:
        case Languages.json:
        case Languages.juliaRepl:
        case Languages.julia:
        case Languages.kotlin:
          highlight.registerLanguage(language, kotlin);
          break;
        case Languages.lasso:
        case Languages.ldif:
        case Languages.leaf:
        case Languages.less:
        case Languages.lisp:
        case Languages.livecodeserver:
        case Languages.livescript:
        case Languages.llvm:
        case Languages.lsl:
        case Languages.lua:
        case Languages.makefile:
        case Languages.markdown:
        case Languages.mathematica:
        case Languages.matlab:
        case Languages.maxima:
        case Languages.mel:
        case Languages.mercury:
        case Languages.mipsasm:
        case Languages.mizar:
        case Languages.mojolicious:
        case Languages.monkey:
        case Languages.moonscript:
        case Languages.n1ql:
        case Languages.nginx:
        case Languages.nimrod:
        case Languages.nix:
        case Languages.nsis:
        case Languages.objectivec:
        case Languages.ocaml:
        case Languages.openscad:
        case Languages.oxygene:
        case Languages.parser3:
        case Languages.perl:
          highlight.registerLanguage(language, perl);
          break;
        case Languages.pf:
        case Languages.pgsql:
        case Languages.php:
          highlight.registerLanguage(language, php);
          break;
        case Languages.plaintext:
        case Languages.pony:
        case Languages.powershell:
          highlight.registerLanguage(language, powershell);
          break;
        case Languages.processing:
        case Languages.profile:
        case Languages.prolog:
        case Languages.properties:
        case Languages.protobuf:
        case Languages.puppet:
        case Languages.purebasic:
        case Languages.python:
          highlight.registerLanguage(language, python);
          break;
        case Languages.q:
        case Languages.qml:
        case Languages.r:
        case Languages.reasonml:
        case Languages.rib:
        case Languages.roboconf:
        case Languages.routeros:
        case Languages.rsl:
        case Languages.ruby:
          highlight.registerLanguage(language, ruby);
          break;
        case Languages.ruleslanguage:
        case Languages.rust:
          highlight.registerLanguage(language, rust);
          break;
        case Languages.sas:
        case Languages.scala:
        case Languages.scheme:
        case Languages.scilab:
        case Languages.scss:
        case Languages.shell:
          highlight.registerLanguage(language, shell);
          break;
        case Languages.smali:
        case Languages.smalltalk:
        case Languages.sml:
        case Languages.solidity:
        case Languages.sqf:
        case Languages.sql:
          highlight.registerLanguage(language, sql);
          break;
        case Languages.stan:
        case Languages.stata:
        case Languages.step21:
        case Languages.stylus:
        case Languages.subunit:
        case Languages.swift:
          highlight.registerLanguage(language, swift);
          break;
        case Languages.taggerscript:
        case Languages.tap:
        case Languages.tcl:
        case Languages.tex:
        case Languages.thrift:
        case Languages.tp:
        case Languages.twig:
        case Languages.typescript:
          highlight.registerLanguage(language, typescript);
          break;
        case Languages.vala:
        case Languages.vbnet:
        case Languages.vbscriptHtml:
        case Languages.vbscript:
        case Languages.verilog:
        case Languages.vhdl:
        case Languages.vim:
        case Languages.vue:
        case Languages.x86asm:
        case Languages.xl:
        case Languages.xml:
        case Languages.xquery:
        case Languages.yaml:
        case Languages.zephir:
        case Languages.all:
          // برای زبان‌های مختلف یا گزینه 'all'
          highlight.registerLanguage(Languages.dart, dart);
          break;
      }
    } catch (e) {
      // اگر زبانی ثبت نشود، به صورت پیش‌فرض Dart استفاده شود
      highlight.registerLanguage(Languages.dart, dart);
    }
  }
}
