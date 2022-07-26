import 'package:flutter/material.dart';

import '../../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/customExpansionTile.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {

  int _tileIndex=-1;


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help,),
        foregroundColor: myblack,
        elevation: 0,
        centerTitle: true,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index){
            return buildQuestions(size, index);
          },
        ),
      ),
    );
  }

  Widget buildQuestions(Size size, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              //color: Colors.black.withOpacity(0.05)
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: AppExpansionTile(
              title: const Text('What is Billing App?',style: TextStyle(color: Colors.black54),),
              trailing: Icon(Icons.keyboard_arrow_down, size: 14,),
              childrenPadding: const EdgeInsets.only(left: 16,bottom: 8),
              expandedAlignment: Alignment.centerLeft,
              initiallyExpanded: _tileIndex == index,
              children: [
                Text('There are many who move from one city to another for temporary work. And they have to stay in hotels with high prices and many times good hotels do not match. Our small effort to overcome their difficulties. One can get a house at a low price, the other can also make some income by sharing their unused room.',style: TextStyle(fontSize: 14),),
                SizedBox(height: 8,),
                Text('Finally, we will give you the opportunity to benefit financially.'),
              ],

              ///to select single tile
              onExpansionChanged: (s) {
                if (_tileIndex == index) {
                  _tileIndex = -1;
                  setState(() {});
                }
                else {
                  setState(() {
                    _tileIndex = index;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

