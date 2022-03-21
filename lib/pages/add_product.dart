import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/constaints/strings/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            buildImage(size),
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
  
  Widget buildImage(Size size){
    return Container(
      height: size.height*0.15,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.image,size: size.height*0.1,),
              Text('No Image Selected')
            ],
          )
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
            suffix: productCategoryDropDown(productCategoryList, '', (val) {
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
    return Container(
      height: size.height*0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey)
      ),
      child: Image.asset('assets/barcode_reader.png'),
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
            suffix: productCategoryDropDown(unitList, '', (val) {
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
          color: myDeepOrange,
        ),
        child: Text('Save Product',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: myWhite),),
      ),
    );
  }


  Widget productCategoryDropDown(
      List<String> items,   //from main
      String value, //from main
      void onChange(val) //from main
      )
  {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: Icon(Icons.keyboard_arrow_down),
          elevation: 0,
          value: value.isEmpty?null :value,
          onChanged: (val){
            onChange(val);
          },
          items: items.map<DropdownMenuItem<String>>((String val){
            return DropdownMenuItem(
              child: Text(val,style: TextStyle(color: Colors.black),),
              value: val,
            );
          }).toList(),
          dropdownColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget unitDropDown(
      List<String> items,   //from main
      String value, //from main
      void onChange(val) //from main
      )
  {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: Icon(Icons.keyboard_arrow_down),
          elevation: 0,
          value: value.isEmpty?null :value,
          onChanged: (val){
            onChange(val);
          },
          items: items.map<DropdownMenuItem<String>>((String val){
            return DropdownMenuItem(
              child: Text(val,style: TextStyle(color: Colors.black),),
              value: val,
            );
          }).toList(),
          dropdownColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
