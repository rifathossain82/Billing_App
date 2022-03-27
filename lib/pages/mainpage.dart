import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/pages/Dashboard.dart';
import 'package:billing_app/pages/cart.dart';
import 'package:billing_app/pages/homepage.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int index_=0;
  final items=<BottomNavyBarItem>[
    BottomNavyBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
      activeColor: mainColor,
      inactiveColor: myblack.withOpacity(0.6),
    ),
    BottomNavyBarItem(
        icon: Icon(Icons.shopping_cart),
        title: Text('Cart'),
        activeColor: mainColor,
        inactiveColor: myblack.withOpacity(0.6)
    ),
    BottomNavyBarItem(
        icon: Icon(Icons.dashboard),
        title: Text('Dashboard'),
        activeColor: mainColor,
        inactiveColor: myblack.withOpacity(0.6)
    ),
  ];

  final pages=[
    Homepage(),
    Cart(),
    Dashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      bottomNavigationBar: BottomNavyBar(
        items: items,
        selectedIndex: index_,
        showElevation: false,
        itemCornerRadius: 8,
        onItemSelected: (index){
          setState(() {
            index_=index;
          });
        }
      ),
      body: pages[index_],
    );
  }

  var myAppBar=AppBar(
    backgroundColor: myWhite,
    foregroundColor: mainColor,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rifat Hossain',style: GoogleFonts.inter(),),
        Text('Free Plan',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),)
      ],
    ),
    elevation: 0,
    leading: Builder(
      builder: (context) {
        return InkWell(
          onTap: (){
            Navigator.pushNamed(context, RouteGenerator.profilePage);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.0,),
            child: Icon(Icons.account_circle,size: 50,),
          ),
        );
      }
    ),
    actions: [
      IconButton(
        onPressed: (){},
        icon: Icon(Icons.notifications_outlined),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          onPressed: (){},
          icon: Icon(Icons.share,),
        ),
      ),
    ],
  );
}
