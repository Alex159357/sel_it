


import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sel_it/themes/themes.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        drawer: Drawer(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: ThemeSwitcher(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: ThemeProvider.of(context)!.brightness ==
                                Brightness.light
                                ? AppTheme.darkTheme
                                : AppTheme.lightTheme,
                          );
                        },
                        icon: Icon(Icons.brightness_3, size: 25),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Flutter Demo Home Page',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: TextStyle(fontSize: 200),
              ),
              CheckboxListTile(
                title: Text('Slow Animation'),
                value: timeDilation == 5.0,
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      timeDilation = 5.0;
                    } else {
                      timeDilation = 1.0;
                    }
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ThemeSwitcher(
                    clipper: ThemeSwitcherBoxClipper(),
                    builder: (context) {
                      return OutlinedButton(
                        child: Text('Box Animation'),
                        onPressed: () {
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: ThemeProvider.of(context)!.brightness ==
                                Brightness.light
                                ? AppTheme.darkTheme
                                : AppTheme.lightTheme,
                          );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    clipper: ThemeSwitcherCircleClipper(),
                    builder: (context) {
                      return OutlinedButton(
                        child: Text('Circle Animation'),
                        onPressed: () {
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: ThemeProvider.of(context)!.brightness ==
                                Brightness.light
                                ? AppTheme.darkTheme
                                : AppTheme.lightTheme,
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ThemeSwitcher(
                    clipper: ThemeSwitcherBoxClipper(),
                    builder: (context) {
                      return OutlinedButton(
                        child: Text('Box (Reverse)'),
                        onPressed: () {
                          var brightness = ThemeProvider.of(context)!.brightness;
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: brightness == Brightness.light
                                ? AppTheme.darkTheme
                                : AppTheme.lightTheme,
                            reverseAnimation:
                            brightness == Brightness.dark ? true : false,
                          );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    clipper: ThemeSwitcherCircleClipper(),
                    builder: (context) {
                      return OutlinedButton(
                        child: Text('Circle (Reverse)'),
                        onPressed: () {
                          var brightness = ThemeProvider.of(context)!.brightness;
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: brightness == Brightness.light
                                ? AppTheme.darkTheme
                                : AppTheme.lightTheme,
                            reverseAnimation:
                            brightness == Brightness.dark ? true : false,
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeProvider.of(context) ==AppTheme.pinkTheme,
                        onChanged: (needPink) {
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: needPink! ? AppTheme.pinkTheme : AppTheme.lightTheme,
                          );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeProvider.of(context) == AppTheme.darkBlueTheme,
                        onChanged: (needDarkBlue) {
                          ThemeSwitcher.of(context)!.changeTheme(
                            theme: needDarkBlue! ? AppTheme.darkBlueTheme : AppTheme.lightTheme,
                          );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    builder: (context) {
                      return Row(
                        children: [
                          Text("Halloween"),
                          Checkbox(
                            value: ThemeProvider.of(context) == AppTheme.halloweenTheme,
                            onChanged: (needBlue) {
                              ThemeSwitcher.of(context)!.changeTheme(
                                theme: needBlue! ? AppTheme.halloweenTheme : AppTheme.lightTheme,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}