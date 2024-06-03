import 'package:chat_app/AppConfig.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  final prodAppConfig = AppConfig(
    appName: "Prod Flavor",
    themeData: ThemeData(primarySwatch: Colors.deepPurple),
  );
  runWithAppConfig(prodAppConfig);
}