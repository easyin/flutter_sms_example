import 'package:flutter/material.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/services/permission_services.dart';
import 'package:flutter_sms_example/main_screens/screen_library.dart';
import 'model/sms_task_data.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {return _HomePage();}
}

class _HomePage extends State<HomePage> {
  late TaskListViewer _taskListViewer;
  late Widget _screen;

  _HomePage()
  {
    _taskListViewer = TaskListViewer();
    _screen = _taskListViewer;
  }


  late Future<List<SmstaskModel>> smstasks;

  @override
  void initState() {
    super.initState();
    smstasks = SmsApiService.getSmsTaskList(1);
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

        body: _screen,

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

