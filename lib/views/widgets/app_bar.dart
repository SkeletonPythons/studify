// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar(this.onSideMenuTap, {Key? key}) : super(key: key);

  final String sideMenuIcon = 'assets/icons/menu-burger.png';
  final String logo = 'assets/images/studify_logo.png';

  final VoidCallback onSideMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[800],
        elevation: 4,
        centerTitle: true,
        title: Image.asset(
          logo,
          height: 40,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.red,
            size: 36,
          ),
          // icon: Image.asset(sideMenuIcon,
          //     fit: BoxFit.fill, color: Colors.red[900], height: 50, width: 50),
          onPressed: () => onSideMenuTap(),
        ),
        actions: []);
  }
}
