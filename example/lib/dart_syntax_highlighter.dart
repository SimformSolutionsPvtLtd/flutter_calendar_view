import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:string_scanner/string_scanner.dart';

const List<String> _keywords = <String>[
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'factory',
  'external',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'get',
  'if',
  'implements',
  'import',
  'in',
  'is',
  'library',
  'new',
  'null',
  'operator',
  'part',
  'rethrow',
  'return',
  'set',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'while',
  'with',
  'yield',
];

const List<String> _builtInTypes = <String>[
  'int',
  'double',
  'num',
  'bool',
];

enum _HighlightType {
  number,
  comment,
  keyword,
  string,
  punctuation,
  klass,
  constant
}

class DartSyntaxHighlighter extends SyntaxHighlighter {
  HighlighterStyle style;

  DartSyntaxHighlighter({
    required this.style,
  });

  // This code taken from: https://github.com/viztushar/syntax_highlighter with
  // minor changes
  @override
  TextSpan format(String source) {
    final scanner = StringScanner(source);

    final spans = _generateSpans(scanner);

    if (spans.isNotEmpty) {
      // Successfully parsed the code
      final formattedText = <TextSpan>[];
      var currentPosition = 0;

      for (final span in spans) {
        if (currentPosition != span.start)
          formattedText.add(
              TextSpan(text: source.substring(currentPosition, span.start)));

        formattedText.add(TextSpan(
            style: span.textStyle(style), text: span.textForSpan(source)));

        currentPosition = span.end;
      }

      if (currentPosition != source.length)
        formattedText.add(
            TextSpan(text: source.substring(currentPosition, source.length)));

      return TextSpan(style: style.style, children: formattedText);
    } else {
      return TextSpan(style: style.style, text: source);
    }
  }

