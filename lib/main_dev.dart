import 'package:chat_app/AppConfig.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  final prodAppConfig = AppConfig(
    appName: "Dev Flavor",
    themeData: ThemeData(primarySwatch: Colors.blue),
  );
  runWithAppConfig(prodAppConfig);
}

