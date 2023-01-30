import 'dart:convert';

import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';
import 'package:http/http.dart' as http;

class SmsApiService{
  static const String baseUrl = "https://dev.xn--car-2r7mh0wi12a.com/permitAll/sms";

  static Future<List<SmstaskModel>> getSmsTaskList(usercode) async{
    List<SmstaskModel> taskInstances = [];
    final url = Uri.parse('$baseUrl/get/tasklist?usercode=$usercode');
    print(url.toString());

    final response = await http.get(url);
    print(response.statusCode);
    print("response is : " + response.body);

    if(response.statusCode == 200){
      final List<dynamic> smstasks = jsonDecode(response.body);

      for(var smstask in smstasks){
        print("smsTask : $smstask");
        taskInstances.add(SmstaskModel.fromJson(smstask));
      }

      return taskInstances;
    }

    throw Error();
  }


  static void sendingSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
        .catchError((onError) {
          print(onError);
        });
    print(_result);
  }
}