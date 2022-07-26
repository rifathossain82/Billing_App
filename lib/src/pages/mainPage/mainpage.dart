import 'package:billing_app/src/widgets/confirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constaints/colors/AppColors.dart';
import '../../provider/localProvider.dart';
import '../../widgets/myAppbar.dart';
import '../../widgets/navigation_drawer/NavigationDrawer.dart';
import '../bottomNavBarPage/Dashboard.dart';
import '../bottomNavBarPage/homepage.dart';
import '../bottomNavBarPage/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  //index for bottom navigation
  int index_ = 0;

  final pages = [
    Homepage(),
    Dashboard(),
    Settings(),
  ];

  /// create a key for the scaffold in order to access it later.
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //when user want to exit app then first save his language in local storage
  void setLocale() async {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('language', provider.locale.toString());

    print(provider.locale.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //to close drawer
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }

        final showPopUp = await confirmationDialog(
          context: context,
          title: AppLocalizations.of(context)!.appExitMsg,
          negativeActionText: AppLocalizations.of(context)!.no,
          positiveActionText: AppLocalizations.of(context)!.yes,
        );

        if(showPopUp==true){
          setLocale();
        }

        return showPopUp ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: myAppBar,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: mainColor,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: mainColor.withOpacity(0.2),
                color: Colors.black38,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: AppLocalizations.of(context)!.home,
                  ),
                  GButton(
                    icon: Icons.dashboard,
                    text: AppLocalizations.of(context)!.dashboard,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: AppLocalizations.of(context)!.settings,
                  ),
                ],
                selectedIndex: index_,
                onTabChange: (index) {
                  setState(() {
                    index_ = index;
                  });
                },
              ),
            ),
          ),
        ),
        body: pages[index_],
        drawer: NavigationDrawer(),
      ),
    );
  }
}
