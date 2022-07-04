// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/apptheme.dart';
import '../../utils/consts/app_colors.dart';

typedef SaveTag = void Function(String tag);
typedef DeleteTag = void Function(String tag);

class NoteTags extends StatelessWidget {
  NoteTags(this.tags, this.controller,
      {required this.saveTag, required this.deleteTag, Key? key})
      : super(key: key);

  final List<String>? tags;
  final TextEditingController controller;

  final SaveTag saveTag;
  final DeleteTag deleteTag;

  late final RxString text = controller.text.obs;

  RxList<Chip> getTags(List<String> tags) {
    final List<Chip> chips = [];
    for (final tag in tags) {
      Color? bkng = acnts[Random().nextInt(acnts.length - 1)];
      chips.add(Chip(
        elevation: 8,
        label: Text(tag),
        backgroundColor: bkng,
        labelStyle: GoogleFonts.anonymousPro(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ));
    }
    return chips.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Wrap(
              spacing: 4,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: getTags(tags!),
            )),
        Container(
          width: Get.width * .9,
          height: Get.height * .05,
          decoration: BoxDecoration(
            color: kBackgroundLight2,
            borderRadius: BorderRadius.circular(10),
            // ignore: prefer_const_literals_to_create_immutables
          ),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.logicalKey == LogicalKeyboardKey.backspace &&
                  controller.text.isEmpty) {
                controller.text = tags!.last;
                text.value = tags!.last;
                deleteTag(tags!.last);
                tags!.removeLast();
              }
            },
            child: Obx(() => TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  controller: controller..text = text.value,
                  onEditingComplete: () {
                    if (controller.text.isNotEmpty) {
                      for (String word in controller.text.split(' ')) {
                        if (word.isNotEmpty) {
                          tags!.add(word);
                          saveTag(word);
                        }
                      }
                    }
                  },
                  onChanged: (value) {
                    if (text.isEmpty) {
                    } else if (text.value.endsWith(' ')) {
                      saveTag(text.trim());
                      controller.clear();
                      debugPrint('saving tag');
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                    hintText: 'Add tag',
                  ),
                )),
          ),
        )
      ],
    );
  }
}
