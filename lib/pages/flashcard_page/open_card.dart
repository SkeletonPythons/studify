// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/flashcard_model.dart';
import '../../utils/consts/app_colors.dart';
import 'flashcard_controller.dart';
import 'open_controller.dart';

class OpenCard extends GetWidget<OC> {
  const OpenCard({required this.note, required this.callback, Key? key})
      : super(key: key);

  final VoidCallback callback;
  final Note note;
  @override
  Widget build(BuildContext context) {
    controller.frontController.text = note.front ?? '';
    controller.backController.text = note.back ?? '';
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
                              icon: Icon(
                                note.isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
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
                      height: Get.height * .07,
                      width: Get.width * .9,
                      padding: const EdgeInsets.only(top: 5),
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
                              labelText: 'title',
                              labelStyle: GoogleFonts.neucha(
                                fontSize: 20,
                              ),
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
                            controller: controller.titleController,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) =>
                          controller.onDrag(details),
                      onHorizontalDragEnd: (details) => controller.dragEnd(),
                      child: Obx(
                        () => Container(
                          constraints: BoxConstraints(
                              maxHeight: Get.height * .2,
                              maxWidth: Get.width * .9),
                          width: Get.width * .9,
                          clipBehavior: Clip.antiAlias,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(controller.flipValue.value * pi),
                          transformAlignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kBackgroundLight2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Obx(() => controller.flipValue <= 0.5
                              ? TextField(
                                  onChanged: (value) => note.front = value,
                                  onEditingComplete: () =>
                                      controller.onEditComplete(note),
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'front',
                                    labelStyle: GoogleFonts.neucha(
                                      fontSize: 34,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.greenAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintStyle: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: kBackgroundDark,
                                    ),
                                  ),
                                  enabled: controller.editEnabled.value,
                                  controller: controller.frontController,
                                )
                              : Transform.scale(
                                  scaleX: -1,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    onChanged: (value) => note.back = value,
                                    onEditingComplete: () =>
                                        controller.onEditComplete(note),
                                    expands: true,
                                    maxLines: null,
                                    minLines: null,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'back',
                                      labelStyle: GoogleFonts.neucha(
                                        fontSize: 34,
                                      ),
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
                                        fontSize: 18,
                                        color: kBackgroundDark,
                                      ),
                                    ),
                                    enabled: controller.editEnabled.value,
                                    controller: controller.backController,
                                  ),
                                )),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    constraints: BoxConstraints(
                      minHeight: Get.height * .27,
                      minWidth: Get.width * .9,
                      maxWidth: Get.width * .9,
                      maxHeight: Get.height * .27,
                    ),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: Get.height * .3,
                    width: Get.width * .9,
                    clipBehavior: Clip.hardEdge,
                    transformAlignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kBackgroundLight2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      onChanged: (value) => note.content = value,
                      onEditingComplete: () => controller.onEditComplete(note),
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: 'notes',
                        border: InputBorder.none,
                        labelStyle: GoogleFonts.neucha(
                          fontSize: 50,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
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
                    ),
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
                            Obx(() => ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      Size(
                                        Get.width * .1,
                                        Get.height * .06,
                                      ),
                                    ),
                                    backgroundColor:
                                        controller.state.value == CardState.BACK
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.greenAccent)
                                            : MaterialStateProperty.all<Color>(
                                                Colors.blueGrey[800]!),
                                  ),
                                  onPressed: () => controller.flipBackward(),
                                  child: FaIcon(FontAwesomeIcons.rotateLeft),
                                )),
                            Obx(() => ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              controller.editEnabled.value
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(Size(
                                              Get.width * .01,
                                              Get.height * .06))),
                                  onPressed: () => controller.toggleEdit(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Obx(() => Icon(
                                          controller.editEnabled.value
                                              ? Icons.edit
                                              : Icons.edit_off)),
                                      Text('edit'),
                                    ],
                                  ),
                                )),
                            Obx(() => ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              controller.state.value ==
                                                      CardState.FRONT
                                                  ? Colors.greenAccent
                                                  : Colors.blueGrey[800]),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(Size(
                                              Get.width * .1,
                                              Get.height * .06))),
                                  onPressed: () => controller.flipFoward(),
                                  child:
                                      FaIcon(FontAwesomeIcons.arrowRotateRight),
                                )),
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
