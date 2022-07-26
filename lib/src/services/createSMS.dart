import 'package:url_launcher/url_launcher.dart';

void createSMS(String number)async{
  var url='sms: ${number}';

  if(await canLaunch(url)){
    await launch(url);
  }
}