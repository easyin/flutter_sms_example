import 'dart:html';

import 'package:http/http.dart' as http;

class EZFetch
{
  Uri url = Uri();
  String method = "get";
  Map params = {};
  Map<String, String> header = {};

  EZFetch setHeader(Map<String,String> header)
  {
    this.header = header;
    return this;
  }

  EZFetch setParam(Map params)
  {
    this.params = params;
    return this;
  }

  EZFetch setMethod(String method)
  {
    this.method = method;
    return this;
  }
  EZFetch setUrl(String url)
  {
    this.url = Uri.parse(url);
    return this;
  }

  Future<String> send() async {
    var response = await http.get(this.url);
    switch(method)
    {
      case "get" : response = await http.get(this.url, headers: this.header); break;
      case "post" : response = await http.post(this.url, headers : header, body : params); break;
      default: throw Exception("EZFETCHING : method isn't available");
    }

    if(response.statusCode == 200)
    {
      return response.body;
    }

    else
    {
      var errorcode = response.statusCode;
      var why = response.reasonPhrase;
      throw Exception("EZFETCHING : httpscode = $errorcode, $why");
    }
  }
}