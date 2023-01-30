import 'package:flutter/material.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/services/permission_services.dart';

import 'model/sms_task_data.dart';
import 'package:flutter_sms_example/main_screens/screen_library.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {return _HomePage();}
}

class _HomePage extends State<HomePage> {
  Future<List<SmstaskModel>> smstasks = SmsApiService.getSmsTaskList(1);

  @override
  void initState() {
    super.initState();
  }

  Future<void> onRefresh() async {
    smstasks = SmsApiService.getSmsTaskList(1);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
            onPressed: () {  },
            icon: Icon(Icons.menu),
          ),
          actions: [
            IconButton(
                onPressed: (){ },
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

