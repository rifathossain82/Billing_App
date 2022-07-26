import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../services/createCall.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/decoration/searchTextFieldDecoration.dart';

class Due extends StatefulWidget {
  const Due({Key? key}) : super(key: key);

  @override
  State<Due> createState() => _DueState();
}

class _DueState extends State<Due> {

  TextEditingController searchController=TextEditingController();
  var searchString='';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dueList),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Util().preferredHeight),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            child: TextField(
              controller: searchController,
              //onSubmitted: searchLocation,
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase().trim();
                });
              },
              decoration: searchTextFieldDecoration(AppLocalizations.of(context)!.customerName, searchController),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index){
            return buildDue(size, index);
          },
        ),
      ),
    );
  }

  Widget buildDue(Size size, int index){

    final subTextStyle=TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: textColor2
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText('Thomas Jack', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, color: textColor2),),
                    AutoSizeText('01882508771',style: subTextStyle,),
                    AutoSizeText('${AppLocalizations.of(context)!.totalAmount}: 10500 ৳ ', style: subTextStyle,),
                    AutoSizeText('${AppLocalizations.of(context)!.due}: 3000 ৳ ', style: subTextStyle.copyWith(color: Colors.red),),
                  ],
                ),
              ),
              SizedBox(width: 16,),

              //call and email part here
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){createCall('1885256220');}, icon: Icon(Icons.phone, color: textColor2,)),
                  IconButton(onPressed: (){Get.toNamed(RouteGenerator.dueDetails);}, icon: Icon(Icons.payment_outlined, color: textColor2,)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
