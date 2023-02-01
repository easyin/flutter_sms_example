
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_example/main_screens/screen_library.dart';
import 'package:flutter_sms_example/services/user_auth_service.dart';

import '../services/show_dialog.dart';

class LoginView extends StatelessWidget {
  final input_id = TextEditingController();
  final input_passwd = TextEditingController();
  String? passport_jstring;

  static final storage = FlutterSecureStorage();

  _asyncMethod(context) async {
    passport_jstring = await storage.read(key: "passport");
    print("passport data in storage: $passport_jstring");

    if(passport_jstring != null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TaskListViewer()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _asyncMethod(context);

    return Material(
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0,0,0,20),
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      controller: input_id,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "EASY-SI 아이디를 입력하세요",
                      ),
                    ),

                    TextField(
                      obscureText: true,
                      controller: input_passwd,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "EASY-SI 비밀번호를 입력하세요",
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  var test = PassportService().login(input_id.text, input_passwd.text);
                  test.then((value) {
                    if(value.u_code != null)
                    {
                      print(value);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TaskListViewer()));
                    }

                    else
                    {
                      FlutterDialog(context, "로그인실패", "아이디, 비밀번호를 체크해주세요");
                      print(value.message);
                    }
                  });
                },
                child: Text("이지에스아이와 연동하기"),)
            ],
          ),
        ),
      )
    );
  }
}

