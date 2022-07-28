// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/utils/consts/app_colors.dart';
import 'package:studify/widgets/textField.dart';

import '../../routes/routes.dart';
import '../../services/auth.dart';
import '../../utils/consts/app_colors.dart';
import '../../widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.redAccent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: ProfileHeader(),
              child: Container(
                height: Get.height,
                width: double.infinity,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
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
                          : NetworkImage(Auth.instance.USER.photoUrl!,
                              scale: .25) as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: Get.height * 0.15,
              left: Get.width * 0.6,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.30,
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.width * 0.5,
                child: DefaultTextField(
                  hintText: 'Name',
                  controller: _nameController
                    ..text = '${Auth.instance.USER.name}',
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.40,
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.width * 0.5,
                child: DefaultTextField(
                  hintText: 'Change Email',
                  controller: _emailController,
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.50,
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.width * 0.5,
                child: DefaultTextField(
                  hintText: 'Change Password',
                  controller: _passwordController,
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.65,
              child: SizedBox(
                height: Get.height * 0.06,
                width: Get.width * 0.2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    shadowColor: kBackgroundDark,
                    elevation: 5,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Save',
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ], // children
        ),
      ),
    );
  }
}
