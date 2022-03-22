import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/constaints/strings/AppStrings.dart';
import 'package:billing_app/widgets/myDropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/appBar_bg.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  TextEditingController searchController=TextEditingController();
  TextEditingController customerController=TextEditingController();
  var searchString='';
  DateTime date1=DateTime.now();
  DateTime date2=DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerController.text=customerList[0];
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    //onSubmitted: searchLocation,
                    onChanged: (value) {
                      setState(() {
                        searchString = value.toLowerCase().trim();
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                            BorderSide(color: Colors.transparent, width: 0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                            BorderSide(color: Colors.transparent, width: 0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                            BorderSide(color: Colors.transparent, width: 0)
                        )
                    ),
                  ),
                ),
                IconButton(onPressed: () {
                  buildBottomSheet(size);
                }, icon: Icon(Icons.filter_list, color: myWhite,size: 40,))
              ],
            ),
          ),
        ),
      ),
      body: buildSalesItem(),
    );
  }

  Future buildBottomSheet(Size size){
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCustomer(size),
            SizedBox(height: size.height*0.02,),
            buildDate(size),
            SizedBox(height: size.height*0.05,),
            buildButton(size),
          ],
        );
      },
    );
  }

  Widget buildCustomer(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          readOnly: true,
          controller: customerController,
          decoration: InputDecoration(
            labelText: 'Customer',
            suffix: myDropDown(customerList, '', (val) {
              setState(() {
                customerController.text=val;
              });
            }),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildDate(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: (){
                  changeDate1(size);
                },
                child: Container(
                  height: size.height*0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: mainColor.withOpacity(0.2),
                  ),
                  child: Text('${date1.day} - ${date1.month} - ${date1.year}', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(child: Text('To',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),))
            ),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: (){
                  changeDate2(size);
                },
                child: Container(
                  height: size.height*0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: mainColor.withOpacity(0.2),
                  ),
                  child: Text('${date2.day} - ${date2.month} - ${date2.year}', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          height: size.height*0.07,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: mainColor,
          ),
          child: Text('OK',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: myWhite),),
        ),
      ),
    );
  }

  Widget buildSalesItem(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          title: Text('INV1002'),
          subtitle: Text('Total : 900 tk'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('21-03-2022',style: TextStyle(fontSize: 16,color: mainColor)),
              Text('Rahim Miayh',style: TextStyle(fontSize: 12,color: mainColor)),
            ],
          ),
        ),
      ),
    );
  }

  void changeDate1(Size size)async{
    DateTime? newDate1=await showDatePicker(
        context: context,
        initialDate: date1,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100)
    );

    if(newDate1==null) return;
    setState(() {
      date1=newDate1;
      Navigator.pop(context);
      buildBottomSheet(size);
    });
  }

  void changeDate2(Size size)async{
    DateTime? newDate2=await showDatePicker(
        context: context,
        initialDate: date2,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100)
    );

    if(newDate2==null) return;
    setState(() {
      date1=newDate2;
      Navigator.pop(context);
      buildBottomSheet(size);
    });
  }

}
