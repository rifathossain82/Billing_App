import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constaints/colors/AppColors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? _image='https://www.thetimes.co.uk/imageserver/image/%2Fmethode%2Ftimes%2Fprod%2Fweb%2Fbin%2F27ef5aea-eb81-11e9-b931-c019e957f02a.jpg?crop=2222%2C1481%2C0%2C0';

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, RouteGenerator.updateProfilePage);
              },
              icon: Icon(Icons.edit)
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TyperAnimatedTextKit(
                  text: ['Brother\'s Pizza Hut'],
                  textStyle: GoogleFonts.inter(
                      fontSize: 26,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      color: mainColor),
                  speed: Duration(milliseconds: 200),
                ),
                SizedBox(height: size.height*0.01,),
                Text('01882508771',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: mainColor),),

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
                          Text('Daily Transaction',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                          Divider(),
                          SizedBox(height: size.height*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sales',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                              Text('17500.00 tk',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          SizedBox(height: size.height*0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Due',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                              Text('5200.00 tk',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          SizedBox(height: size.height*0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Promo',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
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
          ],
        ),
      ),

    );
  }

  Widget buildImage(Size size, BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width/4),
      child: Container(
        height: size.height*0.15,
        child: Center(
          child: _image==null?
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 1,color: myblack),
            ),
            child: Center(child: Text('No Pictures Yet')),
          )
              :
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 1,color: myblack),
                image: DecorationImage(
                  fit: BoxFit.fitWidth, image: NetworkImage(_image!),
                )
            ),
          ),
        ),
      ),
    );
  }
}
