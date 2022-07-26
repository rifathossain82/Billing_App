import 'package:url_launcher/url_launcher.dart';

void createCall(String number)async{
  var url='tel: ${number}';

  if(await canLaunch(url)){
  await launch(url);
  }
}