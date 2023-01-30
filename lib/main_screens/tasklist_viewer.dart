import 'package:flutter/material.dart';
import 'package:flutter_sms_example/services/main_screens/**.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/services/permission_services.dart';

import 'model/sms_task_data.dart';

class RefreshIndicator extends Widget(
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

