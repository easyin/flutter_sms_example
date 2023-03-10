import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_example/main_screens/login.dart';
import 'package:flutter_sms_example/model/passport.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';
import 'package:flutter_sms_example/services/show_confirm.dart';
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
                  smstasks!.then((value) => {_smsSend(value, context)});
                },
                style: TextButton.styleFrom(
                  iconColor: Colors.white,
                ),
                icon: Icon(Icons.send),
                label:
                Text('????????????', style: TextStyle(color : Colors.white))
            )
          ],
          title: Text('???????????????'),
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
                      if(s_data!.length == 0)
                      {
                        return Center(
                            heightFactor: 15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("????????? ????????? ????????????.", style: TextStyle(color: Colors.black38, fontSize: 20),),
                              Text("EASY-SI?????? ????????? ??????????????????.", style: TextStyle(color: Colors.black38, fontSize: 20),),
                            ],
                          )
                        );
                      }

                      return Container(
                          padding: EdgeInsets.all(20),
                          child:
                          Column(
                            children: [
                              Text("${userinfo!.u_name}?????? ?????? ?????? ???????????????.", style: commonText,),
                              Text("???~ ?????? ????????? ??? ????????????.", style: commonText,),
                            ],
                          )
                      );
                    }

                    index -= 1;
                    var smstask = s_data![index];
                    return ElevatedButton(
                      onLongPress: () {
                        FlutterConfirm(context, "?????? ?????????????????????????", "??? ????????? ????????? ??? ????????????.", (){SmsApiService.removeSmsTask(smstask.no).then((value) => Navigator.pop(context)).whenComplete(() => onRefresh());});
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                children: [
                                  Text("${smstask.receiver_size}??? ????????????", style: TextStyle(fontSize: 25),),
                                  Text("??????????????? ???????????????.",),
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
                        Text("?????? ?????? ???????????? : ${snapshot.data}???", style: commonText,),
                        Text("?????? ???????????? ????????? ???????????????.", style: TextStyle(fontSize: 14, color: Colors.black26),),
                      ],
                    );
                  } else {
                    return Text("????????? ??????????????????.");
                  }
                },
              )
          ),
        );
  }

  Future<bool> _smsSend(smstasks, context) async {
    getSMSPermission();
    var coin = 0;

    Future<void> dosomething() async
    {
      if(smstasks.length > 0)
      {
        for(var smstask in smstasks) {
          FlutterDialog(context, "?????????", "????????? ???????????????. ?????? ????????? ???????????????!", true);

          var recipients = smstask.receivers.toString();

          await SmsApiService.sendingSMS(smstask, recipients)
                  .whenComplete(() => Navigator.pop(context))
                  .then((value) => SmsApiService.setSendFlag(smstask.no).then((value) => onRefresh()));

        }
      }else{

        FlutterDialog(context, "????????????", "????????? ????????? ?????? ???????????????.", false);
      }
    }


    void sendingfunction()
    {
      if(coin > 0){dosomething();}
      else{FlutterDialog(context, "?????? ?????? ??????!", "?????? ?????? ????????? ????????????. ??? ?????? ???????????? ????????? ????????? ?????? ??? ????????? ???????????????!", false);}
    }

    await storage.read(key: "coin")
        .then((value) => coin = int.parse(value.toString()))
        .whenComplete(() => sendingfunction());

    return true;
  }
}

