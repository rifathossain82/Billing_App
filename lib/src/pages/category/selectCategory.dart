import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/model/categoryModel.dart';
import 'package:billing_app/src/widgets/decoration/searchTextFieldDecoration_.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../constaints/util/util.dart';
import '../../controller/categoryController.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/showToastMessage.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {

  TextEditingController searchController=TextEditingController();
  TextEditingController categoryNameController=TextEditingController();
  final categoryController=Get.put(CategoryController());

  bool categoryStatus=true;
  late FocusNode categoryNameFocusNode;

  @override
  void initState() {
    categoryNameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    categoryNameController.dispose();
    categoryNameFocusNode.dispose();
    super.dispose();
  }

  searchMethod(){
    if(searchController.text.toString().isEmpty){
      categoryController.getData(type: 'Active');
    }
    else{
      categoryController.getData(type: 'Active' ,name: searchController.text.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectCategory),
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
              onSubmitted: searchMethod(),
              onChanged: (val) {
                if(val.length >= 3){
                  searchMethod();
                }
              },
              decoration: searchTextFieldDecoration_(AppLocalizations.of(context)!.search, searchController, searchMethod),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: RefreshIndicator(
            child: GetX<CategoryController>(builder: (controller){
              if(controller.isLoading.value){
                return const Center(
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
                    return buildCategory(size, controller.category[index]);
                  },
                );
              }
            }),
            onRefresh: () async {
              searchController.clear();
              categoryController.getData();
              categoryController.isLoading(true);
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

  Widget buildCategory(Size size, CategoryModel data){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            Get.back(result: {'name':'${data.name}', 'id':'${data.id}'});
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
                      color: data.isActive.toString()=='1' ? Colors.green : Colors.red,
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
                    maxLines: 1,
                    focusNode: categoryNameFocusNode,
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
                    var result= await categoryController.addCategory(categoryNameController.text);
                    showToastMessage(result);
                    categoryController.getData();
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.add)
              ),
            ],
          );
        });
  }

}