import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studify/consts/colors.dart';

class MyWidget extends StatelessWidget {
  /// This is a custom button widget created to have uniformity in the app.
  /// onPressed is required. The text must be null if child is used and vice versa.
  const MyWidget({
    required this.onPressed,
    this.width = 100,
    this.height = 50,
    this.textColor = kBackgroundLight,
    this.text,
    this.child,
    this.radius = 12,
    Key? key}) :
    super(key: key);
    

    
  final void Function() onPressed;
  final double? width;
  final double? height;
  final double? radius;
  final Color? textColor;
  final String? text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: kBackgroundLight2,
            borderRadius: BorderRadius.circular(radius!),
          ),
        ),
      ),
    );
    
  }
}
