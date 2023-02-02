import 'package:flutter/material.dart';

void FlutterDialog(context, title, msg, bool noclose) {

  Widget buttons = Container();

  if(!noclose) {
    buttons = TextButton(
      child: Text("닫기"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text(title),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg),
              ],
            ),
            actions: [
              buttons
            ],
          );
        });
}