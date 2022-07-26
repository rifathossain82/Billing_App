import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/controller/countryCodeController.dart';
import 'package:billing_app/src/model/countryCodeData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/customerController.dart';
import 'customScrollBehavior/myBehavior.dart';
import 'decoration/searchTextFieldDecoration_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future SelectCountryCode(Size size, BuildContext context){

  final countryCodeController=Get.put(CountryCodeController());
  countryCodeController.getData();
  TextEditingController searchController=TextEditingController();

  searchMethod(){
    print(searchController.text.toString());

    if(searchController.text.toString().isEmpty){
      countryCodeController.getData();
    }
    else{
      countryCodeController.getData(name: searchController.text.toString());
    }
  }

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
    ),
    builder: (context){
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.only(top: 16),
              height: size.height*0.8,    //size of bottom sheet
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //heading and close button
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          Get.back();
                        },
                        icon: Icon(Icons.close, color: textColor2,),
                      ),
                      Text('Select Your Country', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                    ],
                  ),
                  Divider(
                    height: 0,
                  ),
                  SizedBox(height: 16,),

                  //search textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (val)=>searchMethod(),
                      decoration: searchTextFieldDecoration_(AppLocalizations.of(context)!.search, searchController, searchMethod),
                    ),
                  ),

                  //here is all country code
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: RefreshIndicator(
                        child: GetX<CountryCodeController>(builder: (controller){
                          if(controller.isLoading.value){
                            return Center(
                              child: Image.asset('assets/icons/loading.gif'),
                            );
                          }
                          else if(controller.isLoading.value==false && controller.countryCode.isEmpty){
                            return Stack(
                              children: [
                                ListView(),
                                Center(
                                  child: Text('No Code available'),
                                )
                              ],
                            );
                          }
                          else{
                            return ListView.builder(
                              itemCount: controller.countryCode.length,
                              itemBuilder: (context, index){
                                return buildCountyCodeTile(data: controller.countryCode[index],);
                              },
                            );
                          }
                        }),
                        onRefresh: () async {
                          //searchController.clear();
                          countryCodeController.getData();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    },
  );
}


class buildCountyCodeTile extends StatelessWidget {
  buildCountyCodeTile({Key? key, required this.data}) : super(key: key);

  CountryCodeData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Get.back(result: data);
      },
      title: Row(
        children: [
          Text(
            data.countryName.toString(),
          ),
          SizedBox(width: 8,),
          Text(
            '(${data.countryCode})',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

