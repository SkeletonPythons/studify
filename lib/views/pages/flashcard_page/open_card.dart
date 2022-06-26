// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';
import 'dart:math';

import '../../../models/flashcard_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';
import '../../../utils/sample_cards.dart';
import '../../../controllers/flashcard_controller.dart';

class OpenCard extends StatelessWidget {
  const OpenCard({required this.note, required this.callback, Key? key})
      : super(key: key);

  final VoidCallback callback;
  final Note note;

  @override
  Widget build(BuildContext context) {
    final OC oc = Get.put(OC(note));
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 8),
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          color: kBackgroundLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: callback,
                  ),
                  TextField(
                    controller: oc.titleController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        note.isFav ? Icons.favorite : Icons.favorite_border,
                        color: note.isFav ? Colors.redAccent : Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                        oc.editEnabled.value ? Icons.lock_open : Icons.lock,
                        color: oc.editEnabled.value
                            ? Colors.lightBlueAccent
                            : Colors.redAccent),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: kBackgroundLight3,
                        constraints: BoxConstraints(
                            maxHeight: Get.height * .6,
                            maxWidth: Get.width * .6),
                        child: TextField(
                          controller: oc.contentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Content',
                            hintStyle: GoogleFonts.ubuntu(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: GoogleFonts.ubuntu(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: kBackgroundLight3,
                        constraints: BoxConstraints(
                            maxHeight: Get.height * .3,
                            maxWidth: Get.width * .3),
                        child: TextField(
                          controller: oc.frontController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Front',
                            hintStyle: GoogleFonts.ubuntu(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: GoogleFonts.ubuntu(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: kBackgroundLight3,
                        constraints: BoxConstraints(
                            maxHeight: Get.height * .3,
                            maxWidth: Get.width * .3),
                        child: TextField(
                          controller: oc.frontController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Back',
                            hintStyle: GoogleFonts.ubuntu(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: GoogleFonts.ubuntu(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OC extends GetxController {
  OC(this.note);
  final RxBool editEnabled = RxBool(false);
  final RxBool fav = RxBool(false);

  final Note note;

  void toggleEdit() {
    editEnabled.value = !editEnabled.value;
  }

  late TextEditingController frontController;
  late TextEditingController backController;
  late TextEditingController titleController;
  late TextEditingController tagsController;
  late TextEditingController contentController;

  @override
  void onInit() {
    super.onInit();
    frontController = TextEditingController(text: note.front);
    backController = TextEditingController(text: note.back);
    titleController = TextEditingController(text: note.title);
    tagsController = TextEditingController();
    contentController = TextEditingController(text: note.content);
  }

  @override
  void onClose() {
    frontController.dispose();
    backController.dispose();
    titleController.dispose();
    super.onClose();
  }

  void toggleFav(Note note) async {
    note.isFav = !note.isFav;
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('flashcards')
          .doc(note.id)
          .update({
        'isFav': note.isFav,
      }).then((value) => fav.toggle);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
