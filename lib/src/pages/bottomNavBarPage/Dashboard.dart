import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/controller/dashboardController.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controller/currencyController.dart';
import '../../widgets/showNoItem.dart';

class Dashboard extends StatefulWidget {

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final dashboardController = Get.put(DashboardController());
  var currency=Get.find<CurrencyController>().currency;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: RefreshIndicator(
            child: GetX<DashboardController>(builder: (controller){
              if(controller.isLoading.value){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(controller.isLoading.value==false && controller.dashboardData.isEmpty){
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
                return ListView(
                  children: [
                    SizedBox(height: 10,),
                    buildItemCard(size, AppLocalizations.of(context)!.totalCustomer, '${controller.dashboardData[0].customer}'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalSupplier, '${controller.dashboardData[0].supplier}'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalSeller, '${controller.dashboardData[0].seller}'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalProductCategory, '${controller.dashboardData[0].category}'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalProduct,'${controller.dashboardData[0].products}'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalSale,'${controller.dashboardData[0].sales}'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalSalesAmount, '${controller.dashboardData[0].saleAmount} $currency'),
                    buildItemCard(size, AppLocalizations.of(context)!.totalStock,'${controller.dashboardData[0].totalStock} $currency'),
                  ],
                );
              }
            }),
            onRefresh: () async {
              dashboardController.getData();
            },
          )
      ),
    );
  }

  Widget buildItemCard(Size size, String name, String amount){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
      child: Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4)
          ),
          height: size.height*0.11,
          child: Row(
            children: [

              //title of item
              Expanded(
                  child: AutoSizeText(
                    name,
                    style: TextStyle(color: textColor2),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  )
              ),

              //amount of item
              Expanded(
                  child: AutoSizeText(
                    amount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor2
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
