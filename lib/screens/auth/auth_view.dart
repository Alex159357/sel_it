import 'package:flutter/material.dart';
import 'package:sel_it/screens/auth/registration/registr_view.dart';

import 'login/login_view.dart';

class AuthView extends StatelessWidget {
  final Function? authCallback;

  const AuthView({Key? key, this.authCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TabBar(
            tabs: [
              Tab(
                text: "Sign in",
              ),
              Tab(
                text: "Registration",
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 60,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Image.asset("assets/img/logo.png"),
                  height: 150,
                ),
              ),
            ),
            Positioned(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width - 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
                      ),
                      child: TabBarView(
                        children: [
                          LoginView(
                            onLogin: authCallback,
                          ),
                          RegistrView(),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
