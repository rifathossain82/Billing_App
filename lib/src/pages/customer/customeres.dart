import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/customerController.dart';
import 'package:billing_app/src/model/customerData.dart';
import 'package:billing_app/src/pages/customer/detailsCustomer.dart';
import 'package:billing_app/src/services/createCall.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../widgets/appBar_bg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';

import '../../widgets/decoration/searchTextFieldDecoration_.dart';

class Customers extends StatefulWidget {
  Customers({Key? key}) : super(key: key);

  final customerController=Get.put(CustomerController());

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

  TextEditingController searchController=TextEditingController();
  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<CustomerController>().pageNumber;

  _searchMethod(){
    if(searchController.text.toString().isEmpty){
      var refreshCustomer=RefreshCustomer();
      refreshCustomer.refresh();
    }
    else{
      widget.customerController.getData(name: searchController.text.toString());
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
            ++widget.customerController.pageNumber.value;
            widget.customerController.getData();
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
                      return buildCustomer(context, size, controller.customer[index]);
                    }
                  },
                );
              }
            }),
            onRefresh: () async {
              searchController.clear();
              _searchMethod();
            },
          ),
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

  Widget buildCustomer(BuildContext context, Size size, CustomerData data){
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
            Get.to(()=>DetailsCustomer(customer: data,));
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

class RefreshCustomer{
  void refresh(){
    final customer=Customers();
    customer.customerController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
    customer.customerController.customer.value=[];    //set customer list empty
    customer.customerController.loadedCompleted(false);      //set loading true as a result we can show a loader when we will refresh
    customer.customerController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
    customer.customerController.getData();            //call api to load all customer
  }
}