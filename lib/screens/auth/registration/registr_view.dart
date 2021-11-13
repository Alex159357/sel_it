import 'package:flutter/material.dart';

import '../../../main.dart';

class RegistrView extends StatelessWidget {
  const RegistrView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              prefs.setBool("auth_state", true);
              // onLogin!(true);
            },
            child: Text("Sign in"))
      ],
    );
  }
}
