import 'package:permission_handler/permission_handler.dart';


getSMSPermission() async{
  var status = await Permission.sms.status;
  if(status.isGranted){
    print('허락됨');
  } else if (status.isDenied){
    print('거절됨');
    Permission.sms.request(); // 허락해달라고 팝업띄우는 코드
  }
}