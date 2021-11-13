import 'package:flutter/material.dart';
import 'package:sel_it/themes/themes.dart';

import '../main.dart';

enum CurrentTheme { LIGHT, DARK, HALLOWEEN, NEW_YEAR, VALENTINES_DAY, MARCH8 }

extension Theme on CurrentTheme {
  int get val {
    switch (this) {
      case CurrentTheme.LIGHT:
        return 0;
      case CurrentTheme.DARK:
        return 1;
      case CurrentTheme.HALLOWEEN:
        return 2;
      case CurrentTheme.NEW_YEAR:
        return 3;
      case CurrentTheme.VALENTINES_DAY:
        return 4;
      case CurrentTheme.MARCH8:
        return 5;
    }
  }

}

class ThemeController {

  ThemeData getCurrentTheme() {
    int? themeIndex = prefs.getInt("theme");
    if(themeIndex != null){
      CurrentTheme theme = _byInt(themeIndex);
      return AppTheme().getCurrentTheme(theme);
    }else {
      final isPlatformDark =
          WidgetsBinding.instance!.window.platformBrightness == Brightness.dark;
      return isPlatformDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }


  CurrentTheme _byInt(int i){
    switch(i){
      case 0: return CurrentTheme.LIGHT;
      case 1: return CurrentTheme.DARK;
      case 2: return CurrentTheme.HALLOWEEN;
      case 3: return CurrentTheme.NEW_YEAR;
      case 4: return CurrentTheme.VALENTINES_DAY;
      case 5: return CurrentTheme.MARCH8;
      default: return CurrentTheme.LIGHT;
    }
  }
}
