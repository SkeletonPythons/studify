import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, y)
      ..lineTo(x * .2, y)
      ..conicTo(0, y, 0, y * .8, 1)
      ..close();
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
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
      clipper: CustomClip(),
      clipBehavior: Clip.hardEdge,
      child: RawMaterialButton(
        fillColor: color,
        onPressed: onPressed,
        child: CustomPaint(
          painter: TrianglePainter(
            strokeColor: Colors.blue,
            strokeWidth: 10,
            paintingStyle: PaintingStyle.fill,
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: 60,
            width: 60,
            alignment: const Alignment(-.6, .6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: icon ?? const Icon(FontAwesomeIcons.plus),
          ),
        ),
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .2, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
