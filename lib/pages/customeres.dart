import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:flutter/material.dart';

import '../widgets/appBar_bg.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

  TextEditingController searchController=TextEditingController();
  var searchString='';

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: TextField(
              controller: searchController,
              //onSubmitted: searchLocation,
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                  hintText: 'Customer name',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.transparent, width: 0)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.transparent, width: 0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.transparent, width: 0)
                  )
              ),
            ),
          ),
        ),
      ),
      body: buildCutomer(size),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, RouteGenerator.addCustomer);
        },
        child: Icon(Icons.add,color: myWhite,),
        backgroundColor: mainColor,
      ),
    );
  }

  Widget buildCutomer(Size size){
    return ExpansionTile(
      title: Text('Rifat Hossain',style: TextStyle(color: Colors.black54),),
      subtitle: Text('01882508771',style: TextStyle(color: Colors.black38),),
      childrenPadding: EdgeInsets.only(left: 16,bottom: 8),
      expandedAlignment: Alignment.centerLeft,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('officialrifat82@gmail.com',style: TextStyle(color: Colors.black38),)
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Dr. para, feni.',style: TextStyle(color: Colors.black38),)
        ),
        SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height*0.05,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mainColor.withOpacity(0.2),
              ),
              child: Icon(Icons.phone),
            ),
            SizedBox(width: 16,),
            Container(
              height: size.height*0.05,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mainColor.withOpacity(0.2),
              ),
              child: Icon(Icons.email_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
