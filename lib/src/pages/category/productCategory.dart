import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/controller/categoryController.dart';
import 'package:billing_app/src/pages/category/categoryDetails.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../constaints/util/util.dart';
import '../../model/categoryModel.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';

import '../../widgets/decoration/searchTextFieldDecoration_.dart';

class ProductCategory extends StatefulWidget {
  ProductCategory({Key? key}) : super(key: key);

  final categoryController=Get.put(CategoryController());

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {

  TextEditingController searchController=TextEditingController();
  TextEditingController categoryNameController=TextEditingController();
  late FocusNode categoryNameFocusNode;

  List<String> filterItem=[];
  var selectedType='Active';  //to show filtering type
  var filteringType='active';          //to filter category from api, we pass this
  bool categoryStatus=true;

  @override
  void initState() {
    filterItem=[
      'Active',
      'Inactive',
      'Trashed',
    ];
    filteringType=filterItem[0];
    categoryNameFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    categoryNameFocusNode.dispose();
    super.dispose();
  }

  searchMethod(){
    print(filteringType);

    if(searchController.text.toString().isEmpty){
      widget.categoryController.getData(type: filteringType);
    }
    else{
      widget.categoryController.getData(type: filteringType ,name: searchController.text.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.productCategory),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Util().preferredHeight),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (val)=>searchMethod(),
                    onChanged: (val) {
                      if(val.length >= 3){
                        searchMethod();
                      }
                    },
                    decoration: searchTextFieldDecoration_(AppLocalizations.of(context)!.search, searchController, searchMethod),
                  ),
                ),
                SizedBox(width: 4,),
                Expanded(
                  child: buildCategoryFilter(context),
                )
              ],
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: RefreshIndicator(
            child: GetX<CategoryController>(builder: (controller){
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(controller.isLoading.value==false && controller.category.isEmpty){
                return Stack(
                  children: [
                    ListView(),
                    Center(
                      child: ShowNoItem(title: AppLocalizations.of(context)!.noDataFound),
                    )
                  ],
                );
              }
              else{
                return ListView.builder(
                  itemCount: controller.category.length,
                  itemBuilder: (context, index){
                    return buildCategory(context, size, controller.category[index]);
                  },
                );
              }
            }),
            onRefresh: () async {
              searchController.clear();
              widget.categoryController.getData(type: filteringType);
            },
          )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          categoryNameFocusNode.requestFocus();
          showAddCategoryDialog(context);
        },
        child: Icon(Icons.add,color: myWhite,),
        backgroundColor: mainColor,
      ),
    );
  }

  Widget buildCategory(BuildContext context, Size size, CategoryModel data){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            bool isTrashed=false;
            if(filteringType=='trashed'){
              isTrashed=true;
            }
            searchController.clear();
            Get.to(()=>CategoryDetails(data: data, trashed: isTrashed, selectedCategoryType: filteringType.toString(),));
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            height: size.height*0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 5,
                  height: size.height*0.08,
                  decoration: BoxDecoration(
                    color: selectedType==filterItem[0] ? successColor : selectedType==filterItem[1]? warningColor : failedColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: AutoSizeText('${data.name}', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700, color: textColor2),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryFilter(BuildContext context){

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white
        ),
        child: DropdownButtonHideUnderline(
         child: DropdownButton<String>(
           elevation: 0,
           value: selectedType,
           onChanged: (val){
             setState(() {
               selectedType = val!;

               if(selectedType==filterItem[0]){
                 filteringType='active';
               }
               else if(selectedType==filterItem[1]){
                 filteringType='inactive';
               }
               else{
                 filteringType='trashed';
               }

               //to search after changed
               searchMethod();
               print(selectedType);
             });
           },
           items: filterItem.map<DropdownMenuItem<String>>((String val){
             return DropdownMenuItem(
               child: AutoSizeText(val,style: const TextStyle(fontSize: 14),),
               value: val,
             );
           }).toList(),
           dropdownColor: Colors.white,
           borderRadius: BorderRadius.circular(4),
         ),
     ),
      );
    });
  }

  void showAddCategoryDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.addNewCategory,),
            content: SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //textField to input category name
                  TextField(
                    controller: categoryNameController,
                    focusNode: categoryNameFocusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.categoryName,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16,),

                  //switch to input category status
                  /*
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: textColor2.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(AppLocalizations.of(context)!.status)),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Switch(
                                value: categoryStatus,
                                onChanged: (val){
                                  setState(() {
                                    categoryStatus=val;
                                  });
                                }
                            );
                          }),
                      ],
                    ),
                  ),
                   */
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)
              ),
              TextButton(
                  onPressed: ()async{

                    //to close open addCategory dialog
                    Navigator.pop(context);

                    //to show a loader
                    customDialog();

                    var result= await widget.categoryController.addCategory(categoryNameController.text);

                    //to close loader
                    closeDialog();

                    showToastMessage(result);
                    categoryNameController.clear();
                    widget.categoryController.getData();
                  },
                  child: Text(AppLocalizations.of(context)!.add)
              ),
            ],
          );
        });
  }
}