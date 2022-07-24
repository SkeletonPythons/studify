// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/utils/consts/app_colors.dart';

import '../../routes/routes.dart';
import '../../services/auth.dart';
import '../../utils/consts/app_colors.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: kBackground,
            title: Text('Profile'),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 120, bottom: 20),
                child: Text(
                  'Profile',
                  style: GoogleFonts.ubuntu(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.16,
                width: Get.width * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: Auth.instance.USER.photoUrl == ''
                        ? AssetImage('assets/images/user.png')
                        : NetworkImage(Auth.instance.USER.photoUrl!, scale: .25)
                    as ImageProvider,
                  ),
                ),
              ),
            ],
          )
        ], // children
      ),
    );
  }
}
