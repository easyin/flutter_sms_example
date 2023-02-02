import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_example/main_screens/login.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {

  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    var today_baked = storage.read(key: "date");
    var today = DateTime.now().toString();

    if (today_baked == null || today_baked != today)
    {
      storage.write(key: "date", value: DateTime.now().toString());
      storage.write(key: "coin", value: 100.toString());
    }

    return MaterialApp(
      home: LoginView()
    );
  }
}

