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

    var today = DateTime.now().day.toString();
    void checkingRemainCoin(today_baked)
    {
      print("today_baked : $today_baked");
      print("today : $today");

      if (today_baked == null || today_baked != today)
      {
        storage.write(key: "date", value: DateTime.now().day.toString());
        storage.write(key: "coin", value: 100.toString());
      }
    }

    storage.read(key: "date").then((value) => checkingRemainCoin(value));

    return MaterialApp(
      home: LoginView()
    );
  }
}

