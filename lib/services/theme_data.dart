import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';


class ThemeService{

  final  _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeMode(bool isDarkMode) => _box.write(_key, isDarkMode);


  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void changeTheme(){
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeMode(!_loadThemeFromBox());
  }



}