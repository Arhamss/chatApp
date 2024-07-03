import 'package:chat_app/AppConfig.dart';
import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/firebase_options_prod.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptionsProd.currentPlatform,
  );
  // await SharedPreferencesHelper.init();
  await setup();

  final prodAppConfig = AppConfig(
    appName: 'Prod Flavor',
    themeData: ThemeData(primarySwatch: Colors.deepPurple),
  );
  runWithAppConfig(prodAppConfig);
}
