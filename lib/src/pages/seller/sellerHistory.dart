import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/constaints/strings/AppStrings.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../widgets/decoration/dateTextFieldDecoration.dart';

class SellerHistory extends StatefulWidget {
  const SellerHistory({Key? key}) : super(key: key);

  @override
  State<SellerHistory> createState() => _SellerHistoryState();
}

class _SellerHistoryState extends State<SellerHistory> {


  TextEditingController monthController=TextEditingController();
  TextEditingController yearController=TextEditingController();
  late FixedExtentScrollController monthScrollController;
  late FixedExtentScrollController yearScrollController;

  //for month picker
  int monthIndex=0;
  int yearIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    monthScrollController=FixedExtentScrollController(initialItem: monthIndex);
    yearScrollController=FixedExtentScrollController(initialItem: yearIndex);
    monthController.text=months[monthIndex];
    yearController.text=years[yearIndex];

    DateTime date=_parseDateStr('25-03-2020');
    print(date.year);

  }

  DateTime _parseDateStr(String inputString) {
    DateFormat format = DateFormat('dd-MM-yyyy');
    return format.parse(inputString);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    monthController.dispose();
    yearController.dispose();
    monthScrollController.dispose();
    yearScrollController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myWhite,
        foregroundColor: myblack,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.sellerReport,),
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: size.height*0.02),
          buildMonthYear(size),
          SizedBox(height: size.height*0.02),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index){
                  return buildCard(size);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMonthYear(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.1,
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                ///month ui here
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: (){
                      monthScrollController.dispose();
                      monthScrollController=FixedExtentScrollController(initialItem: monthIndex);
                      buildBottomSheet(size, context, buildMonthPicker(size));
                    },
                    controller: monthController,
                    readOnly: true,
                    style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.black54),
                    decoration: dateTextFieldDecoration(AppLocalizations.of(context)!.month),
                  ),
                ),
                SizedBox(width: 16,),

                ///year ui here
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: (){
                      yearScrollController.dispose();
                      yearScrollController=FixedExtentScrollController(initialItem: yearIndex);
                      buildBottomSheet(size, context, buildYearPicker(size));
                    },
                    controller: yearController,
                    readOnly: true,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.black54),
                    decoration: dateTextFieldDecoration(AppLocalizations.of(context)!.year),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCard(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        elevation: 0,
        color: myblack.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: AutoSizeText('March 2020', style: TextStyle(color: Colors.black54,fontSize: 18, fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: size.height*0.02,),
              buildRowItem(AppLocalizations.of(context)!.salesInCash, '50,000.00'),
              buildRowItem(AppLocalizations.of(context)!.salesInCredit, '5000.00'),
              buildRowItem(AppLocalizations.of(context)!.salesInCardBankCheque, '30,000.00'),
              Divider(),
              buildRowItem(AppLocalizations.of(context)!.total, '85,000.00'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRowItem(String name, String amount){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        children: [
          AutoSizeText('${name}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),),
          Spacer(),
          AutoSizeText('${amount}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }

  Future buildBottomSheet(Size size, BuildContext context, Widget child){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return SizedBox(
            height: size.height*0.5,
            child: Column(
              children: [
                Expanded(child: child),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Ok')
                )
              ],
            )
        );
      },
    );
  }

  Widget buildMonthPicker(Size size){
    return SizedBox(
      height: size.height*0.4,
      child: StatefulBuilder(
        builder: (context, setState) {
          return CupertinoPicker(
            scrollController: monthScrollController,
            itemExtent: size.height*0.08,
            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: mainColor.withOpacity(0.2),
            ),
            looping: true,
            children: List.generate(months.length, (index){
              final isSelected=this.monthIndex==index;
              final month=months[index];
              final color=isSelected? mainColor : Colors.black;

              return Center(
                child: Text(
                  months[index],
                  style: TextStyle(color: color),
                ),
              );
            }),
            onSelectedItemChanged: (value){
              setState(() {
                monthIndex=value;
              });

              final month=months[monthIndex];
              monthController.text=month;
            },
          );
        }),
      );
  }

  Widget buildYearPicker(Size size){
    return SizedBox(
      height: size.height*0.4,
      child: StatefulBuilder(
          builder: (context, setState) {
            return CupertinoPicker(
              scrollController: yearScrollController,
              itemExtent: size.height*0.08,
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: mainColor.withOpacity(0.2),
              ),
              looping: true,
              children: List.generate(years.length, (index){
                final isSelected=this.yearIndex==index;
                final color=isSelected? mainColor : Colors.black;

                return Center(
                  child: Text(
                    years[index],
                    style: TextStyle(color: color),
                  ),
                );
              }),
              onSelectedItemChanged: (value){
                setState(() {
                  yearIndex=value;
                });

                final year=years[yearIndex];
                yearController.text=year;
              },
            );
          }),
    );
  }


}
