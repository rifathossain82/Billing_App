import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/constaints/strings/AppStrings.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/widgets/countryCodeDropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../widgets/appBar_bg.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  TextEditingController searchController=TextEditingController();
  var searchString='';
  var selectedCustomer='Select One';

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    //onSubmitted: searchLocation,
                    onChanged: (value) {
                      setState(() {
                        searchString = value.toLowerCase().trim();
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Search',
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
                IconButton(onPressed: () {
                  print('hello');
                }, icon: Icon(Icons.filter_list, color: myWhite,size: 40,))
              ],
            ),
          ),
        ),
      ),
      body: buildSalesItem(),
    );
  }

  Widget buildSalesItem(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          title: Text('INV1002'),
          subtitle: Text('Total : 900 tk'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('21-03-2022',style: TextStyle(fontSize: 16,color: myDeepOrange)),
              Text('Rahim Miayh',style: TextStyle(fontSize: 12,color: myDeepOrange)),
            ],
          ),
        ),
      ),
    );
  }

}
