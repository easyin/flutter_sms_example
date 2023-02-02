import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_example/main_screens/login.dart';
import 'package:flutter_sms_example/model/passport.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';
import 'package:flutter_sms_example/services/http_fetching_service.dart';
import 'package:flutter_sms_example/services/show_dialog.dart';

import '../services/permission_services.dart';

class TaskListViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {return _TLS();}
}

class _TLS extends State<TaskListViewer> {

  Passport? userinfo;
  static final storage = FlutterSecureStorage();
  Future<List<SmstaskModel>>? smstasks;

  Future<void> onRefresh() async {
    smstasks = SmsApiService.getSmsTaskList(userinfo!.u_code);
    setState(() { });
  }

  TextStyle commonText = TextStyle(fontSize: 20);

  @override
  void initState() {
    storage.read(key: "passport")
        .then((value) => userinfo = Passport.fromJson(jsonDecode(value.toString())))
        .whenComplete(() => onRefresh());

    super.initState();
  }


  void logout(context)
  {
    storage.delete(key: "passport");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
            onPressed: () {  },
            icon: Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: (){ logout(context);},
              icon: Icon(Icons.logout),
            ),
            IconButton(
              onPressed: () {
                smstasks = SmsApiService.getSmsTaskList(1);
                setState(() { });
              },
              icon: Icon(Icons.refresh),
            ),
            TextButton.icon(
                onPressed: () {
                  smstasks!.then((value) => _smsSend(value, context));
                },
                style: TextButton.styleFrom(
                  iconColor: Colors.white,
                ),
                icon: Icon(Icons.send),
                label:
                Text('발송시작', style: TextStyle(color : Colors.white))
            )
          ],
          title: Text('EZSI_SMS'),
        ),

        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: FutureBuilder(
            future: smstasks,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                var s_data = snapshot.data;
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: s_data == null ? 1 : s_data!.length + 1,
                  itemBuilder: (context, index) {
                    if(index == 0)
                    {
                      return Container(
                          padding: EdgeInsets.all(20),
                          child: Text("${userinfo!.u_name}님의 발송 대기 목록입니다.", style: commonText,),
                      );
                    }

                    index -= 1;
                    var smstask = s_data![index];
                    return ElevatedButton(
                      onLongPress: () { },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                children: [
                                  Text("${smstask.receiver_size}명 발송대기", style: TextStyle(fontSize: 25),),
                                  Text("직접추가한 내용입니다.",),
                                ],
                              ),
                          ),
                          Icon(Icons.arrow_circle_right),
                        ]),
                      onPressed: () {  },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
              }

              else if(snapshot.hasError)
              {
                print(snapshot.toString());
                return Text("Error Occured.");
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          height: 70,
          child: FutureBuilder(
                future: storage.read(key: "coin"),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if(snapshot.hasData)
                  {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("현재 남은 발송횟수 : ${snapshot.data}건", style: commonText,),
                        Text("모두 소진하면 다음날 충전됩니다.", style: TextStyle(fontSize: 14, color: Colors.black26),),
                      ],
                    );
                  } else {
                    return Text("오류가 발생했습니다.");
                  }
                },
              )
          ),
        );
  }

  void _smsSend(smstasks, context) async {
    getSMSPermission();
    var coin = 0;

    void _dosomething() async
    {
      FlutterDialog(context, "전송중", "전송을 시작합니다. 절대 어플을 끄지마세요!", true);

      for(var smstask in smstasks) {
        var recipients = smstask.receivers.toString();
        await SmsApiService.getCustomersTel(recipients)
            .then((value) => {SmsApiService.sendingSMS(smstask.msg, value.split(";"))
            .whenComplete(() => setState((){Navigator.pop(context);}))});
      }
    }

    storage.read(key: "coin")
        .then((value) => coin = int.parse(value.toString()))
        .whenComplete(() => {if(coin > 0){ _dosomething()}});
  }
}

