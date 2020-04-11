library simple_dark_mode_webview;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'hexColor.dart';

class SimpleDarkModeAdaptableWebView extends StatefulWidget {
  SimpleDarkModeAdaptableWebView(
    this.htmlString, {
    Key key,

    // for WebView
    this.initialUrl,
    this.javascriptMode = JavascriptMode.disabled,
    this.javascriptChannels,
    this.navigationDelegate,
    this.gestureRecognizers,
    this.onPageStarted,
    this.onPageFinished,
    this.debuggingEnabled = false,
    this.gestureNavigationEnabled = false,
    this.userAgent,
    this.initialMediaPlaybackPolicy =
        AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,

    // for Uri.dataFromString()
    // expecting the string is HTML.
    this.mimeType = 'text/html',
    this.encoding,
    this.parameters,
    this.base64 = false,
  }) : super(key: key);

  /// raw HTML text
  final String htmlString;

  final String mimeType;
  final Encoding encoding;
  final Map<String, String> parameters;
  final bool base64;

  final String initialUrl;
  final JavascriptMode javascriptMode;
  final Set<JavascriptChannel> javascriptChannels;
  final NavigationDelegate navigationDelegate;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final PageStartedCallback onPageStarted;
  final PageFinishedCallback onPageFinished;
  final bool debuggingEnabled;
  final bool gestureNavigationEnabled;
  final String userAgent;
  final AutoMediaPlaybackPolicy initialMediaPlaybackPolicy;

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<SimpleDarkModeAdaptableWebView> {
  @override
  Widget build(BuildContext context) {
    // Adapting LIGHT or DARK mode of the device to HTML.
    // Using canvasColor for background color, and textTheme for foreground(font color).
    // Simply adding CSS for <body>'s background-color, and overwrite <body> tag with theme color.
    var htmlString =
        '<style>body { background-color: ${Theme.of(context).canvasColor.toHex()}; } </style>'
        '<body text="${Theme.of(context).textTheme.bodyText2.color.toHex()}" >'
        '${widget.htmlString}'
        '</body>';
    Theme.of(context).textTheme.body1;

    return WebView(
      onWebViewCreated: (WebViewController webViewController) async {
        // return the uri data from raw html string.
        await _loadHtmlFromString(webViewController, htmlString);
      },
      initialUrl: widget.initialUrl,
      javascriptMode: widget.javascriptMode,
      javascriptChannels: widget.javascriptChannels,
      navigationDelegate: widget.navigationDelegate,
      gestureRecognizers: widget.gestureRecognizers,
      onPageStarted: widget.onPageStarted,
      onPageFinished: widget.onPageFinished,
      debuggingEnabled: widget.debuggingEnabled,
      gestureNavigationEnabled: widget.gestureNavigationEnabled,
      userAgent: widget.userAgent,
      initialMediaPlaybackPolicy: widget.initialMediaPlaybackPolicy,
    );
  }

  /// load HTML from string
  Future _loadHtmlFromString(
      WebViewController controller, String htmlText) async {
    await controller.loadUrl(Uri.dataFromString(
      // pass the HTML
      htmlText,

      mimeType: widget.mimeType,
      encoding: widget.encoding,
      base64: widget.base64,
      parameters: widget.parameters,
    ).toString());
  }
}
