import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static SharedPreferences? sharedPreferences;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  String getString(String key) {
    //final prefs = await SharedPreferences.getInstance();
    return sharedPreferences?.getString(key) ?? "";
  }

  setString(String key, String value) async {
    //final prefs = await SharedPreferences.getInstance();
    return sharedPreferences?.setString(key, value);
  }

  setInt(String key, int val) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, val);
  }

  int getInt(String key) {
    return sharedPreferences?.getInt(key) ?? 0;
  }

  Future setDouble(String key, double val) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, val);
  }

  Future<double> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  setUserType(String key, String value) async {
    //final prefs = await SharedPreferences.getInstance();
    return sharedPreferences?.setString(key, value);
  }

  void setArguments(Map<String, dynamic> arguments) {
    final jsonString = jsonEncode(arguments);
    setString("ARGUMENTS", jsonString);
  }

  Map<String, dynamic>? getArguments() {
    final jsonString = getString("ARGUMENTS");
    if (jsonString == null || jsonString.isEmpty) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
