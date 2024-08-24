/// A simple implementation of dark mode or dark theme webview.
library simple_dark_mode_webview;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'hexColor.dart';

/// A simple dark-mode-compatible widget.
class SimpleDarkModeAdaptableWebView extends StatefulWidget {
  /// Constructor.
  /// Make a dark-mode-compatible webview.
  SimpleDarkModeAdaptableWebView(
    this.htmlString, {
    Key? key,

    // for WebView
    this.javascriptMode = JavaScriptMode.disabled,

    // for Uri.dataFromString()
    // expecting the string is HTML.
    this.mimeType = 'text/html',
    this.encoding,
    this.parameters,
    this.base64 = false,
  }) : super(key: key);

  /// raw HTML text.
  /// This widget expects static HTML text only.
  final String htmlString;

  /// parameter for [WebView.javaScriptMode]
  final JavaScriptMode javascriptMode;

  /// parameter for [Uri.dataFromString.mimeType]
  final String mimeType;

  /// parameter for [Uri.dataFromString.encoding]
  final Encoding? encoding;

  /// parameter for [Uri.dataFromString.parameters]
  final Map<String, String>? parameters;

  /// parameter for [Uri.dataFromString.base64]
  final bool base64;

  @override
  _WebViewState createState() => _WebViewState();
}

/// state of web view.
class _WebViewState extends State<SimpleDarkModeAdaptableWebView> {
  @override
  Widget build(BuildContext context) {
    // Adapting LIGHT or DARK mode of the device to HTML.
    // Using canvasColor for background color, and textTheme for foreground(font color).
    // Simply adding CSS for <body>'s background-color, and overwrite <body> tag with theme color.
    var htmlString = '<!DOCTYPE html>'
        '<head><meta name="viewport" content="width=device-width, initial-scale=1.0">'
        '<style>body { background-color: ${Theme.of(context).canvasColor.toHex()}; } </style>'
        '</head>'
        // [Theme.of(context).textTheme.body1] is deprecated with Flutter 1.17.0,
        // [Theme.of(context).textTheme.bodyText2] isn't defined for the class 'TextTheme' with Flutter 1.12.13.
        // Even though above, pub.dev's [pana] use Flutter 1.12.13 then my score is ZERO!
        // So I stand deprecated code until I find the solution...
        //'<body text="${Theme.of(context).textTheme.body1.color.toHex()}" >'
        // 2020.05.25 pub.dev starts warning below finally. so I change 'body1' to 'bodyText2'.
        // -- 'body1' is deprecated and shouldn't be used. This is the term used in the 2014 version of material design. The modern term is bodyText2. This feature was deprecated after v1.13.8..
        '<body text="${Theme.of(context).textTheme.bodyMedium?.color?.toHex()}" >'
        '${widget.htmlString}'
        '</body>';

    var controller = WebViewController()
      ..setJavaScriptMode(widget.javascriptMode)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.dataFromString(
        // pass the HTML
        htmlString,

        mimeType: widget.mimeType,
        encoding: widget.encoding,
        base64: widget.base64,
        parameters: widget.parameters,
      ));

    return WebViewWidget(controller: controller);
  }

}
