
import 'package:flutter/material.dart';
import 'package:flutter_sms_example/main_screens/screen_library.dart';
import 'package:flutter_sms_example/services/user_auth_service.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextField(),
        TextField(),
        ElevatedButton(
          onPressed: () {
            var test = PassportService().login("wldls3521", "12345");
            test.then((value) => print(value.u_email));
            Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskListViewer()));
          },
          child: Text("로그인하기"),)
      ],
    );
  }
}

  // class SignIn extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  // return new Scaffold(
  // appBar: new AppBar(
  // title: new Text("Sign In"),
  // ),
  // body: new IconButton(icon: new Icon(Icons.arrow_forward), onPressed: (){Navigator.of(context).pushNamed("/mytabs");}),
  // )

