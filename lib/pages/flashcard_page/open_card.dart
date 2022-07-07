// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/widgets/buttons/triangle_button.dart';

import '../../../models/flashcard_model.dart';
import '../../utils/consts/app_colors.dart';
import 'flashcard_controller.dart';
import 'open_controller.dart';
import './tags.dart';

class OpenCard extends StatelessWidget {
  OpenCard({required this.note, required this.callback, Key? key})
      : controller = OC(note),
        super(key: key);

  final OC controller;

  final VoidCallback callback;
  final Note note;
  @override
  Widget build(BuildContext context) {
    controller.frontController.text = note.front ?? '';
    controller.backController.text = note.back ?? '';
    controller.subjectController.text = note.subject ?? '';
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
                          child: Obx(() => IconButton(
                              icon: Icon(
                                note.isFav.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => controller.toggleFav(note))),
                        ),
                      ),
                      Obx(() => ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                backgroundColor: MaterialStateProperty.all(
                                    controller.editEnabled.value
                                        ? Colors.greenAccent
                                        : Colors.redAccent),
                                fixedSize: MaterialStateProperty.all<Size>(
                                    Size(Get.width * .01, Get.height * .06))),
                            onPressed: () => controller.toggleEdit(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(() => Icon(controller.editEnabled.value
                                    ? Icons.edit
                                    : Icons.edit_off)),
                                Text('edit'),
                              ],
                            ),
                          )),
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
                                    : FontAwesomeIcons.solidTrashCan,
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
                            onChanged: (value) => note.subject = value,
                            onEditingComplete: () =>
                                controller.onEditComplete(note),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'subject',
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
                            controller: controller.subjectController,
                          )),
                    ),
                  ),
                  NoteTags(
                    note.tags!,
                    controller.tagsController,
                    saveTag: (tag) {},
                    deleteTag: (tag) {},
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
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
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
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff444444),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        labelText: 'front',
                                        labelStyle: GoogleFonts.neucha(
                                          fontSize: 20,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      enabled: controller.editEnabled.value,
                                      controller: controller.frontController,
                                    )
                                  : Transform.scale(
                                      scaleX: -1,
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: TextField(
                                          onChanged: (value) =>
                                              note.back = value,
                                          onEditingComplete: () =>
                                              controller.onEditComplete(note),
                                          maxLines: 10,
                                          minLines: 10,
                                          textAlign: TextAlign.start,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff444444),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            labelText: 'back',
                                            labelStyle: GoogleFonts.neucha(
                                              fontSize: 20,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.greenAccent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          enabled: controller.editEnabled.value,
                                          controller: controller.backController,
                                        ),
                                      ),
                                    )),
                            ),
                            Positioned(
                              right: -15,
                              bottom: 0,
                              child: Transform.scale(
                                scaleX: -1,
                                child: TriangleButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.reply,
                                  ),
                                  onPressed:
                                      controller.state.value == CardState.FRONT
                                          ? () => controller.flipFoward()
                                          : () => controller.flipBackward(),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    constraints: BoxConstraints(
                      minHeight: Get.height * .27,
                      minWidth: Get.width * .9,
                      maxWidth: Get.width * .9,
                      maxHeight: Get.height * .27,
                    ),
                    height: Get.height * .3,
                    width: Get.width * .9,
                    clipBehavior: Clip.hardEdge,
                    transformAlignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kBackgroundLight2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => TextField(
                          onChanged: (value) => note.content = value,
                          onEditingComplete: () =>
                              controller.onEditComplete(note),
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelText: 'notes',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff444444),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: GoogleFonts.neucha(
                              fontSize: 20,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          enabled: controller.editEnabled.value,
                          controller: controller.contentController,
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
                          children: []),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
