// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/pages/profile_page/profile_controller.dart';
import 'package:studify/utils/consts/app_colors.dart';
import 'package:studify/widgets/textField.dart';

import '../../routes/routes.dart';
import '../../services/auth.dart';
import '../../services/db.dart';
import '../../utils/consts/app_colors.dart';
import '../../widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  ProfileController controller = Get.put<ProfileController>(ProfileController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
                CircleAvatar(
                  radius: 83,
                  backgroundColor: Colors.redAccent,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage:
                    Auth.instance.USER.photoUrl == ''
                        ? AssetImage('assets/images/user.png')
                        : NetworkImage(Auth.instance.USER.photoUrl!,
                        scale: .25) as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                )
              ],
            ),
            Positioned(
              top: Get.height * 0.21,
              left: Get.width * 0.6,
              child: CircleAvatar(
                radius: 23,
                backgroundColor: Colors.redAccent,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: kBackground,),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.35,
              child: SizedBox(
                height: Get.height * 0.06,
                width: Get.width * 0.6,
                child: DefaultTextField(
                  hintText: 'Name',
                  controller: _nameController
                    ..text = '${Auth.instance.USER.name}',
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.45,
              child: SizedBox(
                height: Get.height * 0.06,
                width: Get.width * 0.6,
                child: DefaultTextField(
                  hintText: 'Change Email',
                  controller: _emailController,
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.55,
              child: SizedBox(
                height: Get.height * 0.06,
                width: Get.width * 0.6,
                child: FloatingActionButton(
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.ubuntu(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      'Password Reset Email Sent',
                      'An email has been sent to you with a link to reset your password. If you do not see it in your inbox, please check your spam folder.',
                      backgroundColor: Colors.green,
                    );
                    Auth.instance.sendPasswordResetEmail(Auth.instance.USER.email);
                  },
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
                  onPressed: () {
                    ///update name
                    if(_nameController.text != Auth.instance.USER.name) {
                      Auth.instance.USER.name = _nameController.text;
                      //FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text);
                      DB.instance.user.update({'name': _nameController.text});
                    }
                    ///update email
                    if(_emailController.text.isNotEmpty && controller.isEmailValid(_emailController.text).value) {
                      Auth.instance.USER.email = _emailController.text;
                      //FirebaseAuth.instance.currentUser?.updateEmail(_emailController.text);
                      DB.instance.user.update({'email': _emailController.text});
                    }
                    debugPrint('${Auth.instance.USER.name}, ${Auth.instance.USER.email}');

                    Get.snackbar('Success', 'Your information was updated successfully',
                        backgroundColor: Colors.green);
                  },
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
