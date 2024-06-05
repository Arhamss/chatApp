import 'package:chat_app/AppConfig.dart';
import 'package:chat_app/firebase_options_prod.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptionsProd.currentPlatform);
  final sharedPreferences = await SharedPreferences.getInstance();

  final prodAppConfig = AppConfig(
    appName: "Prod Flavor",
    themeData: ThemeData(primarySwatch: Colors.deepPurple),
  );
  runWithAppConfig(prodAppConfig, sharedPreferences);
}