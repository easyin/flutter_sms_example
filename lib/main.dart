import 'package:flutter/material.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/services/permission_services.dart';

import 'model/sms_task_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Future<List<SmstaskModel>> smstasks = SmsApiService.getSmsTaskList(1);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {  },
            icon: Icon(Icons.menu),
          ),
          actions: [
            TextButton(
                onPressed: () {smstasks.then((value) => _testFunction(value));},
                style: TextButton.styleFrom(
                  iconColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.send),
                    Text('발송시작', style: TextStyle(color : Colors.white))
                  ],
                ))
          ],
          title: Text('ddd'),
        ),

        body: FutureBuilder(
          future: smstasks,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var smstask = snapshot.data![index];
                  return TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(50))
                    ),
                    child: Text(smstask.receivers),
                    onPressed: () {  },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  width: 20
                ),
              );
            }
            else if(!snapshot.hasData)
            {
              print(snapshot.toString());
              return Text("Error Occured.");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
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

  void _testFunction(smstasks)
  {
    getSMSPermission();

    for(var smstask in smstasks) {
      var recipients = smstask.receivers.toString();
      SmsApiService.sendingSMS(smstask.msg, recipients.split(";"));
    }
  }
}

