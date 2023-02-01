import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_example/main_screens/login.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';

import '../services/permission_services.dart';

class TaskListViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {return _TLS();}
}

class _TLS extends State<TaskListViewer> {

  Future<List<SmstaskModel>> smstasks = SmsApiService.getSmsTaskList(1);
  Future<void> onRefresh() async {
    smstasks = SmsApiService.getSmsTaskList(1);
    // setState(() { });
  }

  static final storage = FlutterSecureStorage();

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
                onPressed: () {smstasks.then((value) => _smsSend(value));},
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
                      return Row(
                          children: [
                            Text("header!"),
                          ]
                      );
                    }

                    index -= 1;
                    var smstask = s_data![index];
                    return TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(20))
                      ),
                      child: Text(smstask.receivers),
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
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.call),
              Icon(Icons.chat),
              Icon(Icons.home),
            ],
          ),
        )
    );
  }

  void _smsSend(smstasks)
  {
    getSMSPermission();

    for(var smstask in smstasks) {
      var recipients = smstask.receivers.toString();
      SmsApiService.sendingSMS(smstask.msg, recipients.split(";"));
    }
  }
}

