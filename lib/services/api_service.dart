import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';
import 'package:flutter_sms_example/services/http_fetching_service.dart';
import 'package:http/http.dart' as http;

class SmsApiService{
  static const String baseUrl = "https://easy.xn--car-2r7mh0wi12a.com/permitAll/sms";

  static Future<String> getCustomersTel(String customerCodeList) async{
    Map<String, dynamic> params = {};
    params["customerList"] = customerCodeList;
    Future<String> resultString = (await EZFetch().setMethod("POST")
                                      .setUrl("/permitAll/sms/get/customerstel")
                                      .setParam(params)
                                      .send()) as Future<String>;

    return resultString;
  }

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


  static void sendingSMS(String message, List<String> allNumbers) async {
      const oneshotLength = 20;
      const delaySeconds = 40;
      var tmplist = <String>[];

      doSending(recipients) async{
        await sendSMS(message: message, recipients: recipients, sendDirect: true)
            .catchError((onError) {
          print(onError);
        });
      }

      for(var i=0; i<allNumbers.length; i+=oneshotLength)
      {
        var maxTo = allNumbers.length;
        tmplist = allNumbers.getRange(i, min(maxTo, i+oneshotLength)).toList();
        print(tmplist);

        await doSending(tmplist).then((value) => null).then((value) => sleep(Duration(seconds: delaySeconds)));
        print("rerun!..");
      }
  }
}