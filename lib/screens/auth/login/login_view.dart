import 'package:flutter/material.dart';

import '../../../main.dart';

class LoginView extends StatelessWidget {
  final Function? onLogin;

  const LoginView({Key? key, this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              prefs.setBool("auth_state", true);
              onLogin!(true);
            },
            child: Text("Sign in"))
      ],
    );
  }
}
