// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:studify/utils/consts/app_colors.dart';

import '../../../models/flashcard_model.dart';
import '../../../services/db.dart';
import '../note_controller.dart';

class FCMenu extends StatelessWidget {
  FCMenu({
    Key? key,
  }) : super(key: key);

  SideMenuController controller = Get.put(SideMenuController());

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Obx(
        () => AnimatedContainer(
          height: controller.menuHeight.value,
          duration: const Duration(milliseconds: 500),
          width: Get.width * 0.25,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: Color(0xcc212121),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Transform.rotate(
                    angle: controller.angle.value,
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.angleUp,
                        size: 40,
                      ),
                      color: kAccent,
                      onPressed: () {
                        debugPrint('togglep');
                        controller.toggleMenu();
                      },
                    ),
                  )),
              Obx(
                () => Visibility(
                  visible: controller.menuOpen.value,
                  child: Obx(() => AnimatedOpacity(
                        opacity: controller.opacity.value,
                        duration: const Duration(milliseconds: 500),
                        child: Obx(
                          () => Column(
                            children: controller.menuOpen.value
                                ? controller.menuWidgets
                                : [],
                          ),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SideMenuController extends GetxController
    with GetTickerProviderStateMixin {
  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    iconAnimation = animationController.drive(
      Tween<double>(
        begin: 0,
        end: pi,
      ),
    )..addListener(() {
        angle.value = iconAnimation.value;
      });
    super.onInit();
  }

  late AnimationController animationController;
  late Animation<double> iconAnimation;

  final RxDouble menuHeight = (Get.height * 0.1).obs;

  final menuOpen = false.obs;

  final menuWidgets = <Widget>[
    IconButton(
      onPressed: () {
        Note newNote = Note.newLocal();
        DB.instance.notes.doc(newNote.id).set(newNote, SetOptions(merge: true));
      },
      icon: Icon(Icons.add),
    )
  ].obs;

  final visibility = false.obs;

  final RxDouble angle = 0.0.obs;

  void toggleMenu() {
    debugPrint('iconAnimation.value: ${iconAnimation.value}');
    if (menuOpen.value) {
      menuHeight.value = Get.height * 0.1;
      opacity.value = 0;
      animationController.reverse();
    } else {
      menuHeight.value = Get.height * .3;
      animationController.forward().then((value) => opacity.value = 1);
    }
    menuOpen.toggle();
  }

  RxDouble opacity = 0.0.obs;
}
