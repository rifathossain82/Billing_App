import 'package:url_launcher/url_launcher.dart';

Future<void> launch_url(String url) async {
  if (!await launch(
    url,
    enableJavaScript: true,
  )) {
    throw 'Could not launch $url';
  }
}