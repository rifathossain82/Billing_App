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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(size,'assets/product_icon.png','Product', RouteGenerator.product),
              buildItem(size, 'assets/sales_icon.png', 'Sales', RouteGenerator.sales),
              buildItem(size, 'assets/customer_icon.png', 'Customers', RouteGenerator.customers),
              buildItem(size, 'assets/supplier_icon.png', 'Supplier', RouteGenerator.supplier),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(size, 'assets/purchase.png', 'Purchase',RouteGenerator.purchase),
              buildItem(size, 'assets/stock.png', 'Stock',RouteGenerator.stock),
              buildItem(size, 'assets/invoice.png', 'Invoice', RouteGenerator.invoice),
              buildItem(size, 'assets/publicVendor.png', 'Public Vendors', RouteGenerator.publicVendors),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     buildItem(size, 'assets/list.png', 'Due List'),
          //     buildItem(size, 'assets/stock.png', 'Stock'),
          //     buildItem(size, 'assets/expenses.png', 'Expenses'),
          //     buildItem(size, 'assets/invoice.png', 'Invoice'),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildItem(Size size,String icon, String txt, var routeName){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        height: size.height/8,
        width: size.width/5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Image.asset(icon)),
            Text(txt,style: GoogleFonts.inter(fontSize: 15),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
