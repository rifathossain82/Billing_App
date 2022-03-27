import 'dart:io';

import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/constaints/strings/AppStrings.dart';
import 'package:billing_app/widgets/myDropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController nameController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController brandController=TextEditingController();
  TextEditingController productCodeController=TextEditingController();
  TextEditingController stockController=TextEditingController();
  TextEditingController unitController=TextEditingController();
  TextEditingController salePriceController=TextEditingController();
  TextEditingController discountController=TextEditingController();
  TextEditingController wholeSaleController=TextEditingController();
  TextEditingController dealerController=TextEditingController();
  TextEditingController manufactureController=TextEditingController();
  var selectedCategory='Fashion';


  File? _image;
  File? file;

  String? scanResult;


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView(
          children: [
            SizedBox(height: size.height*0.04,),
            buildImage(size, context),
            SizedBox(height: size.height*0.04,),
            buildName(size),
            SizedBox(height: size.height*0.03,),
            buildProductCategory(size),
            SizedBox(height: size.height*0.03,),
            buildBrand(size),
            SizedBox(height: size.height*0.03,),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: buildProductCode(size)
                ),
                Expanded(
                  flex: 1,
                  child: buildScanner(size)
                ),
                SizedBox(width: 16,),
              ],
            ),
            SizedBox(height: size.height*0.03,),
            Row(
              children: [
                Expanded(
                    child: buildStock(size)
                ),
                Expanded(
                    child: buildUnit(size)
                ),
              ],
            ),
            SizedBox(height: size.height*0.03,),
            Row(
              children: [
                Expanded(
                    child: buildSalePrice(size)
                ),
                Expanded(
                    child: buildDiscount(size)
                ),
              ],
            ),
            SizedBox(height: size.height*0.03,),
            Row(
              children: [
                Expanded(
                    child: buildWholeSalePrice(size)
                ),
                Expanded(
                    child: buildDealerPrice(size)
                ),
              ],
            ),
            SizedBox(height: size.height*0.03,),
            buildManufacture(size),
            SizedBox(height: size.height*0.05,),
            buildButton(size),
            SizedBox(height: size.height*0.05,),
          ],
        ),
      ),

    );
  }
  
  Widget buildImage(Size size, BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width/4),
      child: InkWell(
        onTap: (){
          buildBottomSheet(size, context);
        },
        child: Container(
          height: size.height*0.15,
          child: Center(
              child: _image==null?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.image,size: size.height*0.1,),
                  Text('No Image Selected')
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

  Widget buildName(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: nameController,
          maxLines: 1,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Product Name',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildProductCategory(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          readOnly: true,
          controller: categoryController,
          decoration: InputDecoration(
            labelText: 'Product category',
            suffix: myDropDown(productCategoryList, '', (val) {
              setState(() {
                categoryController.text=val;
              });
            }),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildBrand(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: brandController,
          maxLines: 1,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Brand',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildProductCode(Size size){
    return SizedBox(
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: productCodeController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Product code*',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildScanner(Size size){
    return InkWell(
      onTap: (){
        scanBarcode();
      },
      child: Container(
        height: size.height*0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey)
        ),
        child: Image.asset('assets/barcode_reader.png'),
      ),
    );
  }

  Widget buildStock(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: stockController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stock*',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildUnit(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          readOnly: true,
          controller: unitController,
          decoration: InputDecoration(
            labelText: 'Unit*',
            suffix: myDropDown(unitList, '', (val) {
              setState(() {
                unitController.text=val;
              });
            }),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildSalePrice(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: salePriceController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Sale price*',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildDiscount(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: discountController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Discount*',
            hintText: '0.00%',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildWholeSalePrice(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: wholeSaleController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Wholesale price',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildDealerPrice(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: dealerController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Dealer price',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildManufacture(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: manufactureController,
          maxLines: 1,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Manufacture',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildButton(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: size.height*0.08,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: mainColor,
        ),
        child: Text('Save Product',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: myWhite),),
      ),
    );
  }

  Future buildBottomSheet(Size size, BuildContext context){
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

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent = await saveImagePermanently(
          image.path); //to set image permanent in local storage
      setState(() {
        this._image = imagePermanent;
        final path = image.path;
        file = File(path);
      });
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future cameraImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent = await saveImagePermanently(
          image.path); //to set image permanent in local storage
      setState(() {
        this._image = imagePermanent;
        final path = image.path;
        file = File(path);
      });
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

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
      scanResult = sanresult;
      productCodeController.text=scanResult.toString();
    });
  }
}
