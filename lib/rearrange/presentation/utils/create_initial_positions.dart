import 'package:flutter/material.dart';

class CreateInitialPos {
  final int index;
  final BuildContext context;

  CreateInitialPos({required this.index, required this.context});

  Offset createPost() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double wF = width / 3;
    double hF = height / 2;
    double top = 0;
    double left = 0;
    double size = 1;
    switch (index) {
      case 0:
        left = 0;
        top = 0;
        break;
      case 1:
        left = wF;
        top = 0;
        break;
      case 2:
        left = wF * 2;
        top = 0;
        break;
      case 3:
        left = 0;
        top = hF;
        break;
      case 4:
        left = wF;
        top = hF;
        break;
      case 5:
        left = wF * 2;
        top = hF;
        break;
    }

    return Offset(left, top);
  }

  static Offset checkBounds(Offset position, double maxWidth, double maxHeight,
      double imageWidth, double imageHeight) {
    print(
        "maxWidth : ${maxWidth}, maxHeight : ${maxHeight},image ${imageWidth} $imageHeight");
    double newX = position.dx.clamp(0, maxWidth - imageWidth);
    double newY = position.dy.clamp(0, maxHeight - imageHeight);

    return Offset(newX, newY);
  }
}
