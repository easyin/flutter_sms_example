import 'package:flutter/material.dart';

void FlutterConfirm(context, title, msg, successfunc) {

  Widget buttons = Container();
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
              TextButton(
                  onPressed:() { Navigator.pop(context);},
                  child: Text("취소"),
              ),
              TextButton(
                  onPressed: successfunc,
                  child: Text("삭제하기", style: TextStyle(color: Colors.red),),
              )
            ],
          );
        });
}