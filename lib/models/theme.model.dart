import 'package:flutter/material.dart';

import 'package:flutter_group_journal/utils/storageManager.dart';

class ThemeModel extends ChangeNotifier {
  bool isDark = false;

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
  );

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeModel() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        isDark = false;
        _themeData = lightTheme;
      } else {
        isDark = true;
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    isDark = true;    
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    isDark = false;
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
