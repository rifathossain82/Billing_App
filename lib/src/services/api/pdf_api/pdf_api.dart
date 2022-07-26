import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    //savePDF(url, invoiceName, urlList!, nameList!);
    await OpenFile.open(url);
  }


}

// savePDF(String url, String invoiceName, List<String> urlList, List<String> nameList) async {
//
//   List<String> invoiceUrlList=[];
//   List<String> invoiceNameList=[];
//
//   invoiceUrlList.addAll(urlList);
//   invoiceNameList.addAll(nameList);
//
//   invoiceUrlList.add(url);
//   invoiceNameList.add(invoiceName);
//
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   sharedPreferences.setStringList('invoiceUrlList', invoiceUrlList);
//   sharedPreferences.setStringList('invoiceNameList', invoiceNameList);
// }
