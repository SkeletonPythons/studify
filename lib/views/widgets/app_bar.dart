// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({Key? key}) : super(key: key);

  final String sideMenuIcon = 'assets/icons/menu-burger.png';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[900],
      elevation: 4,
      centerTitle: true,
      title: Row(
        children: <Widget>[
          SizedBox(
            height: 37,
            width: 37,
            child: IconButton(
              icon: Image.asset(sideMenuIcon),
              onPressed: () => {},
            ),
          ),
          SizedBox(
            height: 10,
            width: 10,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 10, 8),
            child: CircleAvatar(
              onBackgroundImageError: (value, trace) {},
              backgroundImage: AssetImage(
                  'assets/images/user.png'), //Changed to this for now because, since it still can't grab the actual user name, when maneuvering away from the page the name would clear and crash the app
              radius: 25,
            ),
          ),
        ],
      ),
    );
  }
}
