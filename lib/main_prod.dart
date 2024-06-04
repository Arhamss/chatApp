import 'package:chat_app/AppConfig.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions options = const FirebaseOptions(
    apiKey: "AIzaSyBs4pEbRLgThYLSLxgYS6DtfoMmeYqilA8", 
    appId: "07da05b531ba21774dcd0c", 
    messagingSenderId: "88431492069", 
    projectId: "chatapp-2a7b8",
    storageBucket: "chatapp-2a7b8.appspot.com",
    );
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();

  final prodAppConfig = AppConfig(
    appName: "Prod Flavor",
    themeData: ThemeData(primarySwatch: Colors.deepPurple),
  );
  runWithAppConfig(prodAppConfig, sharedPreferences);
}