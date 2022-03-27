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

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController customerCareController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController zipCodeController=TextEditingController();
  TextEditingController websiteController=TextEditingController();
  TextEditingController currencyController=TextEditingController();
  TextEditingController invoicePrefixController=TextEditingController();

  var countryCode='+880';
  var visibility_value='public';

  File? _image;
  File? file;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.check)
          )
        ],
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
            buildPhone(size),
            SizedBox(height: size.height*0.03,),
            buildCustomerCarePhone(size),
            SizedBox(height: size.height*0.03,),
            buildEmail(size),
            SizedBox(height: size.height*0.03,),
            buildAddress(size),
            SizedBox(height: size.height*0.03,),
            buildZipCode(size),
            SizedBox(height: size.height*0.03,),
            buildWebsite(size),
            SizedBox(height: size.height*0.03,),
            buildCurrency(size),
            SizedBox(height: size.height*0.03,),
            buildInvoicePrefix(size),
            SizedBox(height: size.height*0.03,),
            buildVisibilityOption(),
            SizedBox(height: size.height*0.03,),
            //buildButton(size),
            //SizedBox(height: size.height*0.04,),
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
            labelText: 'Company & Business Name',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildPhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: phoneController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefix: myDropDown(countryCodeList, countryCode, (val){
              setState((){ //
                countryCode=val;
              });
            }),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildCustomerCarePhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: customerCareController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Customer Care Number',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildEmail(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: emailController,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildAddress(Size size){
    return SizedBox(
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: addressController,
          maxLines: 1,
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildZipCode(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: zipCodeController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Zip code',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildWebsite(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: websiteController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Website',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildCurrency(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          readOnly: true,
          controller: currencyController,
          decoration: InputDecoration(
            labelText: 'Currency',
            suffix: myDropDown(currencyList, '', (val) {
              setState(() {
                currencyController.text=val;
              });
            }),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildInvoicePrefix(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: invoicePrefixController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Invoice Prefix',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildVisibilityOption(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Text('Profile Visibility'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Divider(),
              ),
              ListTile(
                title: Text('Private'),
                leading: Radio(
                    value: 'private',
                    groupValue: visibility_value,
                    onChanged: (val){
                      setState(() {
                        visibility_value=val.toString();
                      });
                    }
                ),
              ),
              ListTile(
                title: Text('Public'),
                leading: Radio(
                    value: 'public',
                    groupValue: visibility_value,
                    onChanged: (val){
                      setState(() {
                        visibility_value=val.toString();
                      });
                    }
                ),
              )
            ],
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
        child: Text('Update',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: myWhite),),
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
}
