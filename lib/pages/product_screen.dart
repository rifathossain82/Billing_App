import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/widgets/appBar_bg.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  TextEditingController searchController=TextEditingController();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Products'),
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
                    hintText: 'Product Name',
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
      body: buildProduct(),
      floatingActionButton: buildFloatingButton()
    );
  }

  Widget buildProduct(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: Image.network('https://asia.canon/media/image/2020/08/26/e0974bdc54d445039d4e3db2301b0c73_E34xx_AS_FR_cl2_blk_en-362x320.png'),
          title: Text('Canon 8002'),
          subtitle: Text('Stock : 5'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('990',style: TextStyle(fontSize: 16,color: myDeepOrange)),
              Text('1290', style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFloatingButton(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'btn1',
          onPressed: (){},
          child: Icon(Icons.shopping_cart, color: myWhite,),
          backgroundColor: myDeepOrange,
        ),
        SizedBox(height: 16,),
        FloatingActionButton(
          heroTag: 'btn2',
          onPressed: (){
            Navigator.pushNamed(context, RouteGenerator.addProduct);
          },
          child: Icon(Icons.add,color: myWhite,),
          backgroundColor: myDeepOrange,
        ),
      ],
    );
  }
}
