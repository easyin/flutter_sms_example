class SmstaskModel {
  final int receiver_size, no, usercode;
  final String receivers, msg;

  SmstaskModel.fromJson(Map<String, dynamic> json):
    receiver_size = json['receiver_size'],
    no = json['no'],
    usercode = json['usercode'],
    receivers = json['receivers'],
    msg = json['msg'];
}