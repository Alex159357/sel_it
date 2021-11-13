import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sel_it/screens/main/main_nav.dart';
import 'package:sel_it/themes/theme_controller.dart';
import 'package:sel_it/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff303f9f), // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));

    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<ThemeController> snapshot) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: snapshot.connectionState == ConnectionState.done
                ? ThemeProvider(
                    initTheme: snapshot.data!.getCurrentTheme(),
                    builder: (_, myTheme) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Sel It',
                        theme: myTheme,
                        home: MainNav(),
                      );
                    },
                  )
                : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff0672f6),
                      Color(0xff303f9f),
                    ],
                  ),
                ),
                    child: Center(
                        child: SizedBox(
                      child: Image.asset("assets/img/logo.png"),
                      height: 130,
                    ))));
      },
    );
  }

  Future<ThemeController> init() async {

    await EasyLocalization.ensureInitialized();
    cameras = await availableCameras();
    prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 3));
    return ThemeController();
  }
}
