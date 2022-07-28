import 'package:flutter/material.dart';

class ProfileHeader extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color=Colors.redAccent;
    final path = Path()
    ..relativeLineTo(0, 70)
    ..quadraticBezierTo(size.width/2, 170, size.width, 70)
    ..relativeLineTo(0, -70)
    ..close();


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}