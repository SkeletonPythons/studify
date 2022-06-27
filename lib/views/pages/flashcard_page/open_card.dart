// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';
import 'dart:math';

import '../../../models/flashcard_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';
import '../../../utils/sample_cards.dart';
import '../../../controllers/flashcard_controller.dart';

class OpenCard extends GetWidget<OC> {
  OpenCard({required this.note, required this.callback, Key? key})
      : super(key: key);

  final VoidCallback callback;
  final Note note;
  @override
  Widget build(BuildContext context) {
    controller.frontController.text = note.front;
    controller.backController.text = note.back;
    controller.titleController.text = note.title ?? '';
    controller.contentController.text = note.content ?? '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 15, 4, 4),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: kBackgroundDark,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              decoration: BoxDecoration(
                color: kBackgroundDark,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          elevation: 4,
                          borderRadius: BorderRadius.circular(10),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: kAccent,
                            ),
                            onPressed: () => callback(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          elevation: 4,
                          borderRadius: BorderRadius.circular(10),
                          child: IconButton(
                              icon: Obx(() => Icon(
                                    controller.fav.value
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: controller.fav.value
                                        ? Colors.redAccent
                                        : kBackgroundDark,
                                  )),
                              onPressed: () => controller.toggleFav(note)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          elevation: 4,
                          borderRadius: BorderRadius.circular(10),
                          child: IconButton(
                            icon: Obx(
                              () => FaIcon(
                                controller.editEnabled.value
                                    ? FontAwesomeIcons.dumpsterFire
                                    : FontAwesomeIcons.toiletPaperSlash,
                                color: controller.editEnabled.value
                                    ? Colors.redAccent
                                    : kBackgroundDark,
                              ),
                            ),
                            onPressed: () => controller.editEnabled.value
                                ? Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: 'Delete',
                                    content: Text(
                                        'Are you sure you want to delete this card?'),
                                    cancel: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () => Get.back(),
                                    ),
                                    confirm: ElevatedButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        controller.deleteNote(note);
                                        Get.back();
                                        Get.back();
                                      },
                                    ),
                                  )
                                : {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      height: Get.height * .06,
                      width: Get.width * .9,
                      decoration: BoxDecoration(
                        color: kBackgroundLight2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => TextField(
                            onChanged: (value) => note.title = value,
                            onEditingComplete: () =>
                                controller.onEditComplete(note),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.greenAccent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: GoogleFonts.roboto(
                                fontSize: Get.height * .02,
                                color: kBackgroundDark,
                              ),
                            ),
                            enabled: controller.editEnabled.value,
                            controller: controller.contentController,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Obx(() => AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          transform:
                              Matrix4.rotationY(controller.rotation.value),
                          height: Get.height * .55,
                          width: Get.width * .9,
                          clipBehavior: Clip.hardEdge,
                          transformAlignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kBackgroundLight2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Obx(
                            () => controller.state.value == CardState.CONTENT
                                ? TextField(
                                    onChanged: (value) => note.content = value,
                                    onEditingComplete: () =>
                                        controller.onEditComplete(note),
                                    expands: true,
                                    maxLines: null,
                                    minLines: null,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Content',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintStyle: GoogleFonts.roboto(
                                        fontSize: Get.height * .02,
                                        color: kBackgroundDark,
                                      ),
                                    ),
                                    enabled: controller.editEnabled.value,
                                    controller: controller.contentController,
                                  )
                                : controller.state.value == CardState.FRONT
                                    ? TextField(
                                        onChanged: (value) =>
                                            note.front = value,
                                        onEditingComplete: () =>
                                            controller.onEditComplete(note),
                                        expands: true,
                                        maxLines: null,
                                        minLines: null,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Front of card',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 5),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.greenAccent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintStyle: GoogleFonts.roboto(
                                            fontSize: Get.height * .02,
                                            color: kBackgroundDark,
                                          ),
                                        ),
                                        enabled: controller.editEnabled.value,
                                        controller: controller.frontController,
                                      )
                                    : TextField(
                                        onChanged: (value) => note.back = value,
                                        onEditingComplete: () =>
                                            controller.onEditComplete(note),
                                        expands: true,
                                        maxLines: null,
                                        minLines: null,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Back of card',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 5),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.greenAccent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintStyle: GoogleFonts.roboto(
                                            fontSize: Get.height * .02,
                                            color: kBackgroundDark,
                                          ),
                                        ),
                                        enabled: controller.editEnabled.value,
                                        controller: controller.backController,
                                      ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      height: Get.height * .1,
                      width: Get.width * .9,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      Size(Get.width * .2, Get.height * .1))),
                              onPressed: () => controller.flipBackwards(),
                              child: FaIcon(FontAwesomeIcons.rotateLeft),
                            ),
                            Obx(() => ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              controller.editEnabled.value
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(Size(
                                              Get.width * .4,
                                              Get.height * .1))),
                                  onPressed: () => controller.toggleEdit(),
                                  child: Icon(controller.editEnabled.value
                                      ? Icons.edit
                                      : Icons.edit_off),
                                )),
                            ElevatedButton(
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      Size(Get.width * .2, Get.height * .1))),
                              onPressed: () => controller.flipForward(),
                              child: FaIcon(FontAwesomeIcons.arrowRotateRight),
                            ),
                          ]),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
