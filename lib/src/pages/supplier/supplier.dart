import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/model/supplierData.dart';
import 'package:billing_app/src/pages/supplier/supplierDetails.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../controller/supplierController.dart';
import '../../services/createCall.dart';
import '../../widgets/appBar_bg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/decoration/searchTextFieldDecoration_.dart';

class Supplier extends StatefulWidget {
  Supplier({Key? key}) : super(key: key);

  final supplierController=Get.put(SupplierController());

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {

  TextEditingController searchController=TextEditingController();
  ScrollController _scrollController = ScrollController();

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
      RefreshSupplier().refresh();
    }
    else{
      widget.supplierController.getData(name: searchController.text.toString());      //call api to load supplier by searching
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
            ++widget.supplierController.pageNumber.value;
            widget.supplierController.getData();
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
        title: Text(AppLocalizations.of(context)!.supplier),
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
                return const Center(
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
                      return buildSupplier(context, size, controller.supplier[index]);
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

    var status;
    var status_color;
    if(data.is_active.toString().contains('1')){
      status='Active';
      status_color=successColor;
    }
    else{
      status='Inactive';
      status_color=failedColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            Get.to(()=>SupplierDetails(data: data,));
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
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
                SizedBox(width: 16,),

                //call and email part here
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ///active design
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$status', style: TextStyle(color: status_color),),
                    ),
                    IconButton(
                      onPressed: (){
                        createCall('${data.phone}');
                      },
                      icon: Icon(Icons.phone, color: textColor2,)
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RefreshSupplier{
  void refresh(){
    final supplier=Supplier();
    supplier.supplierController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
    supplier.supplierController.supplier.value=[];    //set supplier list empty
    supplier.supplierController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
    supplier.supplierController.getData();            //call api to load all supplier
  }
}
