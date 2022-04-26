// ignore_for_file: deprecated_member_use
// ignore_for_file: prefer_collection_literals

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import '../models/ortho_model.dart';

class OrthoWeb extends StatefulWidget {
  ///options for ortho
  final Map<String, dynamic>? orthoOptions;
  const OrthoWeb({Key? key, this.orthoOptions})
      : assert(orthoOptions != null),
        super(key: key);

  @override
  State<OrthoWeb> createState() => _OrthoWebState();
}

class _OrthoWebState extends State<OrthoWeb> {
  ///initialiaze webview controller
  WebViewController? _controller;

  ///call orthoModel to handle transactions
  OrthoModel orthoModel = OrthoModel(false, false, false, false, "");

  ///config init to be passed to url
  static const config = {
    'short-url': 'Ortho-lazerpay-checkout',
    'amount': 10000,
  };

  ///converts config options to string
  String configString = jsonEncode(config);

  static const slug = 'Ortho-okra-short-url';

  static final Dio _dio = Dio(BaseOptions(
      baseUrl: "https://api.tryortho.co/v1/sdk/boot-json/ortho-flow"));

  ///Start a transaction
  ///
  ///Makes an api call with ortho options
  ///Gets the html response to be used in a webview
  Future initTransaction() async {
    try {
      Response response = await _dio.get("/$slug/$configString");

      return response.data['body'];
    } on DioError catch (e) {
      debugPrint(
          "FlutterOrtho : Error initializing transaction: ${e.response!.data['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: initTransaction(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint(snapshot.data.toString());
                return WebView(
                    onPageFinished: (response) {
                      // //String jsonOptions = json.encode(widget.orthoOptions);
                      String jsonOptions = json.encode(widget.orthoOptions);
                      _controller?.evaluateJavascript(
                          "openOrthoWidget('${widget.orthoOptions}')");
                      debugPrint("response");
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    gestureRecognizers: [
                      Factory(() => VerticalDragGestureRecognizer()),
                      Factory(() => TapGestureRecognizer())
                    ].toSet(),
                    javascriptChannels: Set.from([
                      JavascriptChannel(
                          name: 'OnSuccess',
                          onMessageReceived: (JavascriptMessage message) {
                            orthoModel = OrthoModel(
                                true, true, false, false, message.message);
                          }),
                      JavascriptChannel(
                          name: 'OnError',
                          onMessageReceived: (JavascriptMessage message) {
                            orthoModel = OrthoModel(
                                true, false, true, false, message.message);
                          }),
                      JavascriptChannel(
                          name: 'OnClose',
                          onMessageReceived: (JavascriptMessage message) {
                            Navigator.pop(context);
                          }),
                    ]),
                    onWebViewCreated: (webViewController) {
                      _controller = webViewController;
                      _controller?.loadHtmlString(snapshot.data.toString());
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error.toString()}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator(color: Colors.black));
            },
          ),
        ],
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                child: Text('Close', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
