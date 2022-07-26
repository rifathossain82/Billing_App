import 'dart:io';
import 'package:billing_app/src/controller/productController.dart';
import 'package:billing_app/src/model/productData.dart';
import 'package:billing_app/src/pages/product/product_screen.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../controller/currencyController.dart';
import '../../widgets/myButton.dart';
import '../../widgets/showToastMessage.dart';
import '../category/selectCategory.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key}) : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

  //all are the textField Controller of this page
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController addNewCategoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  //TextEditingController purchasePriceController = TextEditingController();
  TextEditingController manufactureController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  TextEditingController baseUnitQuantityController = TextEditingController();
  TextEditingController baseUnitNameController = TextEditingController();
  TextEditingController baseUnitPriceController = TextEditingController();
  List<TextEditingController> subUnitQuantityController=[];
  List<TextEditingController> subUnitNameController=[];
  List<TextEditingController> subUnitPriceController=[];
  List<ProductStock> stockList = [];

  //to update and fetch product
  final productController=Get.put(ProductController());
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

  var status;   //status of product
  var productId;
  ProductData product=ProductData();
  var imgUrl;

  var stock;
  var productUnit;

  var categoryId;
  var supplierId;
  var productQuantity;

  //all type of unit store here
  List<String> unitList = [];

  var selectedUnitType;
  var selectedUnit;
  var details_stock;

  File? _image;   //to show display
  File? myImage;  //to update user image

  String? scanResult; //to store barcode result


  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData(){
    //to receive product id and product from product details page
    var result=Get.arguments;
    productId=result['id'];
    product=result['product'];

    setState(() {

      //set all textField data
      imgUrl=product.avatar ?? '';
      nameController.text=product.name ?? 'Not Found';
      categoryController.text=product.category!.name ?? 'Not Found';
      brandController.text=product.brand ?? 'Not Found';
      productCodeController.text=product.code ?? 'Not Found';
      //purchasePriceController.text=product.purchasePrice ?? '0';
      salePriceController.text=product.salePrice ?? '0' ;
      manufactureController.text=product.manufacture ?? 'Not Found';
      taxController.text= product.tax ?? '0';
      supplierController.text=product.supplier!.name ?? 'Not Found';

      for(int i=0; i<product.stock!.length; i++){
        if(i==0){
          baseUnitNameController.text = product.stock![i].unit!;
          baseUnitQuantityController.text = product.stock![i].conversionRate!;
          baseUnitPriceController.text = product.stock![i].price!;

          stockList.add(product.stock![i]);
        }
        else{
          subUnitNameController.add(TextEditingController());
          subUnitQuantityController.add(TextEditingController());
          subUnitPriceController.add(TextEditingController());

          subUnitNameController[i-1].text = product.stock![i].unit!;
          subUnitQuantityController[i-1].text = product.stock![i].conversionRate!;
          subUnitPriceController[i-1].text = product.stock![i].price!;

          stockList.add(product.stock![i]);
        }
      }

      //set status and status color
      if(product.isActive.toString().contains('0')){
        statusController.text='Inactive';
        status=false;
      }
      else{
        statusController.text='Active';
        status=true;
      }

      //SET category id and supplier id
      categoryId=product.category!.id ?? 0;
      supplierId=product.supplier!.id ?? 0;


      //setup stock section data
      productUnit=product.stock!.last.unit;
      print("product unit : $productUnit");
      stockController.text='${product.qty} ${productUnit}';
      productQuantity=product.qty !=null ? double.parse(product.qty.toString()) : 0.0;

    });

  }


  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    addNewCategoryController.dispose();
    brandController.dispose();
    productCodeController.dispose();
    stockController.dispose();
    salePriceController.dispose();
    //purchasePriceController.dispose();
    manufactureController.dispose();
    taxController.dispose();
    supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateProduct,),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
            onPressed: (){
              updateProduct();
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: size.height * 0.04,),
                buildImage(size, context),

                SizedBox(height: size.height * 0.04,),
                buildName(size, context),

                SizedBox(height: size.height * 0.03,),
                buildProductCategory(size, context),

                SizedBox(height: size.height * 0.03,),
                buildBrand(size, context),

                SizedBox(height: size.height * 0.03,),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: buildProductCode(size, context)
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                        flex: 1,
                        child: buildScanner(size)
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.03,),
                buildStock(size, context),

                // SizedBox(height: size.height * 0.02,),
                // buildHintOfPrice(),

                // SizedBox(height: size.height * 0.02,),
                // buildPurchasePrice(size, context),

                // SizedBox(height: size.height * 0.03,),
                // buildSalePrice(size, context),

                SizedBox(height: size.height * 0.03,),
                buildManufacture(size, context),

                SizedBox(height: size.height * 0.03,),
                buildTax(size, context),

                SizedBox(height: size.height * 0.03,),
                buildSupplier(size, context),

                SizedBox(height: size.height * 0.03,),
                buildStatus(size, context),

                SizedBox(height: size.height * 0.1,),
              ],
            ),
          ),
        ),
      ),

    );
  }

  void updateProduct()async{
    var imagePath=myImage == null ? '' : myImage!.path;
    var oldImage=imgUrl;
    double tax=double.parse(taxController.text.toString().isNotEmpty ? taxController.text.toString() : '0');

    //double p=double.parse(purchasePriceController.text.toString().isNotEmpty ? purchasePriceController.text.toString() : '0');
    double s=double.parse(salePriceController.text.toString().isNotEmpty ? salePriceController.text.toString() : '0');

    int purchasePrice=0;
    int salePrice=s.toInt();

    var product_status;
    if(statusController.text.toString().contains('Active')){
      product_status='1';
    }
    else{
      product_status='0';
    }

    customDialog();

    var result=
        await productController.updateProduct(
        productId,
        imagePath,
        oldImage,
        nameController.text,
        categoryId,
        brandController.text,
        productCodeController.text,
        //purchasePrice,
        //salePrice,
        manufactureController.text,
        tax,
        supplierId,
        product_status,
        productQuantity,
        stockList,
    );


    //to close dialog
    closeDialog();

    if(result.toString().isNotEmpty){
      showToastMessage(result);
      if(result=='Product update successfully'){

        //to refresh product screen
        final refreshProductScreen=RefreshProductScreen();
        refreshProductScreen.refresh();

        Get.back();
      }
    }
  }

  Widget buildImage(Size size, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 4.5),
      child: InkWell(
        onTap: () {
          buildBottomSheet(size, context);
        },
        child: Container(
          height: size.height * 0.15,
          child: Center(
            child: _image==null?
            Center(
              child: imgUrl==null?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.image,size: size.height*0.1,),
                  Text(AppLocalizations.of(context)!.noImageTxt)
                ],
              )
                  :
              CachedNetworkImage(
                imageUrl: "$imgUrl",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter:
                        ColorFilter.mode(Colors.black12, BlendMode.colorBurn)
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
                :
            Center(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 1,color: myblack),
                    image: DecorationImage(
                      fit: BoxFit.cover, image: FileImage(_image!),
                    )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName(Size size, BuildContext context) {
    return TextField(
      controller: nameController,
      maxLines: 1,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.productName,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildProductCategory(Size size, BuildContext context){
    return TextField(
      onTap: ()async{
        final result=await Get.to(()=>SelectCategory());
        setState(() {
          if(result!=null) {
            categoryController.text = result['name'];
            categoryId = int.parse(result['id']);
          }
        });
      },
      maxLines: 1,
      readOnly: true,
      controller: categoryController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.productCategory,
        hintText: AppLocalizations.of(context)!.selectCategory,
        border: OutlineInputBorder(),
      ),
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.addNewCategory,),
            content: TextField(
              controller: addNewCategoryController,
              maxLines: 1,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.categoryName,
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.add)
              ),
            ],
          );
        });
  }

  Widget buildBrand(Size size, BuildContext context) {
    return TextField(
      controller: brandController,
      maxLines: 1,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.brand,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildProductCode(Size size, BuildContext context) {
    return TextField(
      controller: productCodeController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.productCode,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildScanner(Size size) {
    return TextField(
      readOnly: true,
      onTap: () {
        scanBarcode();
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor2)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor2)
        ),
        prefixIcon: Center(
            child: Image.asset('assets/icons/barcode_reader.png')),
      ),
    );
  }

  Widget buildStock(Size size, BuildContext context){
    return TextField(
      controller: stockController,
      maxLines: 1,
      readOnly: true,
      onTap: (){
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context){
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(AppLocalizations.of(context)!.productStock)),
                          IconButton(
                            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.red,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      titleTextStyle: TextStyle(color: textColor2, fontWeight: FontWeight.w600, fontSize: 24),
                      scrollable: true,
                      content: setupAlertDialogContent(context),
                      actions: [
                        myButton(
                            onTap: (){

                              if(baseUnitPriceController.text.isEmpty){
                                print('base unit price is empty');
                                showToastMessage('The base unit price is empty!');
                              }
                              else if(subUnitNameController.length > 0 && (subUnitPriceController.any((element) => element.text.isEmpty))){
                                print('Sub unit price is empty');
                                showToastMessage('Sub unit price is empty!');
                              }
                              else {
                                stockList[0].price=baseUnitPriceController.text.toString();
                                for(int i=0; i<stockList.length; i++){
                                  if(i==0){
                                    stockList[i].price=baseUnitPriceController.text.toString();
                                  }
                                  else{
                                    stockList[i].price = subUnitPriceController[i-1].text.toString();
                                  }
                                }

                                for(int i=0; i<stockList.length; i++){
                                  print(stockList[i].price);
                                }

                                Navigator.pop(context);
                              }
                            },
                            buttonText: '${AppLocalizations.of(context)!.ok}',
                            paddingHorizontal: 16
                        ),
                      ],
                    );
                  }
              );
            }
        );
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.stock,
        hintText: '0',
        helperText: details_stock,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget setupAlertDialogContent(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProductStockRowForUpdate(
            title: 'Base Unit',
            unitNameController: baseUnitNameController,
            unitQuantityController: baseUnitQuantityController,
            unitPriceController: baseUnitPriceController
        ),
        Container(
          height: MediaQuery.of(context).size.height *0.5,
          width: MediaQuery.of(context).size.width *0.8,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
              itemCount: subUnitNameController.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var conversionName;
                if(index == 0){
                  conversionName = baseUnitNameController.text;
                }
                else{
                  conversionName = subUnitNameController[index-1].text;
                }
                return ProductStockRowForUpdate(
                    title: '1 x $conversionName',
                    unitNameController: subUnitNameController[index],
                    unitQuantityController: subUnitQuantityController[index],
                    unitPriceController: subUnitPriceController[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHintOfPrice(){
    return Text('Enter purchase and sales price based on $productUnit');
  }

  // Widget buildPurchasePrice(Size size, BuildContext context) {
  //   return TextField(
  //     controller: purchasePriceController,
  //     maxLines: 1,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelText: AppLocalizations.of(context)!.purchasePrice+" ("+currency+")",
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  Widget buildSalePrice(Size size, BuildContext context) {
    return TextField(
      controller: salePriceController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.salesPrice+" ("+currency+")",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildManufacture(Size size, BuildContext context) {
    return TextField(
      controller: manufactureController,
      maxLines: 1,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.manufacture,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildTax(Size size, BuildContext context) {
    return TextField(
      controller: taxController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.taxPercentage,
        hintText: '0.00%',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildSupplier(Size size, BuildContext context) {
    return TextField(
      controller: supplierController,
      maxLines: 1,
      readOnly: true,
      onTap: ()async{
        final result=await Get.toNamed(RouteGenerator.selectSupplier);

        setState(() {
          if(result!=null){
            supplierController.text=result['name'];
            supplierId=int.parse(result['id']);
          }
        });
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.supplierName,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildStatus(Size size, BuildContext context) {
    return TextField(
      controller: statusController,
      maxLines: 1,
      readOnly: true,
      onTap: (){

      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.status,
        suffixIcon: Switch.adaptive(
          value: status,
          onChanged: (val){
            setState(() {
              status=val;
              if(status){
                statusController.text='Active';
              }
              else{
                statusController.text='Inactive';
              }
            });
          }
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future buildBottomSheet(Size size, BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: size.width * 0.03,),
                    Text('Select the image source'),
                    SizedBox(width: size.width * 0.03,),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05,),
              buildImageSourceButtons(size, context),
            ],
          ),
        );
      },
    );
  }

  Widget buildImageSourceButtons(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              galleryImage();
              Navigator.pop(context);
            },
            child: Container(
              height: size.height * 0.07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mainColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image,),
                  SizedBox(width: size.width * 0.03,),
                  Text('Gallery', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03,),
          InkWell(
            onTap: () {
              cameraImage();
              Navigator.pop(context);
            },
            child: Container(
              height: size.height * 0.07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mainColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: size.width * 0.03,),
                  Text('Camera', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future galleryImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      _getImageFile(image);

    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future cameraImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      _getImageFile(image);

    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  _getImageFile(image)async{
    myImage=File(image.path);   //to set image temporary
    final imagePermanent = await saveImagePermanently(
        image.path); //to set image permanent in local storage
    setState(() {
      this._image = imagePermanent;
    });
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    //print(name.split('.').last);
    final image = File('${directory.path}/$name');
    //print(image);

    return File(imagePath).copy(image.path);
  }

  void scanBarcode() async {
    late String sanresult;
    try {
      sanresult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Failed to scan';
    }
    if (!mounted) {
      return;
    }

    setState(() {
      ///if barcode scanner is canceled then result is -1 so I ignore this result
      if(sanresult!='-1'){
        scanResult = sanresult;
        productCodeController.text=scanResult.toString();
      }
    });
  }

}

class ProductStockRowForUpdate extends StatelessWidget {
  ProductStockRowForUpdate({Key? key,
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
                  onTap: (){
                    showToastMessage('You can\'t change the conversion rate.');
                  },
                  controller: unitQuantityController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: '10',
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