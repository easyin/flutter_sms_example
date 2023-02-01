class Passport {
  final String? u_code,
      u_comp,
      u_name,
      u_id,
      u_date,
      u_auth,
      u_email,
      u_tel,
      message;

  Passport.fromJson(Map<String, dynamic> json) :
    u_code = json['u_code'],
    u_comp = json['u_comp'],
    u_name = json['u_name'],
    u_id = json['u_id'],
    u_date = json['u_date'],
    u_auth = json['u_auth'],
    u_email = json['u_email'],
    u_tel = json['u_tel'],
    message = json['message'];
  }