
import 'dart:convert';
import 'package:flutter_sms_example/services/http_fetching_service.dart';
import 'package:flutter_sms_example/model/passport.dart';

class PassportService
{
  final String baseUrl = "https://dev.xn--car-2r7mh0wi12a.com/permitAll/authentifcation";

  Future<Passport> login(id, passwd) async
  {
    Map params = {};
    params['id'] = id;
    params['passwd'] = passwd;
    params['sk'] = "24389hwofivg2478hogewfb";

    String jsonString = await EZFetch().setUrl("$baseUrl/login")
                      .setMethod("post")
                      .setParam(params)
                      .send();

    return Passport.fromJson(jsonDecode(jsonString));
  }
}