import 'package:url_launcher/url_launcher.dart';

void createEmail(String email){
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      'Enter You subject': 'Example Subject & Symbols are allowed!'
    }),
  );

  launch(emailLaunchUri.toString());
}