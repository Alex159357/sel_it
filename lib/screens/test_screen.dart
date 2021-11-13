import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final List<Uint8List> files;

  const TestScreen({Key? key, required this.files}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.files.length,
          itemBuilder: (BuildContext context, int index) {
        return Image.memory(widget.files[index] , width: 100, height: 100,);
      }),
    );
  }
}
