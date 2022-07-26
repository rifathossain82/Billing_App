import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/controller/reportIssueController.dart';
import 'package:billing_app/src/widgets/myButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constaints/util/util.dart';
import '../../services/closeDialog.dart';
import '../../widgets/customDialog.dart';

class ReportAnIssueScreen extends StatelessWidget {
  ReportAnIssueScreen({Key? key}) : super(key: key);

  TextEditingController subjectController = TextEditingController();
  TextEditingController issueController = TextEditingController();

  final reportIssueController = Get.put(ReportIssueController());
  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text('Report An Issue'),
        foregroundColor: myblack,
        elevation: 0,
        centerTitle: true,
        backgroundColor: myWhite,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12,),
                buildTitle('Subject'),
                buildSubject(),

                SizedBox(height: 12,),
                buildTitle('Issue'),
                buildIssueBody(),

                SizedBox(height: 24,),
                myButton(
                  onTap: (){
                    submitIssue();
                  },
                  buttonText: 'Submit',
                  paddingHorizontal: 0
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitIssue()async{
    var hasInternet = await Util().checkInternet();

    if(hasInternet){
      if (formKey.currentState!.validate()) {

        //show a loader
        customDialog();

        bool result= await reportIssueController.submitIssue(subjectController.text, issueController.text);

        //close the loader
        closeDialog();

        print(result);
        if(result){
          subjectController.text = '';
          issueController.text = '';
        }
      }
    }
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 0, right: 8),
      child: Text(title, style: TextStyle(color: textColor2,),),
    );
  }

  Widget buildSubject(){
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Subject required!';
        }
        else {
          return null;
        }
      },
      controller: subjectController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Enter subject',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildIssueBody(){
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Issue required!';
        }
        else {
          return null;
        }
      },
      controller: issueController,
      maxLines: 7,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Enter issue',
        border: OutlineInputBorder(),
      ),
    );
  }


}
