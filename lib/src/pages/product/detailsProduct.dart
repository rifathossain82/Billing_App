import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/pages/product/product_screen.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/confirmationDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/currencyController.dart';
import '../../controller/productController.dart';
import 'package:http/http.dart' as http;

import '../../controller/tokenController.dart';
import '../../model/productData.dart';
import '../../widgets/showToastMessage.dart';

class DetailsProduct extends StatefulWidget {
  const DetailsProduct({Key? key}) : super(key: key);

  @override
  State<DetailsProduct> createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {

  var productController=Get.put(ProductController());
  var tokenController=Get.find<TokenController>();
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

  ProductData product=ProductData();
  var productId;
  var isLoading=false;

  var img;
  var productName;
  var category;
  var brand;
  var code;
  var stock;
  var quantity;
  //var purchasePrice;
  var salePrice;
  var manufacture;
  var tax;
  var supplier;

  @override
  void initState() {
    productId=Get.arguments;
    print(productId);

    getSingleProduct(productId);

    super.initState();
  }

  void getSingleProduct(String productId)async{
    var data;
    var response;
    isLoading=true;

    response=await http.get(Uri.parse(Util.baseUrl + Util.product_show + productId),headers: {
      "Accept": "application/json",
      "Authorization" : "Bearer ${tokenController.token}"
    });

    print(response.statusCode);
    print(response.body);

    if(response.statusCode==200){
      data=jsonDecode(response.body.toString());
      data=data['data'];

      if(!mounted)return;
      setState(() {
        product=ProductData.fromJson(data);

        img=product.avatar ?? '';
        productName=product.name ?? 'Not Found';
        category=product.category!.name ?? 'Not Found';
        brand=product.brand ?? 'Not Found';
        code=product.code ?? 'Not Found';
        //purchasePrice=product.purchasePrice ?? 0;
        salePrice=product.stock!.last.price ?? 0;
        manufacture=product.manufacture ?? 'Not Found';
        tax= product.tax ?? '0' ;
        supplier=product.supplier!.name ?? 'Not Found';
        quantity=product.qty;
      });

      isLoading=false;
    }
    else{
      isLoading=false;
      throw Exception('No data found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.productDetails,),
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
              onPressed: ()async{
                await Get.toNamed(RouteGenerator.updateProduct, arguments: {'id':productId, 'product' : product});

                //to refresh product
                getSingleProduct(productId);
              },
              icon: Icon(Icons.edit, color: textColor2,)
          ),
          IconButton(
              onPressed: ()async{
                var result = await confirmationDialog(
                    context: context,
                    title: AppLocalizations.of(context)!.deleteMsg,
                    negativeActionText: AppLocalizations.of(context)!.cancel,
                    positiveActionText: AppLocalizations.of(context)!.delete);

                if(result == true){
                  deleteProduct();
                }
              },
              icon: Icon(Icons.delete, color: textColor2,)
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: isLoading?
        Center(child: Image.asset('assets/icons/loading.gif'))
            :
        ListView(
          children: [
            img==null? Center(child: Text('Image not found.')) : buildImage(size, context, '$img'),
            buildDescription(),
          ],
        ),
      ),
    );
  }

  void deleteProduct()async{

    //show a loader
    customDialog();

    var result = await productController.deleteProduct(productId);

    //close loader
    closeDialog();

    //to show result
    showToastMessage(result);

    ///to refresh product screen
    final refreshProductScreen=RefreshProductScreen();
    refreshProductScreen.refresh();

    //to back product screen
    Get.back();
  }

  Widget buildImage(Size size, BuildContext context, String url){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Hero(
        tag: '${productId}',
        child: Container(
          height: size.height*0.3,
          child: CachedNetworkImage(
            imageUrl: "$img",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0.0, 2.0),
                      blurRadius: 5
                  )
                ],
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black12, BlendMode.colorBurn),
                ),
              ),
            ),
            placeholder: (context, url) => Image.asset('assets/icons/loading.gif'),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget buildDescription(){

    //by default we set status active and statusColor is successColor
    var status='Active';
    var statusColor=successColor;

    //set status and status color
    if(product.isActive.toString().contains('0')){
      status='Inactive';
      statusColor=failedColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText('$productName', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: textColor2),)
                ),
                SizedBox(width: 8,),
                AutoSizeText('$status', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: statusColor),),
              ],
            ),
          ),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.productCategory, '$category'),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.brand, '$brand'),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.productCode, '$code'),
          Divider(),
          Row(
            children: [
              Expanded(child: buildTextRow(AppLocalizations.of(context)!.stock, '$quantity ${product.stock!.last.unit}')),
              ElevatedButton(
                  onPressed: ()async{
                    var result = await Get.toNamed(RouteGenerator.updateStock, arguments: product);

                    //if user add quantity then set quantity again after sum
                    if(result!=null){
                      getSingleProduct(productId);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: myWhite,fontSize: 14),)
              ),
              SizedBox(width: 8,),
            ],
          ),
          // Divider(),
          // buildTextRow(AppLocalizations.of(context)!.purchasePrice, '$purchasePrice $currency'),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.salesPrice, '$salePrice $currency'),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.manufacture, '$manufacture'),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.taxPercentage, '$tax %'),
          Divider(),
          buildTextRow(AppLocalizations.of(context)!.supplierName, '$supplier'),
        ],
      ),
    );
  }

  Widget buildTextRow(String title, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: AutoSizeText(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor2),)),
          SizedBox(width: 16,),
          Expanded(child: AutoSizeText(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textColor2),textAlign: TextAlign.end,)),
        ],
      ),
    );
  }
}
