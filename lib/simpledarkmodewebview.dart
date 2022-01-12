/// A simple implementation of dark mode or dark theme webview.
library simple_dark_mode_webview;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

  /// raw HTML text.
  /// This widget expects static HTML text only.
  final String htmlString;

  /// parameter for [WebView.initialUrl]
  final String? initialUrl;

  /// parameter for [WebView.javascriptMode]
  final JavascriptMode javascriptMode;

  /// parameter for [WebView.javascriptChannels]
  final Set<JavascriptChannel>? javascriptChannels;

  /// parameter for [WebView.navigationDelegate]
  final NavigationDelegate? navigationDelegate;

  /// parameter for [WebView.gestureRecognizers]
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// parameter for [WebView.onPageStarted]
  final PageStartedCallback? onPageStarted;

  /// parameter for [WebView.onPageFinished]
  final PageFinishedCallback? onPageFinished;

  /// parameter for [WebView.debuggingEnabled]
  final bool debuggingEnabled;

  /// parameter for [WebView.gestureNavigationEnabled]
  final bool gestureNavigationEnabled;

  /// parameter for [WebView.userAgent]
  final String? userAgent;

  /// parameter for [WebView.initialMediaPlaybackPolicy]
  final AutoMediaPlaybackPolicy initialMediaPlaybackPolicy;

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
    var htmlString =
        '<style>body { background-color: ${Theme.of(context).canvasColor.toHex()}; } </style>'
        // [Theme.of(context).textTheme.body1] is deprecated with Flutter 1.17.0,
        // [Theme.of(context).textTheme.bodyText2] isn't defined for the class 'TextTheme' with Flutter 1.12.13.
        // Even though above, pub.dev's [pana] use Flutter 1.12.13 then my score is ZERO!
        // So I stand deprecated code until I find the solution...
        //'<body text="${Theme.of(context).textTheme.body1.color.toHex()}" >'
        // 2020.05.25 pub.dev starts warning below finally. so I change 'body1' to 'bodyText2'.
        // -- 'body1' is deprecated and shouldn't be used. This is the term used in the 2014 version of material design. The modern term is bodyText2. This feature was deprecated after v1.13.8..
        '<body text="${Theme.of(context).textTheme.bodyText2?.color?.toHex()}" >'
        '${widget.htmlString}'
        '</body>';

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

  /// [controller] loads HTML from [htmlText] using [Uri.dataFromString()] method.
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
