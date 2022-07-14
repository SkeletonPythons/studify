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

class OpenCard extends StatefulWidget {
  const OpenCard({required this.note, required this.callback, Key? key})
      : super(key: key);

  final Note note;
  final VoidCallback callback;

  @override
  State<OpenCard> createState() => _OpenCardState();
}

class _OpenCardState extends State<OpenCard> {
  late OC controller;

  @override
  initState() {
    super.initState();
    controller = Get.find<OC>();
    controller.setNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
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
                            onPressed: () {
                              widget.callback();
                            },
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
                                widget.note.isFav.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  controller.toggleFav(widget.note))),
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
                                        // controller.deleteNote();
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
                  Container(
                    height: Get.height * .06,
                    width: Get.width * .9,
                    decoration: BoxDecoration(
                      color: kBackgroundLight2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(
                      () => TextField(
                        onChanged: (_) {
                          controller.note.subject = controller.sc.text;
                        },
                        textAlignVertical: TextAlignVertical(y: -.95),
                        clipBehavior: Clip.none,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'subject',
                          labelStyle: GoogleFonts.neucha(
                            fontSize: 20,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: Get.width * .9,
                            maxHeight: Get.height * .07,
                            minHeight: Get.height * .07,
                            minWidth: Get.width * .9,
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: kAccent, width: 1)),
                        ),
                        enabled: controller.editEnabled.value,
                        controller: controller.sc,
                      ),
                    ),
                  ),
                  NoteTags(
                    note: widget.note,
                    enabled: controller.editEnabled,
                  ),
                  SizedBox(
                    height: Get.height * .015,
                  ),
                  GestureDetector(
                    onHorizontalDragUpdate: (details) =>
                        controller.onDrag(details),
                    onHorizontalDragEnd: (details) => controller.dragEnd(),
                    child: Obx(
                      () => Container(
                        constraints: BoxConstraints(
                            maxHeight: Get.height * .2,
                            maxWidth: Get.width * .9),
                        width: Get.width * .9,
                        clipBehavior: Clip.none,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(controller.flipValue.value * pi),
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kBackgroundLight2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(clipBehavior: Clip.none, children: [
                          Obx(() => controller.flipValue <= 0.5
                              ? TextField(
                                  onChanged: (value) =>
                                      widget.note.front = value,
                                  expands: true,
                                  clipBehavior: Clip.none,
                                  maxLines: null,
                                  minLines: null,
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical(y: -.95),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kAccent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff444444),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'front',
                                    labelStyle: GoogleFonts.neucha(
                                      fontSize: 20,
                                    ),
                                    contentPadding: const EdgeInsets.all(15),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.greenAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  enabled: controller.editEnabled.value,
                                  controller: controller.fc,
                                )
                              : Transform.scale(
                                  scaleX: -1,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: controller.bc,
                                    onChanged: (_) {
                                      setState(() {
                                        widget.note.back = controller.bc.text;
                                      });
                                    },
                                    maxLines: 10,
                                    clipBehavior: Clip.none,
                                    minLines: 10,
                                    textAlign: TextAlign.justify,
                                    textAlignVertical:
                                        TextAlignVertical(y: -.95),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff444444),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'back',
                                      labelStyle: GoogleFonts.neucha(
                                        fontSize: 20,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kAccent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    enabled: controller.editEnabled.value,
                                  ),
                                )),
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
                  SizedBox(
                    height: Get.height * .015,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: Get.height * .27,
                      minWidth: Get.width * .9,
                      maxWidth: Get.width * .9,
                      maxHeight: Get.height * .27,
                    ),
                    height: Get.height * .3,
                    width: Get.width * .9,
                    clipBehavior: Clip.none,
                    transformAlignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kBackgroundLight2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(
// !! content textfield --------------------------------------------------------
                      () => TextField(
                        onChanged: (_) {
                          setState(() {
                            widget.note.content = controller.bc.text;
                          });
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        controller: controller.cc,
                        textAlign: TextAlign.justify,
                        textAlignVertical: TextAlignVertical(y: -.9),
                        decoration: InputDecoration(
                          labelText: 'notes',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kAccent, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.neucha(
                            fontSize: 20,
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        enabled: controller.editEnabled.value,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .015,
                  ),
                  Container(
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
                ],
              )),
        ),
      ),
    );
  }
}

// typedef MyCallback<T> = void Function(T);

// class CustomTextField extends StatefulWidget {
//   CustomTextField(this.controller, {this.onChanged, Key? key})
//       : super(key: key);

//   final TextEditingController controller;
//   final MyCallback<String>? onChanged;

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged:(value) => widget.onChanged?.call(value),
//       controller: widget.controller,
//     );
//   }
// }
