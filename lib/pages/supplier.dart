import 'package:flutter/material.dart';

import '../constaints/colors/AppColors.dart';
import '../routes/routes.dart';
import '../widgets/appBar_bg.dart';

class Supplier extends StatefulWidget {
  const Supplier({Key? key}) : super(key: key);

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  TextEditingController searchController=TextEditingController();
  var searchString='';

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier List'),
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
                  hintText: 'Supplier name',
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
          Navigator.pushNamed(context, RouteGenerator.addSupplier);
        },
        child: Icon(Icons.add),
        backgroundColor: myDeepOrange,
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
                color: myDeepOrange.withOpacity(0.2),
              ),
              child: Icon(Icons.phone),
            ),
            SizedBox(width: 16,),
            Container(
              height: size.height*0.05,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: myDeepOrange.withOpacity(0.2),
              ),
              child: Icon(Icons.email_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
