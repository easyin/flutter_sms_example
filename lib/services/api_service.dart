import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';
import 'package:flutter_sms_example/services/http_fetching_service.dart';
import 'package:http/http.dart' as http;

class SmsApiService{
  static const String baseUrl = "https://easy.xn--car-2r7mh0wi12a.com/permitAll/sms";
  static const storage = FlutterSecureStorage();

  static Future<String> getCustomersTel(String customerCodeList) async{
    Map<String, dynamic> params = {};
    params["customerList"] = customerCodeList;
    params["sk"] = "24389hwofivg2478hogewfb";

    print(params);

    final resultString = await EZFetch().setMethod("post")
                                      .setUrl("https://dev.xn--car-2r7mh0wi12a.com/permitAll/sms/get/customerstel")
                                      .setParam(params)
                                      .send();

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


  static Future<bool> sendingSMS(String message, List<String> allNumbers) async {
      const oneshotLength = 20;
      const delaySeconds = 3;

      var sendedlist = <String>[];
      var tmplist = <String>[];

      doSending(recipients) async{
        await sendSMS(message: message, recipients: recipients, sendDirect: true)
            .catchError((onError) {
          print(onError);
        });
      }

      for(var i=0; i<allNumbers.length; i+=oneshotLength)
      {
        int remaincoins = int.parse(await storage.read(key: "coin") as String);
        var maxTo = allNumbers.length;
        var to = min(maxTo, i+oneshotLength);
        to = min(to,i+remaincoins);

        tmplist = allNumbers.getRange(i, to).toList();
        print(tmplist);

        await doSending(tmplist).then((value) => null).then((value) => {sleep(Duration(seconds: delaySeconds))});
        sendedlist.addAll(tmplist);
        storage.write(key: "coin", value: (remaincoins - (to-i)).toString());

        print("rerun!..");
        print("remaincoin: " + (remaincoins - (to-i)).toString());
      }

      return true;
  }
}