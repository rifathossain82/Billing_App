import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/controller/customerController.dart';
import 'package:billing_app/src/model/customerData.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../constaints/util/util.dart';
import '../../widgets/appBar_bg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/decoration/searchTextFieldDecoration_.dart';
import '../../widgets/showNoItem.dart';

class SelectCustomer extends StatefulWidget {
  const SelectCustomer({Key? key}) : super(key: key);

  @override
  State<SelectCustomer> createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {

  final customerController=Get.put(CustomerController());
  TextEditingController searchController=TextEditingController();

  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<CustomerController>().pageNumber;

  _searchMethod(){
    if(searchController.text.toString().isEmpty){
      customerController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
      customerController.customer.value=[];    //set customer list empty
      customerController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
      customerController.getData();            //call api to load all customer
    }
    else{
      customerController.getData(name: searchController.text.toString());
    }
  }

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

  void scrollIndicator() {
    _scrollController.addListener(
          () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          print('reach to bottom');
          if(!Get.find<CustomerController>().loadedCompleted.value){
            ++customerController.pageNumber.value;
            customerController.getData();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customer+" "+AppLocalizations.of(context)!.list),
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
              onSubmitted: (val)=>_searchMethod(),
              onChanged: (val) {
                if(val.length >= 3){
                  _searchMethod();
                }
              },
              decoration: searchTextFieldDecoration_(AppLocalizations.of(context)!.search, searchController, _searchMethod),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: RefreshIndicator(
            child: GetX<CustomerController>(builder: (controller){
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(controller.isLoading.value==false && controller.customer.isEmpty){
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
                  itemCount: controller.customer.length+1,
                  itemBuilder: (context, index){
                    if(index==controller.customer.length &&
                        !Get.find<CustomerController>().loadedCompleted.value){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(index==controller.customer.length &&
                        Get.find<CustomerController>().loadedCompleted.value){
                      return Container();
                    }
                    else{
                      if(controller.customer[index].is_active.toString().contains('0')){
                        return Container();
                      }
                      else{
                        return buildCustomer(size, controller.customer[index]);
                      }
                    }
                  },
                );
              }
            }),
            onRefresh: () async {
              searchController.clear();
              _searchMethod();
            },
          )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
         var result = await Get.toNamed(RouteGenerator.addCustomer);
         if(result != null){
           _searchMethod();
         }
        },
        child: Icon(Icons.add,color: myWhite,),
        backgroundColor: mainColor,
      ),
    );
  }

  Widget buildCustomer(Size size, CustomerData customer){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            Get.back(result: customer);
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
             // color: myblack.withOpacity(0.03)
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText('${customer.name}',style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w600),),
                SizedBox(height: size.height*0.01,),
                AutoSizeText('${customer.phone}',style: TextStyle(color: Colors.black38,fontSize: 15,),),
                AutoSizeText('${customer.address}',style: TextStyle(color: Colors.black38, fontSize: 15),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
