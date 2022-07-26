import 'dart:io';

import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/model/userModel.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../constaints/colors/AppColors.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';

class InvoiceSettings extends StatefulWidget {
  const InvoiceSettings({Key? key}) : super(key: key);

  @override
  State<InvoiceSettings> createState() => _InvoiceSettingsState();
}

class _InvoiceSettingsState extends State<InvoiceSettings> {

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController websiteController=TextEditingController();
  final authenticationController=Get.put(AuthenticationController());
  Company company = Company();

  var isLoading=true;

  var visibility_value='Public';
  var id;  var imgUrl;

  File? _image;   //to show display
  File? myImage;  //to update user image

  @override
  void initState(){
    company=Get.find<AuthenticationController>().user[0].company!;
    _setUserData();
    super.initState();
  }

  _setUserData(){
    id=company.id;
    imgUrl=company.avatar;
    nameController.text=company.name!;
    emailController.text=company.email ?? '';
    addressController.text=company.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invSettings,),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
            onPressed: (){
              updateProfile();
            },
            icon: Icon(Icons.check)
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: size.height*0.04,),
              buildImage(size, context),

              SizedBox(height: size.height*0.05,),
              buildName(size,context),

              SizedBox(height: size.height*0.03,),
              buildEmail(size,context),

              SizedBox(height: size.height*0.03,),
              buildAddress(size,context),

              SizedBox(height: size.height*0.03,),
            ],
          ),
        ),
      ),

    );
  }

  void updateProfile()async{
    if(nameController.text.isEmpty){
      showToastMessage('Name is required!');
    }
    else{
      customDialog();

      var imagePath=myImage == null ? '' : myImage!.path;
      var result= await authenticationController.updateCompanyInfo(nameController.text, emailController.text, addressController.text, imagePath);
      await authenticationController.showUser();

      closeDialog();

      if(result!=null){
        showToastMessage(result);
        //_setUserData();
      }
    }
  }

  Widget buildImage(Size size, BuildContext context){
    return InkWell(
      onTap: (){
        buildBottomSheet(size, context);
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: size.height*0.2,
        width: size.height*0.2,
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
                borderRadius: BorderRadius.circular(100),
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
        )
            :
        Center(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 5
                )
              ],
              image: DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.colorBurn),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName(Size size, BuildContext context){
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
            labelText: AppLocalizations.of(context)!.company_businessName,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildEmail(Size size, BuildContext context){
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
            labelText: AppLocalizations.of(context)!.emailAddress,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildAddress(Size size , BuildContext context){
    return SizedBox(
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: addressController,
          maxLines: 1,
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.address,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildWebsite(Size size, BuildContext context, webUrl){
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
            labelText: AppLocalizations.of(context)!.website,
            border: OutlineInputBorder(),
          ),
        ),
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
}
