import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studify/utils/consts/app_colors.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double rad = 10;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - rad)
      ..arcToPoint(Offset(rad, size.height),
          radius: Radius.circular(rad), clockwise: false)
      ..lineTo(size.width, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => oldClipper != this;
}

class TriangleButton extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? color;
  const TriangleButton({this.color, this.icon, this.onPressed, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipBehavior: Clip.hardEdge,
      clipper: MyCustomClipper(),
      child: SizedBox(
        height: 60,
        width: 60,
        child: ElevatedButton.icon(
          style: ButtonStyle(alignment: Alignment(-1, .8)),
          icon: icon!,
          onPressed: onPressed,
          label: SizedBox.shrink(),
        ),
      ),
    );
  }
}
