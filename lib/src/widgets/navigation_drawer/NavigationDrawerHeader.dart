import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constaints/colors/AppColors.dart';

class NavigationDrawerHeader extends StatefulWidget {
  NavigationDrawerHeader({Key? key, required this.imageUrl, required this.name})
      : super(key: key);

  String imageUrl;
  String name;

  @override
  State<NavigationDrawerHeader> createState() => _NavigationDrawerHeaderState();
}

class _NavigationDrawerHeaderState extends State<NavigationDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: CachedNetworkImageProvider('${widget.imageUrl}'),
        )),
        child: Stack(
          children: [
            Positioned(
                bottom: 8,
                left: 16,
                child: AutoSizeText(
                  widget.name,
                  style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      color: myWhite),
                ))
          ],
        ));
  }
}
