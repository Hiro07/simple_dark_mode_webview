import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_dark_mode_webview/simpledarkmodewebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Dark Mode Webview Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // You need to set darkTheme here!
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Simple Dark Mode Webview Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: Text(
                'This widget is useful specially when you want to show a static HTML file!!!',
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: rootBundle.loadString('lib/assets/sample_policy.html'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('loading...');
                } else {
                  if(snapshot.data is String) {
                    return SimpleDarkModeAdaptableWebView(
                      snapshot.data as String,

                      // (Example) Specify the html's encoding.
                      encoding: Encoding.getByName('utf-8'),

                      // (Example) You can also register gestures as like the original webview.
                      gestureRecognizers: Set()
                        ..add(Factory<TapGestureRecognizer>(
                                () => TapGestureRecognizer()
                              ..onTapDown = (tap) {
                                final snackBar = SnackBar(
                                    content: Text('Webivew was tapped down.'));
                                //Scaffold.of(context).showSnackBar(snackBar);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              })),
                    );
                  } else {
                    return Text('invalid data.');
                  }
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
