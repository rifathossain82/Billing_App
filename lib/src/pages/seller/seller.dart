import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/model/sellerData.dart';
import 'package:billing_app/src/pages/seller/sellerDetails.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/decoration/searchTextFieldDecoration_.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controller/sellerController.dart';
import '../../widgets/appBar_bg.dart';

class Seller extends StatefulWidget {
  Seller({Key? key}) : super(key: key);

  final sellerController=Get.put(SellerController());

  @override
  State<Seller> createState() => _SellerState();
}

class _SellerState extends State<Seller> {

  TextEditingController searchController=TextEditingController();
  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<SellerController>().pageNumber;

  @override
  void initState() {
    scrollIndicator();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void scrollIndicator() {
    _scrollController.addListener(
          () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          print('reach to bottom');
          if(!Get.find<SellerController>().loadedCompleted.value){
            ++widget.sellerController.pageNumber.value;
            widget.sellerController.getData();
          }
        }
      },
    );
  }

  _searchMethod(){
    if(searchController.text.toString().isEmpty){
      RefreshSeller().refresh();
    }
    else{
      widget.sellerController.getData(name: searchController.text.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.seller),
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
          child: GetX<SellerController>(builder: (controller){
            if(controller.isLoading.value){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(controller.isLoading.value==false && controller.seller.isEmpty){
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
                itemCount: controller.seller.length+1,
                itemBuilder: (context, index){
                  if(index==controller.seller.length &&
                      !Get.find<SellerController>().loadedCompleted.value){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(index==controller.seller.length &&
                      Get.find<SellerController>().loadedCompleted.value){
                    return Container();
                  }
                  else{
                    return buildSeller(size, controller.seller[index]);
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
      floatingActionButton: buildFloatingButton(context),
    );
  }

  Widget buildSeller(Size size, SellerData seller){
    final subTextStyle=TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: textColor2
    );

    var status;
    var status_color;
    if(seller.isActive.toString().contains('1')){
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
            Get.to(()=>SellerDetails(sellerData: seller,));
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText('${seller.name}', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700, color: textColor2),),
                      AutoSizeText('${seller.countryCode}${seller.phone}',style: subTextStyle,),
                      AutoSizeText('${seller.email}', style: subTextStyle,),
                      AutoSizeText('${seller.address}', style: subTextStyle,),
                    ],
                  ),
                ),
                SizedBox(width: 16,),

                //call and email part here
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('$status', style: TextStyle(color: status_color),),
                    ),
                    IconButton(onPressed: (){Get.toNamed(RouteGenerator.sellerHistory);}, icon: Icon(Icons.history, color: textColor2,)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFloatingButton(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
       Get.toNamed(RouteGenerator.addSeller);
      },
      child: Icon(Icons.add, color: myWhite,),
      backgroundColor: mainColor,
      elevation: 0,
    );
  }
}

class RefreshSeller{
  void refresh(){
    final seller=Seller();
    seller.sellerController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
    seller.sellerController.seller.value=[];    //set seller list empty
    seller.sellerController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
    seller.sellerController.getData();            //call api to load all seller
  }
}
