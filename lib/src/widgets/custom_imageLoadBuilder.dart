import 'package:flutter/material.dart';

import '../constaints/colors/AppColors.dart';

ImageLoadingBuilder custom_imageLoadBuilder(){
  return (context, image, loadingProgress){
    if (loadingProgress == null) {
      return image;
    }else {
      return SizedBox(
        child: Center(
          child: Image.asset('assets/icons/loading.gif'),
        ),
      );
    }
  };
}