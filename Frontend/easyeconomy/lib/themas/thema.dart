import 'package:flutter/material.dart';

class CambioTema with ChangeNotifier {
  ThemeData? _themeData;

  CambioTema(this._themeData);

  ThemeData getTheme() => _themeData!;

  setThema(ThemeData thema) {
    _themeData = thema;
    notifyListeners();
  }
}
