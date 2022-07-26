import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<String> img=[
    'assets/icons/product.png',
    'assets/icons/sales.png',
    'assets/icons/customer.png',
    'assets/icons/supplier.png',
    'assets/icons/due_list.png',
    'assets/icons/stock.png',
    'assets/icons/invoice.png',
    'assets/icons/settings.png',
    'assets/icons/seller.png',
  ];

  List<dynamic> route=[
    RouteGenerator.product,
    RouteGenerator.sales,
    RouteGenerator.customers,
    RouteGenerator.supplier,
    RouteGenerator.due,
    RouteGenerator.stock,
    RouteGenerator.invoice,
    RouteGenerator.invoiceSettings,
    RouteGenerator.seller,
  ];

  List<String> name=[];

  @override
  void didChangeDependencies() {
    name=[
      AppLocalizations.of(context)!.products,
      AppLocalizations.of(context)!.sales,
      AppLocalizations.of(context)!.customer,
      AppLocalizations.of(context)!.supplier,
      AppLocalizations.of(context)!.dueList,
      AppLocalizations.of(context)!.stock,
      AppLocalizations.of(context)!.invoice,
      AppLocalizations.of(context)!.invSettings,
      AppLocalizations.of(context)!.seller,
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: GridView.builder(
            itemCount: img.length,
            padding: EdgeInsets.only(top: size.height*0.1),
            itemBuilder: (context, index) => buildItem(size,img[index], name[index], route[index]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(Size size,String icon, String txt, var routeName){
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: (){
          Get.toNamed(routeName);
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: size.height/8,
          width: size.width/4,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(4)
          ),
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //logo of item
              Expanded(
                flex: 2,
                child: Image.asset(icon,),
              ),

              SizedBox(height: size.height*0.01,),

              //name of item
              Expanded(
                flex: 1,
                child: AutoSizeText(
                    txt,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<String> img=[
    'assets/icons/product.png',
    'assets/icons/sales.png',
    'assets/icons/customer.png',
    'assets/icons/supplier.png',
    //'assets/icons/due_list.png',
    'assets/icons/stock.png',
    'assets/icons/invoice.png',
    'assets/icons/settings.png',
    'assets/icons/seller.png',
  ];

  List<dynamic> route=[
    RouteGenerator.product,
    RouteGenerator.sales,
    RouteGenerator.customers,
    RouteGenerator.supplier,
    //RouteGenerator.due,
    RouteGenerator.stock,
    RouteGenerator.invoice,
    RouteGenerator.invoiceSettings,
    RouteGenerator.seller,
  ];

  var name;

  @override
  void didChangeDependencies() {

    name=[
      AppLocalizations.of(context)!.products,
      AppLocalizations.of(context)!.sales,
      AppLocalizations.of(context)!.customer,
      AppLocalizations.of(context)!.supplier,
      //AppLocalizations.of(context)!.dueList,
      AppLocalizations.of(context)!.stock,
      AppLocalizations.of(context)!.invoice,
      AppLocalizations.of(context)!.invSettings,
      AppLocalizations.of(context)!.seller,
    ];

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: GridView.builder(
            itemCount: img.length,
            itemBuilder: (context, index) => buildItem(size,img[index], name[index], route[index]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(Size size,String icon, String txt, var routeName){
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: (){
          Get.toNamed(routeName);
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: size.height/8,
          width: size.width/4,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(4)
          ),
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(icon,),
              ),
              SizedBox(height: size.height*0.01,),
              Expanded(
                  flex: 1,
                  child: AutoSizeText(
                    txt,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
 */
