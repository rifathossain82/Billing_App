import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constaints/util/util.dart';
import '../../controller/supplierController.dart';
import '../../model/supplierData.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/decoration/searchTextFieldDecoration_.dart';

class SelectSupplier extends StatefulWidget {
  SelectSupplier({Key? key}) : super(key: key);

  @override
  State<SelectSupplier> createState() => _SelectSupplierState();
}

class _SelectSupplierState extends State<SelectSupplier> {

  TextEditingController searchController=TextEditingController();
  final supplierController=Get.put(SupplierController());
  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<SupplierController>().pageNumber;

  @override
  void initState(){
    scrollIndicator();
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  searchMethod(){
    if(searchController.text.toString().isEmpty){
      supplierController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
      supplierController.supplier.value=[];    //set supplier list empty
      supplierController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
      supplierController.getData();            //call api to load all supplier
    }
    else{
      supplierController.getData(name: searchController.text.toString());      //call api to load supplier by searching
    }
  }

  void scrollIndicator() {
    _scrollController.addListener(
          () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          print('reach to bottom');
          if(!Get.find<SupplierController>().loadedCompleted.value){
            ++supplierController.pageNumber.value;
            supplierController.getData();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectSupplier),
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
              onSubmitted: (val)=>searchMethod(),
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
            child: GetX<SupplierController>(builder: (controller){
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(controller.isLoading.value==false && controller.supplier.isEmpty){
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
                  controller: _scrollController,
                  itemCount: controller.supplier.length+1,
                  itemBuilder: (context, index){
                    if(index==controller.supplier.length &&
                        !Get.find<SupplierController>().loadedCompleted.value){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(index==controller.supplier.length &&
                        Get.find<SupplierController>().loadedCompleted.value){
                      return Container();
                    }
                    else{
                      if(controller.supplier[index].is_active.toString().contains('0')){
                        return Container();
                      }
                      else{
                        return buildSupplier(context, size, controller.supplier[index]);
                      }
                    }
                  },
                );
              }
            }),
            onRefresh: () async {
              searchController.clear();
              searchMethod();
            },
          )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          var result = await Get.toNamed(RouteGenerator.addSupplier);

          //if we add new supplier then refresh the screen
          if(result != null){
            searchMethod();
          }
        },
        child: Icon(Icons.add,color: myWhite,),
        backgroundColor: mainColor,
      ),
    );
  }

  Widget buildSupplier(BuildContext context, Size size, SupplierData data){
    final subTextStyle=TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: textColor2
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            Get.back(result: {'name':'${data.name}', 'id':'${data.id}'});
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText('${data.name}', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700, color: textColor2),),
                AutoSizeText('${data.phone}',style: subTextStyle,),
                AutoSizeText('${data.email}', style: subTextStyle,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
