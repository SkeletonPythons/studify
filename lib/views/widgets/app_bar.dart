// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({Key? key}) : super(key: key);

  final String sideMenuIcon = 'assets/icons/menu-burger.png';
  final String logo = 'assets/images/studify_logo.png';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[800],
      elevation: 4,
      centerTitle: true,
      title: Row(
        children: <Widget>[
          SizedBox(
            height: 37,
            width: 37,
            child: IconButton(
              icon: Image.asset(sideMenuIcon, color: Colors.red[900]),
              onPressed: () => {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                onBackgroundImageError: (value, trace) {},
                backgroundImage: AssetImage(
                    'assets/images/user.png'), //Changed to this for now because, since it still can't grab the actual user name, when maneuvering away from the page the name would clear and crash the app
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, top: 10),
            child: SizedBox(
              height: 180,
              width: 180,
              child: Image.asset(logo),
            ),
          ),
        ],
      ),
    );
  }
}
