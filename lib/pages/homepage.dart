import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(size,'assets/product.png','Product', RouteGenerator.product),
              buildItem(size, 'assets/sales.png', 'Sales', RouteGenerator.sales),
              buildItem(size, 'assets/customer.png', 'Customers', RouteGenerator.customers),
            ],
          ),
          SizedBox(height: size.height*0.05,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(size, 'assets/supplier.png', 'Supplier', RouteGenerator.supplier),
              buildItem(size, 'assets/purchase.png', 'Purchase',RouteGenerator.purchase),
              buildItem(size, 'assets/stock.png', 'Stock',RouteGenerator.stock),

            ],
          ),
          SizedBox(height: size.height*0.05,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(size, 'assets/invoice.png', 'Invoice', RouteGenerator.invoice),
              buildItem(size, 'assets/vendor.png', 'Public Vendors', RouteGenerator.publicVendors),
              buildItem(size, 'assets/settings.png', 'Invoice settings',RouteGenerator.addCustomer),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildItem(Size size,String icon, String txt, var routeName){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        child: Container(
          height: size.height/8,
          width: size.width/4,
          //color: Colors.red,
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
