import 'dart:io';
import 'dart:convert';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/controller/productController.dart';
import 'package:billing_app/src/model/productData.dart';
import 'package:billing_app/src/pages/category/selectCategory.dart';
import 'package:billing_app/src/pages/product/addProductStock.dart';
import 'package:billing_app/src/pages/product/product_screen.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/myButton.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
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

import '../../constaints/colors/AppColors.dart';
import '../../constaints/strings/AppStrings.dart';
import '../../controller/currencyController.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController nameController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController addNewCategoryController=TextEditingController();
  TextEditingController brandController=TextEditingController();
  TextEditingController productCodeController=TextEditingController();
  TextEditingController stockController=TextEditingController();
  TextEditingController salePriceController=TextEditingController();
  TextEditingController purchasePriceController=TextEditingController();
  TextEditingController manufactureController=TextEditingController();
  TextEditingController taxController=TextEditingController();
  TextEditingController supplierController=TextEditingController();

  TextEditingController baseUnitQuantityController = TextEditingController();
  TextEditingController baseUnitNameController = TextEditingController();
  TextEditingController baseUnitPriceController = TextEditingController();
  List<TextEditingController> subUnitQuantityController=[];
  List<TextEditingController> subUnitNameController=[];
  List<TextEditingController> subUnitPriceController=[];

  //controller to add product
  final productController=Get.put(ProductController());
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

  var categoryID;
  var supplierID;
  double tax=0.0;

  List<String> unitList=[];

  var selectedUnitType;
  var selectedUnit;
  var details_stock;
  double productQuantity=0;
  List<StockModelToAddProduct> stockList=[];

  var productUnit='';     //to show a hint to enter product prices based on smaller Unit

  File? _image;   //to show display
  File? myImage;  //to update user image

  String? scanResult;


  @override
  void initState() {
    super.initState();
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
    purchasePriceController.dispose();
    manufactureController.dispose();
    taxController.dispose();
    supplierController.dispose();

    baseUnitNameController.dispose();
    baseUnitQuantityController.dispose();
    subUnitQuantityController.clear();
    subUnitNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addProductTitle,),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height*0.04,),
                buildImage(size, context),
                SizedBox(height: size.height*0.04,),
                buildName(size, context),
                SizedBox(height: size.height*0.03,),
                buildProductCategory(size, context),
                SizedBox(height: size.height*0.03,),
                buildBrand(size, context),
                SizedBox(height: size.height*0.03,),
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
                SizedBox(height: size.height*0.03,),
                buildStock(size, context),
                //if there is a product unit then show the hint other wise ignore it
                productUnit.toString().isNotEmpty? SizedBox(height: size.height * 0.02,) : SizedBox(height: size.height * 0.01,),
                productUnit.toString().isNotEmpty? buildHintOfPrice() : Container(),
                // SizedBox(height: size.height * 0.02,),
                // buildPurchasePrice(size, context),
                // SizedBox(height: size.height*0.03,),
                // buildSalePrice(size, context),
                SizedBox(height: size.height*0.03,),
                buildManufacture(size, context),
                SizedBox(height: size.height*0.03,),
                buildTax(size, context),
                SizedBox(height: size.height*0.03,),
                buildSupplier(size, context),
                SizedBox(height: size.height*0.05,),
                myButton(
                    onTap: (){
                      addProduct();
                    },
                    buttonText: AppLocalizations.of(context)!.saveProduct,
                    paddingHorizontal: 0
                ),
                SizedBox(height: size.height*0.1,),
              ],
            ),
          ),
        ),
      ),

    );
  }

  void addProduct()async{
    var imagePath=myImage==null? '' : myImage!.path;

    if(nameController.text.isEmpty){
      showToastMessage('Product Name is required!');
    }
    else if(categoryController.text.isEmpty){
      showToastMessage('Select a category.');
    }
    else if(stockController.text.isEmpty){
      showToastMessage('Set product stock');
    }
    // else if(purchasePriceController.text.isEmpty){
    //   showToastMessage('Purchase price is required!');
    // }
    // else if(salePriceController.text.isEmpty){
    //   showToastMessage('Sales price is required!');
    // }
    else if(supplierController.text.isEmpty){
      showToastMessage('Select a supplier');
    }
    else{

      String brand=brandController.text.isEmpty ? 'Not set' : brandController.text.toString();
      String code=productCodeController.text.isEmpty ? 'Not set' : productCodeController.text.toString();
      String manufacture=manufactureController.text.isEmpty ? 'Not set' : manufactureController.text.toString();
      tax=double.parse(taxController.text.isEmpty ? '0' : taxController.text.toString());

      //to show a loading
      customDialog();

      var result=
      await productController.addProduct(
          imagePath,
          nameController.text,
          categoryID,
          brand,
          code,
          //purchasePriceController.text,
          //salePriceController.text,
          manufacture,
          tax,
          supplierID,
          productQuantity,
          '1',
          stockList
      );

      //to close loader
      closeDialog();

      print(result);

      if(result.toString().isNotEmpty){
        showToastMessage(result);
        if(result.contains('Product add successfully')){
          RefreshProductScreen().refresh();
          Get.back();
        }
      }
    }


  }
  
  Widget buildImage(Size size, BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width/4.5),
      child: InkWell(
        onTap: (){
          buildSelectImageBottomSheet(size, context);
        },
        child: Container(
          height: size.height*0.15,
          child: Center(
              child: _image==null?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.image,size: size.height*0.1,),
                  Text(AppLocalizations.of(context)!.noImageTxt)
                ],
              )
                  :
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 1,color: myblack),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth, image: FileImage(_image!),
                    )
                ),
              ),
          ),
        ),
      ),
    );
  }

  Widget buildName(Size size, BuildContext context){
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
            categoryID = int.parse(result['id']);
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

  Widget buildBrand(Size size, BuildContext context){
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

  Widget buildProductCode(Size size, BuildContext context){
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

  Widget buildScanner(Size size){
    return TextField(
      readOnly: true,
      onTap: (){
        scanBarcode();
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor2)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor2)
          ),
          prefixIcon: Center(child: Image.asset('assets/icons/barcode_reader.png')),
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
                        children: [
                          Expanded(child: Text(AppLocalizations.of(context)!.productStock)),
                          subUnitQuantityController.length > 0 ?
                          IconButton(
                            icon: Icon(CupertinoIcons.minus_circle_fill, color: textColor2,),
                            onPressed: (){
                              setState(() {
                                if(!mounted) return;
                                subUnitNameController.removeLast();
                                subUnitQuantityController.removeLast();
                                subUnitPriceController.removeLast();
                              });
                            },
                          )
                              :
                          Container(),

                          IconButton(
                            icon: Icon(CupertinoIcons.add_circled_solid, color: textColor2,),
                            onPressed: (){
                              if(baseUnitNameController.text.isEmpty || baseUnitQuantityController.text.isEmpty || baseUnitPriceController.text.isEmpty){
                                print('base unit is empty');
                                showToastMessage('The base unit is empty!');
                              }
                              else if(subUnitNameController.length > 0 && (subUnitNameController.last.text.isEmpty || subUnitQuantityController.last.text.isEmpty || subUnitPriceController.last.text.isEmpty)){
                                print('last unit is empty');
                                showToastMessage('The last sub unit is empty!');
                              }
                              else{
                                setState(() {
                                  if(!mounted) return;
                                  subUnitNameController.add(TextEditingController());
                                  subUnitQuantityController.add(TextEditingController());
                                  subUnitPriceController.add(TextEditingController());
                                });
                              }
                            },
                          ),

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

                              if(baseUnitNameController.text.isEmpty || baseUnitQuantityController.text.isEmpty || baseUnitPriceController.text.isEmpty){
                                print('base unit is empty');
                                showToastMessage('The base unit is empty!');
                              }
                              else if(subUnitNameController.length > 0 && (subUnitNameController.last.text.isEmpty || subUnitQuantityController.last.text.isEmpty || subUnitPriceController.last.text.isEmpty)){
                                print('last unit is empty');
                                showToastMessage('The last sub unit is empty!');
                              }
                              else{
                                stockList = [];
                                stockList.add(StockModelToAddProduct(
                                    unit: baseUnitNameController.text,
                                    conversionRate: baseUnitQuantityController.text,
                                    baseUnit: baseUnitNameController.text,
                                    isBase: '1',
                                    price: double.parse(baseUnitPriceController.text.toString()),
                                ));

                                for(int i=0; i<subUnitNameController.length; i++){
                                  if(i==0){
                                    stockList.add(StockModelToAddProduct(
                                        unit: subUnitNameController[i].text,
                                        conversionRate: subUnitQuantityController[i].text,
                                        baseUnit: baseUnitNameController.text,
                                        isBase: '0',
                                        price: double.parse(subUnitPriceController[i].text.toString()),
                                    ));
                                  }
                                  else{
                                    stockList.add(StockModelToAddProduct(
                                        unit: subUnitNameController[i].text,
                                        conversionRate: subUnitQuantityController[i].text,
                                        baseUnit: subUnitNameController[i-1].text,
                                        isBase: '0',
                                        price: double.parse(subUnitPriceController[i].text.toString()),
                                    ));
                                  }
                                }

                                productQuantity = stockList.fold(1, (previousValue, element) => previousValue * double.parse(element.conversionRate.toString()));


                                print(productQuantity);
                                stockController.text = "${baseUnitQuantityController.text}  ${baseUnitNameController.text}";
                                Navigator.pop(context);
                              }


                              // if(purchaseUnitController.text.isEmpty){
                              //   showToastMessage('Purchase Unit is Empty!');
                              // }
                              // else if(unitTypeController.text.isEmpty){
                              //   showToastMessage('Unit Type is Empty!');
                              // }
                              // else{
                              //   if(unitController.text.isNotEmpty){
                              //     if(smallerUnitTypeController.text.isEmpty){
                              //       showToastMessage('Minimum unit type is Empty!');
                              //     }
                              //     else{
                              //       calculateStock(context);
                              //     }
                              //   }
                              //   else if(smallerUnitTypeController.text.isNotEmpty){
                              //     if(unitController.text.isEmpty){
                              //       showToastMessage('Minimum unit is Empty!');
                              //     }
                              //     else{
                              //       calculateStock(context);
                              //     }
                              //   }
                              //   else{
                              //     calculateStock(context);
                              //   }
                              // }
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
        ProductStockRow(
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
                return ProductStockRow(
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

  Widget buildPurchasePrice(Size size, BuildContext context){
    return TextField(
      controller: purchasePriceController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.purchasePrice+" ($currency)",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildSalePrice(Size size, BuildContext context){
    return TextField(
      controller: salePriceController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.salesPrice+" ($currency)",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildManufacture(Size size, BuildContext context){
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

  Widget buildTax(Size size, BuildContext context){
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

  Widget buildSupplier(Size size, BuildContext context){
    return TextField(
      controller: supplierController,
      maxLines: 1,
      readOnly: true,
      onTap: ()async{
        final result=await Get.toNamed(RouteGenerator.selectSupplier);

        setState(() {
          if(result!=null){
            supplierController.text=result['name'];
            supplierID=int.parse(result['id']);
          }
        });
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.supplierName,
        hintText: AppLocalizations.of(context)!.selectSupplier,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future buildSelectImageBottomSheet(Size size, BuildContext context){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
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
                    SizedBox(width: size.width*0.03,),
                    Text('Select the image source'),
                    SizedBox(width: size.width*0.03,),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              SizedBox(height: size.height*0.05,),
              buildImageSourceButtons(size, context),
            ],
          ),
        );
      },
    );
  }

  Widget buildImageSourceButtons(Size size, BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              galleryImage();
              Navigator.pop(context);
            },
            child: Container(
              height: size.height*0.07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mainColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image,),
                  SizedBox(width: size.width*0.03,),
                  Text('Gallery', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height*0.03,),
          InkWell(
            onTap: (){
              cameraImage();
              Navigator.pop(context);
            },
            child: Container(
              height: size.height*0.07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mainColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: size.width*0.03,),
                  Text('Camera', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
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

class ProductStockRow extends StatelessWidget {
  ProductStockRow({Key? key,
    required this.title,
    required this.unitNameController,
    required this.unitQuantityController,
    required this.unitPriceController,
  }) : super(key: key);

  String title;
  TextEditingController unitQuantityController;
  TextEditingController unitNameController;
  TextEditingController unitPriceController;

  var currency=Get.find<CurrencyController>().currency;

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
                    hintText: '10',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: TextField(
                  controller: unitNameController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
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
                    hintText: '0 ${currency}',
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

/*
class ProductStockRow extends StatelessWidget {
  ProductStockRow({Key? key,
    required this.title,
    required this.unitNameController,
    required this.unitQuantityController}) : super(key: key);

  String title;
  TextEditingController unitQuantityController;
  TextEditingController unitNameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$title',
                    maxLines: 1,
                  ),
                ),
                Text(
                  '=',

                ),
              ],
            ),
          ),
          SizedBox(width: 8,),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: unitQuantityController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '10',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: TextField(
                    controller: unitNameController,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Box',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: TextField(
                    controller: unitNameController,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Price per box',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 */


class StockModelToAddProduct {
  String? unit;
  String? conversionRate;
  String? baseUnit;
  String? isBase;
  double? price;

  StockModelToAddProduct({this.unit, this.conversionRate, this.baseUnit, this.isBase, this.price});

  StockModelToAddProduct.fromJson(Map<dynamic, dynamic> json) {
    unit = json['unit'];
    conversionRate = json['conversion_rate'];
    baseUnit = json['base_unit'];
    isBase = json['is_base'];
    price = json['price'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['unit'] = this.unit;
    data['conversion_rate'] = this.conversionRate;
    data['base_unit'] = this.baseUnit;
    data['is_base'] = this.isBase;
    data['price'] = this.price;
    return data;
  }
}


