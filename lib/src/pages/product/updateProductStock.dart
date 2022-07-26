import 'package:billing_app/src/controller/productController.dart';
import 'package:billing_app/src/model/productData.dart';
import 'package:billing_app/src/pages/product/product_screen.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../constaints/colors/AppColors.dart';
import '../../controller/currencyController.dart';

class UpdateProductStock extends StatefulWidget {
  const UpdateProductStock({Key? key}) : super(key: key);

  @override
  State<UpdateProductStock> createState() => _UpdateProductStockState();
}

class _UpdateProductStockState extends State<UpdateProductStock> {

  List<TextEditingController> unitQuantityController=[];
  List<TextEditingController> unitNameController=[];
  List<TextEditingController> unitPriceController=[];
  List<ProductStock> stockList = [];
  List<String?> newQuantityList = [];

  final productController=Get.put(ProductController());
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller
  ProductData product=ProductData();   //to receive product data from details page

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData(){
    if(!mounted)return;
    setState(() {
      //receive product data
      product=Get.arguments;

      for(int i=0; i<product.stock!.length; i++){
        unitNameController.add(TextEditingController());
        unitQuantityController.add(TextEditingController());
        unitPriceController.add(TextEditingController());

        unitNameController[i].text = product.stock![i].unit!;
        unitPriceController[i].text = product.stock![i].price!;

        stockList.add(product.stock![i]);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateStock,),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
            onPressed: (){
              addStock();
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            itemCount: stockList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var title;
              var baseUnit = stockList[index].baseUnit;;
              var conversionUnit = stockList[index].conversionRate;
              var unitName = stockList[index].unit;
              if(index == 0){
                title = 'Base unit';
              }
              else{
                title = '1 x $baseUnit = $conversionUnit $unitName';
              }
              return ProductStockRowForUpdateStock(
                  title: title,
                  unitNameController: unitNameController[index],
                  unitQuantityController: unitQuantityController[index],
                  unitPriceController: unitPriceController[index]);
            },
          ),
        ),
      ),
    );
  }

  void addStock()async{
    var totalQuantity=0;
    if(unitPriceController.any((priceController) => priceController.text.isEmpty)){
      showToastMessage('Any unit price can\'t empty!');
    }
    else if(unitQuantityController.every((quantityController) => quantityController.text.isEmpty)){
      showToastMessage('Quantity are empty of all unit.');
    }
    else{
      for(int i=0; i<stockList.length; i++){
        stockList[i].price = unitPriceController[i].text;
        if(unitQuantityController[i].text.isNotEmpty){
          int newQuantity = int.parse(unitQuantityController[i].text.toString());
          for(int j=i+1; j<stockList.length; j++){
            double d = double.parse(stockList[j].conversionRate.toString());
            newQuantity *= d.toInt();
          }
          totalQuantity +=  newQuantity;
        }
      }

      customDialog();
      var result=await productController.incrementStock(product.id.toString(), totalQuantity.toString(), stockList);
      closeDialog();

      ///to refresh product screen
      final refreshProductScreen=RefreshProductScreen();
      refreshProductScreen.refresh();

      showToastMessage(result);
      Get.back(result: totalQuantity.toString());

    }
  }
}


class ProductStockRowForUpdateStock extends StatelessWidget {
  ProductStockRowForUpdateStock({Key? key,
    required this.title,
    required this.unitNameController,
    required this.unitQuantityController,
    required this.unitPriceController,
  }) : super(key: key);

  String title;
  TextEditingController unitQuantityController;
  TextEditingController unitNameController;
  TextEditingController unitPriceController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 12,),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: unitQuantityController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter unit',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: TextField(
                  onTap: (){
                    showToastMessage('You can\'t change the unit.');
                  },
                  controller: unitNameController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Box',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: TextField(
                  controller: unitPriceController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Unit price',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
