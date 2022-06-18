// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:text_process/text_process.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Stream<String> _processText;
  String? refreshedData = '';

  @override
  void initState() {
    super.initState();
    TextProcess.initialize(
      showConfirmationToast: true,
      showRefreshToast: true,
      showErrorToast: true,
      confirmationMessage: "Text Added",
      refreshMessage: "Got all Text",
      errorMessage: "Some Error",
    );
    _processText = TextProcess.getProcessTextStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Process Text Plugin'),
        actions: [
          refreshedData != null
              ? IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    dynamic result =
                        await TextProcess.refreshProcessText;
                    setState(() {
                      refreshedData = result;
                    });
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: StreamBuilder<String?>(
              stream: _processText,
              builder: (context, snapshot) {
                return Text('Fetched Data: ${snapshot.data}');
              },
            ),
          ),
          const SizedBox(height: 150),
          Text("Refreshed Data: ${refreshedData.toString()}"),
        ],
      ),
    );
  }
}
