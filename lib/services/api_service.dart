import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_example/model/customer_number.dart';
import 'package:flutter_sms_example/model/sms_task_data.dart';
import 'package:flutter_sms_example/services/http_fetching_service.dart';
import 'package:http/http.dart' as http;

class SmsApiService{
  static const String baseUrl = "https://dev.xn--car-2r7mh0wi12a.com/permitAll/sms";
  static const storage = FlutterSecureStorage();

  static Future<void> removeSmsTask(smsTaskid) async
  {
    Map<String, String> params = {};
    params["smstaskid"] = smsTaskid.toString();
    params["sk"] = "24389hwofivg2478hogewfb";

    print(params);

    await EZFetch().setMethod("post")
        .setUrl("https://dev.xn--car-2r7mh0wi12a.com/permitAll/sms/remove")
        .setParam(params)
        .send();
  }

  static Future<String> setSendFlag(smstaskid) async
  {
    print("${smstaskid.toString()} <<---------- smstaskid");

    Map<String, dynamic> params = {};
    params["smstaskid"] = smstaskid.toString();
    params["sk"] = "24389hwofivg2478hogewfb";

    print(params);

    final resultString = await EZFetch().setMethod("post")
        .setUrl("https://dev.xn--car-2r7mh0wi12a.com/permitAll/sms/set/sendflag")
        .setParam(params)
        .send();

    return resultString;
  }


  static Future<String> getCustomersTel(String customerCodeList) async{
    Map<String, dynamic> params = {};
    params["customerList"] = customerCodeList;
    params["sk"] = "24389hwofivg2478hogewfb";

    print(params);

    final resultString = await EZFetch().setMethod("post")
                                      .setUrl("https://dev.xn--car-2r7mh0wi12a.com/permitAll/sms/get/customerstel")
                                      .setParam(params)
                                      .send();

    print("resultString : $resultString");
    return resultString;
  }

  static Future<List<SmstaskModel>> getSmsTaskList(usercode) async{
    List<SmstaskModel> taskInstances = [];

    Map<String, dynamic> params = {};
    params["usercode"] = usercode.toString();
    params["sk"] = "24389hwofivg2478hogewfb";

    print(params);

    final resultString = await EZFetch().setMethod("post")
                                  .setUrl("$baseUrl/get/tasklist")
                                  .setParam(params)
                                  .send();

    final List<dynamic> smstasks = jsonDecode(resultString);

    for(var smstask in smstasks){
      taskInstances.add(SmstaskModel.fromJson(smstask));
    }

    return taskInstances;


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

  static Future<List<CustomerContact>> getContacts(recipients) async {
    List<dynamic> cclistTmp = [];
    List<CustomerContact> cclist = [];
    await SmsApiService.getCustomersTel(recipients).then((value) => cclistTmp = jsonDecode(value));
    for(dynamic obj in cclistTmp) { cclist.add(CustomerContact.fromJson(obj)); }

    return cclist;
  }


  static Future<bool> sendingSMS(smstask, recipients) async {
      List<CustomerContact> cclist = [];

      String smstaskid = smstask.no.toString();
      String message = smstask.msg;

      const oneshotLength = 20;
      const delaySeconds = 10;

      var sendedlist = <String>[];
      var tmplist = <CustomerContact>[];

      Future<void> sendActionStart(List<CustomerContact> cclist) async {
        for(var i=0; i<cclist.length; i+=oneshotLength) {
          int remaincoins = int.parse(await storage.read(key: "coin") as String);
          var maxTo = cclist.length;
          var to = min(maxTo, i+oneshotLength);
          to = min(to,i+remaincoins);

          var tmpCodeList = <String>[];
          var tmpNumberList = <String>[];
          tmplist = cclist.getRange(i, to).toList(); //part of cclist (CustomerContact Obj)

          for(CustomerContact cc in tmplist) {
            tmpCodeList.add(cc.c_code.toString());
            tmpNumberList.add(cc.c_tel.toString());
          }

          print("tmplist $tmplist");
          print("tmpNumberList $tmpNumberList");
          print("tmpCodeList $tmpCodeList");

          void afterSending()
          {
            sendedlist.addAll(tmpCodeList);
            storage.write(key: "coin", value: (remaincoins - (to-i)).toString());
          }

          doSending(recipients) async{
            await sendSMS(message: message, recipients: recipients, sendDirect: true)
                .catchError((onError) {
              print(onError);
            });
          }

          await doSending(tmpNumberList).then((value)=>afterSending()).whenComplete(() => sleep(Duration(seconds: delaySeconds)));

          print("rerun!..");
          print("remaincoin: " + (remaincoins - (to-i)).toString());

        }
      }
      
      Future<void> sendToServerAltRecipientsList() async{
        print("subtract started");
        List<String> A = recipients.toString().split(",");
        List<String> B = sendedlist;

        List<String> AsubB = A.toSet().difference(B.toSet()).toList();

        void doSendingToServer()
        {
          // EZFetch().setMethod("POST")
          //     .setUrl()
          //     .setParam()
          //     .send();
        }

        if(AsubB.isNotEmpty) {
          storage.read(key: "passport").then((value) => null);
        }
      }

      await getContacts(recipients).then((value) => sendActionStart(value).whenComplete(() => sendToServerAltRecipientsList()));
      return true;
  }
}