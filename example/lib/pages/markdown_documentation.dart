import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../dart_syntax_highlighter.dart';
import '../extension.dart';

class MarkdownDocumentation extends StatefulWidget {
  final String markdownFile;
  final bool isInitial;
  final bool isFullScreen;

  final VoidCallback? onInitialPop;

  const MarkdownDocumentation({
    Key? key,
    required this.markdownFile,
    this.isInitial = false,
    this.onInitialPop,
    this.isFullScreen = false,
  }) : super(key: key);

  @override
  _MarkdownDocumentationState createState() => _MarkdownDocumentationState();
}

class _MarkdownDocumentationState extends State<MarkdownDocumentation> {
  String data = "";
  String title = "";
  String errorString = "";

  double _offset = 0;

  late final ScrollController _controller;

  late MarkdownStyleSheet _styleSheet;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController()
      ..addListener(() {
        if (mounted) {
          setState(() {
            _offset = _controller.offset;
          });
        }
      });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      errorString = "";

      try {
        data = await rootBundle.loadString(widget.markdownFile);
        final dataItems = data.split('\n');
        if (dataItems.isNotEmpty) {
          final splitItems = dataItems[0].split(" ");
          if (splitItems.length > 1) {
            title = splitItems[1];
          }
          dataItems.removeAt(0);
          data = dataItems.join("\n");
        }
      } catch (e) {
        data = "";
        title = "";
        errorString = e.toString();
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = Theme.of(context);

    _styleSheet = MarkdownStyleSheet(
      a: const TextStyle(color: Colors.blue),
      p: theme.textTheme.bodyText2?.copyWith(height: 1),
      code: theme.textTheme.bodyText2!.copyWith(
        backgroundColor: theme.cardTheme.color ?? theme.cardColor,
        fontFamily: 'monospace',
        fontSize: theme.textTheme.bodyText2!.fontSize! * 0.85,
      ),
      h1: theme.textTheme.headline5?.copyWith(
          height: 1, fontWeight: FontWeight.bold, color: Color(0xff000000)),
      h2: theme.textTheme.headline6?.copyWith(
          height: 2, fontWeight: FontWeight.bold, color: Color(0xff444444)),
      h3: theme.textTheme.subtitle1?.copyWith(
          height: 2, fontWeight: FontWeight.bold, color: Color(0xff545454)),
      h4: theme.textTheme.bodyText1?.copyWith(height: 2),
      h5: theme.textTheme.bodyText1?.copyWith(height: 2),
      h6: theme.textTheme.bodyText1?.copyWith(height: 2),
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      del: const TextStyle(decoration: TextDecoration.lineThrough),
      blockquote: theme.textTheme.bodyText2,
      img: theme.textTheme.bodyText2,
      checkbox: theme.textTheme.bodyText2!.copyWith(
        color: theme.primaryColor,
      ),
      blockSpacing: 8.0,
      listIndent: 24.0,
      listBullet: theme.textTheme.bodyText2,
      listBulletPadding: const EdgeInsets.only(right: 4),
      tableHead: const TextStyle(fontWeight: FontWeight.w600),
      tableBody: theme.textTheme.bodyText2,
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(
        color: theme.dividerColor,
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: const BoxDecoration(),
      blockquotePadding: const EdgeInsets.all(8.0),
      blockquoteDecoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(2.0),
      ),
      codeblockPadding: const EdgeInsets.all(8.0),
      codeblockDecoration: BoxDecoration(
        color: Color(0xffdfdfdf),
        borderRadius: BorderRadius.circular(2.0),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 5.0,
            color: theme.dividerColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: _offset <= 0 ? 0 : 7,
        title: Text(
          title,
          style: _styleSheet.h1,
        ),
        titleSpacing: 10,
        centerTitle: false,
        leading:
            widget.isInitial && !widget.isFullScreen
                ? null
                : IconButton(
                    onPressed: () {
                      if (widget.isInitial) {
                        widget.onInitialPop?.call();
                      } else {
                        context.pop();
                      }
                    },
                    icon: Icon(Icons.chevron_left),
                    iconSize: 30,
                    color: Color(0xff444444),
                  ),
      ),
      body: data == "" && title == ""
          ? SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: errorString == ""
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Something went wrong...",
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              errorString,
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),
            )
          : Transform.scale(
              scale: _offset <= 0 ? 1 : 0.996,
              origin: Offset(0.5, 0),
              child: Markdown(
                data: data,
                controller: _controller,
                selectable: true,
                physics: BouncingScrollPhysics(),
                bulletBuilder: (_, __) => Icon(
                  Icons.circle,
                  size: 7,
                ),
                extensionSet: md.ExtensionSet.gitHubWeb,
                shrinkWrap: true,
                syntaxHighlighter: DartSyntaxHighlighter(
                  style: Theme.of(context).brightness == Brightness.dark
                      ? HighlighterStyle.darkThemeStyle()
                      : HighlighterStyle.lightThemeStyle(),
                ),
                softLineBreak: true,
                styleSheet: _styleSheet,
                onTapLink: (text, href, title) {
                  if (href != null && href.isNotEmpty) {
                    context.pushRoute(
                      MarkdownDocumentation(
                        markdownFile: getDocumentationFile(href),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