  List<_HighlightedSpan> _generateSpans(StringScanner scanner) {
    final spans = <_HighlightedSpan>[];

    var lastLoopPosition = scanner.position;

    while (!scanner.isDone) {
      // Skip White space
      scanner.scan(RegExp(r'\s+'));

      // Block comments
      if (scanner.scan(RegExp(r'/\*(.|\n)*\*/'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.comment,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Line comments
      if (scanner.scan('//')) {
        final startComment = scanner.lastMatch?.start ?? 0;

        var eof = false;
        int endComment;
        if (scanner.scan(RegExp(r'.*\n'))) {
          endComment = (scanner.lastMatch?.end ?? 0) - 1;
        } else {
          eof = true;
          endComment = scanner.string.length;
        }

        spans.add(_HighlightedSpan(
          _HighlightType.comment,
          startComment,
          endComment,
        ));

        if (eof) break;

        continue;
      }

      // Raw r"String"
      if (scanner.scan(RegExp(r'r".*"'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.string,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Raw r'String'
      if (scanner.scan(RegExp(r"r'.*'"))) {
        spans.add(_HighlightedSpan(
          _HighlightType.string,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Multiline """String"""
      if (scanner.scan(RegExp(r'"""(?:[^"\\]|\\(.|\n))*"""'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.string,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Multiline '''String'''
      if (scanner.scan(RegExp(r"'''(?:[^'\\]|\\(.|\n))*'''"))) {
        spans.add(_HighlightedSpan(
          _HighlightType.string,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // "String"
      if (scanner.scan(RegExp(r'"(?:[^"\\]|\\.)*"'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.string,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // 'String'
      if (scanner.scan(RegExp(r"'(?:[^'\\]|\\.)*'"))) {
        spans.add(_HighlightedSpan(
          _HighlightType.string,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Double
      if (scanner.scan(RegExp(r'\d+\.\d+'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.number,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Integer
      if (scanner.scan(RegExp(r'\d+'))) {
        spans.add(_HighlightedSpan(_HighlightType.number,
            scanner.lastMatch?.start ?? 0, scanner.lastMatch?.end ?? 0));
        continue;
      }

      // Punctuation
      if (scanner.scan(RegExp(r'[\[\]{}().!=<>&\|\?\+\-\*/%\^~;:,]'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.punctuation,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Meta data
      if (scanner.scan(RegExp(r'@\w+'))) {
        spans.add(_HighlightedSpan(
          _HighlightType.keyword,
          scanner.lastMatch?.start ?? 0,
          scanner.lastMatch?.end ?? 0,
        ));
        continue;
      }

      // Words
      if (scanner.scan(RegExp(r'\w+'))) {
        _HighlightType? type;

        var word = scanner.lastMatch?[0] ?? '';
        if (word.startsWith('_')) word = word.substring(1);

        if (_keywords.contains(word))
          type = _HighlightType.keyword;
        else if (_builtInTypes.contains(word))
          type = _HighlightType.keyword;
        else if (_firstLetterIsUpperCase(word))
          type = _HighlightType.klass;
        else if (word.length >= 2 &&
            word.startsWith('k') &&
            _firstLetterIsUpperCase(word.substring(1)))
          type = _HighlightType.constant;

        if (type != null) {
          spans.add(_HighlightedSpan(
            type,
            scanner.lastMatch?.start ?? 0,
            scanner.lastMatch?.end ?? 0,
          ));
        }
      }

      // Check if this loop did anything
      if (lastLoopPosition == scanner.position) {
        // Failed to parse this file, abort gracefully
        return [];
      }
      lastLoopPosition = scanner.position;
    }

    for (var i = spans.length - 2; i >= 0; i -= 1) {
      if (spans[i].type == spans[i + 1].type &&
          spans[i].end == spans[i + 1].start) {
        spans[i] = _HighlightedSpan(
          spans[i].type,
          spans[i].start,
          spans[i + 1].end,
        );
        spans.removeAt(i + 1);
      }
    }

    return spans;
  }

  bool _firstLetterIsUpperCase(String str) {
    if (str.isNotEmpty) {
      final first = str.substring(0, 1);
      return first == first.toUpperCase();
    }
    return false;
  }
}

class _HighlightedSpan {
  _HighlightedSpan(this.type, this.start, this.end);
  final _HighlightType type;
  final int start;
  final int end;

  String textForSpan(String src) {
    return src.substring(start, end);
  }

  TextStyle textStyle(HighlighterStyle style) {
    if (type == _HighlightType.number)
      return style.numberStyle;
    else if (type == _HighlightType.comment)
      return style.commentStyle;
    else if (type == _HighlightType.keyword)
      return style.keywordStyle;
    else if (type == _HighlightType.string)
      return style.stringStyle;
    else if (type == _HighlightType.punctuation)
      return style.punctuationStyle;
    else if (type == _HighlightType.klass)
      return style.classStyle;
    else if (type == _HighlightType.constant)
      return style.constantStyle;
    else
      return style.style;
  }
}

class HighlighterStyle {
  HighlighterStyle({
    required this.style,
    required this.numberStyle,
    required this.commentStyle,
    required this.keywordStyle,
    required this.stringStyle,
    required this.punctuationStyle,
    required this.classStyle,
    required this.constantStyle,
  });

  static HighlighterStyle lightThemeStyle() {
    return HighlighterStyle(
      style: const TextStyle(color: Color(0xFF000000)),
      numberStyle: const TextStyle(color: Color(0xFF1565C0)),
      commentStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      keywordStyle: const TextStyle(color: Color(0xFF9C27B0)),
      stringStyle: const TextStyle(color: Color(0xFF43A047)),
      punctuationStyle: const TextStyle(color: Color(0xFF000000)),
      classStyle: const TextStyle(color: Color(0xFF512DA8)),
      constantStyle: const TextStyle(color: Color(0xFF795548)),
    );
  }

  static HighlighterStyle darkThemeStyle() {
    return HighlighterStyle(
      style: const TextStyle(color: Color(0xFFFFFFFF)),
      numberStyle: const TextStyle(color: Color(0xFF1565C0)),
      commentStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      keywordStyle: const TextStyle(color: Color(0xFF80CBC4)),
      stringStyle: const TextStyle(color: Color(0xFF009688)),
      punctuationStyle: const TextStyle(color: Color(0xFFFFFFFF)),
      classStyle: const TextStyle(color: Color(0xFF009688)),
      constantStyle: const TextStyle(color: Color(0xFF795548)),
    );
  }

  final TextStyle style;
  final TextStyle numberStyle;
  final TextStyle commentStyle;
  final TextStyle keywordStyle;
  final TextStyle stringStyle;
  final TextStyle punctuationStyle;
  final TextStyle classStyle;
  final TextStyle constantStyle;
}
