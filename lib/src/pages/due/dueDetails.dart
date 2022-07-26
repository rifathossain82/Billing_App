import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constaints/colors/AppColors.dart';

class DueDetails extends StatefulWidget {
  const DueDetails({Key? key}) : super(key: key);

  @override
  State<DueDetails> createState() => _DueDetailsState();
}

class _DueDetailsState extends State<DueDetails> {
  late Icon customIcon;
  Widget customAppbar=Text('Due List');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    customIcon= Icon(Icons.search);
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: customIcon.icon==Icon(Icons.search)? Text(AppLocalizations.of(context)!.dueList) : customAppbar ,
        foregroundColor: myblack,
        elevation: 0,
        centerTitle: true,
        backgroundColor: myWhite,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                if(customIcon.icon == Icons.search){
                  customIcon=Icon(Icons.close);
                  customAppbar=TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    cursorColor: textColor2,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.invoiceNumber
                    ),
                  );
                }
                else{
                  customIcon=Icon(Icons.search);
                  customAppbar= Text(AppLocalizations.of(context)!.dueList);
                }
              });
            },
            icon: customIcon
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index){
            return buildSingleDue(size, index);
          },
        ),
      ),
    );
  }

  Widget buildSingleDue(Size size, int index){

    final subTextStyle=TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: textColor2
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText('INV1002', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, color: textColor2),),
              AutoSizeText('24-03-2022',style: subTextStyle,),
              AutoSizeText('${AppLocalizations.of(context)!.totalAmount}: 1500 ৳ ', style: subTextStyle,),
            ],
          ),
        ),
      ),
    );
  }
}
