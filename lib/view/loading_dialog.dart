

import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x55000000),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
