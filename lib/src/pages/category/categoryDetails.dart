import 'package:billing_app/src/controller/categoryController.dart';
import 'package:billing_app/src/model/categoryModel.dart';
import 'package:billing_app/src/pages/category/productCategory.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../constaints/colors/AppColors.dart';

class CategoryDetails extends StatefulWidget {
  CategoryDetails({Key? key, required this.data, required this.trashed, required this.selectedCategoryType}) : super(key: key);

  CategoryModel data;
  bool trashed;
  String selectedCategoryType;

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  TextEditingController categoryNameController=TextEditingController();
  bool categoryStatus=true;
  final categoryController=Get.put(CategoryController());

  var id;
  var name;
  var _status;

  final subTextStyle=TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: textColor2
  );

  @override
  void initState() {
    _setData(widget.data);
    super.initState();
  }

  _setData(CategoryModel data){
    setState(() {
      id=data.id;
      name=data.name;

      //set status value
      if(data.isActive!.contains('1')){
        _status='Active';
      }
      else{
        _status='Inactive';
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.productCategory,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: size.height*0.05,),
            buildTitle('Id'),
            buildContainer('$id', size),

            buildTitle('Category Name'),
            buildContainer('$name', size),

            buildTitle('Status'),
            buildContainer('$_status', size),
            SizedBox(height: size.height*0.1,),

            widget.trashed?
            buildRestoreButtons(size)     //restore button for trashed category
                :
            buildButtons(size), //edit and delete button for active and inactive category
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 8, right: 8),
      child: Text(title, style: TextStyle(color: textColor2,),),
    );
  }

  Widget buildContainer(String text, Size size){
    return Container(
      height: size.height*0.08,
      width: size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        //color: textColor2.withOpacity(0.05),
        border: Border.all(color: textColor3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
    );
  }

  Widget buildRestoreButtons(Size size){
    return InkWell(
      onTap: (){
        restoreCategory();
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        alignment: Alignment.center,
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: textColor2.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restore_from_trash,color: textColor2, size: size.height*0.032,),
            SizedBox(width: 8,),
            Text('Restore'),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(Size size){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            showEditCategoryDialog(context);
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            alignment: Alignment.center,
            width: size.width/3,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: textColor2.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit,color: textColor2, size: size.height*0.032,),
                SizedBox(width: 8,),
                Text('Edit'),
              ],
            ),
          ),
        ),
        SizedBox(width: 16,),
        InkWell(
          onTap: (){
            deleteCategory();
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            alignment: Alignment.center,
            width: size.width/3,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: textColor2.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete,color: textColor2, size: size.height*0.032,),
                SizedBox(width: 8,),
                Text('Delete'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void restoreCategory()async{
    //to show a loader
    customDialog();

    var result=await categoryController.restoreCategory(widget.data.id.toString());

    //to close loader
    closeDialog();

    showToastMessage(result);

    if(result=='Category Restored'){
      setState(() {
        widget.trashed=false;

        var category=ProductCategory();
        category.categoryController.getData(type: widget.selectedCategoryType);
      });
    }
  }

  void deleteCategory()async{

    //to show a loader
    customDialog();

    var result= await categoryController.deleteCategory(widget.data.id.toString());

    //to close loader
    closeDialog();

    showToastMessage(result);
    var category=ProductCategory();
    category.categoryController.getData(type: widget.selectedCategoryType);
    Get.back();
  }

  void showEditCategoryDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          categoryNameController.text=widget.data.name!;
          if(widget.data.isActive!.contains('1')){
              categoryStatus=true;
          }
          else{
              categoryStatus=false;
          }
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState){
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.editCategory,),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //textField to input category name
                      TextField(
                        controller: categoryNameController,
                        maxLines: 1,
                        onSubmitted: (val){
                          setState((){
                            print(val);
                            categoryNameController.text=val;
                          });
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.categoryName,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16,),

                      //switch to input category status
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: textColor2.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(AppLocalizations.of(context)!.status)),
                            Switch(
                                value: categoryStatus,
                                onChanged: (val){
                                  setState(() {
                                    categoryStatus=val;
                                  });
                                }
                            )
                          ],
                        ),
                      ),
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

                        //to close open editCategory dialog
                        Navigator.pop(context);

                        //to show a loader
                        customDialog();

                        var result= await categoryController.updateCategory(widget.data.id.toString(), categoryNameController.text, getStatusID(categoryStatus));

                        //to close loader
                        closeDialog();

                        showToastMessage(result);
                        _setData(CategoryModel(id: id, name: categoryNameController.text, isActive: getStatusID(categoryStatus).toString()));
                        var category=ProductCategory();
                        category.categoryController.getData(type: widget.selectedCategoryType);

                      },
                      child: Text(AppLocalizations.of(context)!.ok)
                  ),
                ],
              );
            },
          );
        });
  }


  int getStatusID(bool status){
    if(status==true){
      return 1;
    }
    else{
      return 0;
    }
  }


}
