import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var authenticationController=Get.find<AuthenticationController>();

  var user;

  @override
  void initState() {
    user=authenticationController.user[0];
    super.initState();
  }

  getUser()async{
    await authenticationController==Get.find<AuthenticationController>();
    setState(() {
      user=authenticationController.user[0];
    });
    print(user.name);
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profilePageTitle,),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
              onPressed: ()async{
                await Get.toNamed(RouteGenerator.updateProfilePage);
                getUser();
              },
              icon: Icon(Icons.edit)
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [

              //profile image is here
              SizedBox(height: size.height*0.04,),
              buildImage(size, context, user.avatar),

              //name and id is here
              SizedBox(height: size.height*0.04,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '${user.name}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: mainColor
                    ),
                  ),
                  SizedBox(height: size.height*0.01,),
                  Text('${user.countryCode}${user.mobile}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: mainColor),),


                ],
              ),

              //daily transaction card is here
              SizedBox(height: size.height*0.03,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.dailyTransaction,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                        Divider(),
                        SizedBox(height: size.height*0.02,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.sales,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            Text('17500.00 tk',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                          ],
                        ),
                        SizedBox(height: size.height*0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.due,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            Text('5200.00 tk',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                          ],
                        ),
                        SizedBox(height: size.height*0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.promo,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                            Text('0.00 tk',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),

    );
  }

  Widget buildImage(Size size, BuildContext context, imgUrl){
    return Container(
      height: size.height*0.2,
      width: size.height*0.2,
      child: Center(
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
        )
      ),
    );
  }
}

/*
Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 1,color: myblack),
                image: DecorationImage(
                  fit: BoxFit.fitWidth, image: NetworkImage(imgUrl),
                )
            ),
          )
 */
