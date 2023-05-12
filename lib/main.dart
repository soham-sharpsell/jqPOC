import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final InAppLocalhostServer localhostServer = new InAppLocalhostServer();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // start the localhost server
  await localhostServer.start();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String answer = "";
  InAppWebViewController? controller;

  TextEditingController jqExpression = TextEditingController();
  TextEditingController jsonText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppLocalhostServer Example'),
      ),
      body: Container(
          child: Column(children: <Widget>[
            Container(
              height: 1,
              child: InAppWebView(
                initialOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)),
                initialUrlRequest: URLRequest(
                    url: Uri.parse("http://localhost:8080/assets/index.html")
                ),
                onWebViewCreated: (controller1) {
                  controller = controller1;

                  controller!.addJavaScriptHandler(handlerName: 'showResult', callback: (args) {
                    print(args);
                    answer = args[0];
                    setState(() {

                    });
                  });
                },
                onLoadStart: (controller, url) {},
                onLoadStop: (controller, url) {},
              ),
            ),
            TextField(
              controller: jqExpression,
              decoration: const InputDecoration(hintText: "JQ Expression"),
            ),
            TextField(
              controller: jsonText,
              decoration: const InputDecoration(hintText: "Json Text"),
            ),
            ElevatedButton(onPressed: () async {

              await controller!.evaluateJavascript(source: " convertJson('${jsonText.text}','${jqExpression.text}')") ;


              setState(() {

              });
            }, child: const Text("Submit")),
             Text(answer)
          ]
          )
      ),
    );
  }
}