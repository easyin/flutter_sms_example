
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_example/services/http_fetching_service.dart';
import 'package:flutter_sms_example/model/passport.dart';

class PassportService
{
  static final storage = FlutterSecureStorage();
  final String baseUrl = "https://easy.xn--car-2r7mh0wi12a.com/permitAll/authentifcation";

  Future<Passport> login(id, passwd) async
  {
    Map params = {};
    params['id'] = id;
    params['passwd'] = passwd;
    params['sk'] = "24389hwofivg2478hogewfb";

    try
    {
      String jsonString = await EZFetch().setUrl("$baseUrl/login")
                        .setMethod("post")
                        .setParam(params)
                        .send();

      storage.write(key: "passport", value: jsonString);
      return Passport.fromJson(jsonDecode(jsonString));

    } catch(e) {
      return Passport.fromJson(jsonDecode('{"message":"ezsi_returns_error"}'));
    }
  }
}