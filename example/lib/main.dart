import 'package:flutter/material.dart';
import 'package:flutter_ortho/flutter_ortho.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ortho Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const OrthoDemoPage(title: 'Ortho Demo Page'),
    );
  }
}

class OrthoDemoPage extends StatefulWidget {
  const OrthoDemoPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<OrthoDemoPage> createState() => _OrthoDemoPageState();
}

class _OrthoDemoPageState extends State<OrthoDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  var orthoOptions = {
                    "name": "ortho test",
                    "email": "ayoshokz@gmail.com",
                    "amount": 500000,
                    "key":
                        "sk_live_LFcQQzAo3f60G7VDpYRCNj11brzr5koPqFcBVj6YdxyPOxp5IQ",
                    "currency": "USD",
                    "acceptPartialPayment": "false"
                  };
                  OrthoModel reply = await FlutterOrtho.create(
                      context: context, orthoOptions: orthoOptions);
                  print(reply.isSuccessful);
                },
                child: const Text(
                  'Click button to open Ortho Widget',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
