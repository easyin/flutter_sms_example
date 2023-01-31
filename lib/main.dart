import 'package:flutter/material.dart';
import 'package:flutter_sms_example/main_screens/login.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/main_screens/screen_library.dart';
import 'model/sms_task_data.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: LoginView()
    );
  }
}

