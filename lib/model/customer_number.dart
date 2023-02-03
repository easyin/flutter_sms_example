class CustomerContact {
  final String? c_code, c_tel;

  CustomerContact.fromJson(Map<String, dynamic> json) :
        c_code = json['c_code'],
        c_tel = json['c_tel'];
  }