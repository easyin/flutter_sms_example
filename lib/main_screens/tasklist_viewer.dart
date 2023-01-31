import 'package:flutter/material.dart';
import 'package:flutter_sms_example/services/api_service.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';

class TaskListViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {return _TLS();}
}

class _TLS extends State<TaskListViewer> {

  Future<List<SmstaskModel>> smstasks = SmsApiService.getSmsTaskList(1);
  Future<void> onRefresh() async {
    smstasks = SmsApiService.getSmsTaskList(1);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
    );
  }
}

