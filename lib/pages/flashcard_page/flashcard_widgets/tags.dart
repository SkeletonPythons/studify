// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global_controller.dart';
import '../../../models/note_model.dart';
import '../../../themes/apptheme.dart';
import '../../../utils/consts/app_colors.dart';

class NoteTags extends StatefulWidget {
  const NoteTags({required this.note, required this.enabled, Key? key})
      : super(key: key);

  final Note note;
  final RxBool enabled;

  @override
  State<NoteTags> createState() => _NoteTagsState();
}

class _NoteTagsState extends State<NoteTags>
    with SingleTickerProviderStateMixin {
  RxList<Chip> chips = <Chip>[].obs;

  late TextEditingController controller;

  late AnimationController animationControl;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    animationControl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOutCirc))
        .animate(animationControl);
  }

  RxList<Widget> get tList {
    final List<Widget> chips = <Widget>[];
    int colorIndex = 0;

    for (String tag in widget.note.tags!) {
      chips.add(InkWell(
        onTap: () {
          if (!Get.isSnackbarOpen) {
            Get.snackbar('Delete tag?', 'Long press on tags to delete them.');
          }
        },
        onLongPress: () {
          setState(() {
            animationControl
                .forward()
                .then((value) => widget.note.tags!.remove(tag))
                .then((value) => animationControl.reset());
          });
        },
        child: Chip(
          elevation: 8,
          label: Text(tag.toUpperCase()),
          backgroundColor: acnts[colorIndex],
          labelStyle: GoogleFonts.anonymousPro(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ));
      colorIndex = (colorIndex + 1) % acnts.length;
    }

    return chips.obs;
  }

  List<Color?> acnts = [
    Colors.redAccent[100],
    Colors.blueAccent[100],
    Colors.greenAccent[100],
    Colors.yellowAccent[100],
    Colors.orangeAccent[100],
    Colors.purpleAccent[100],
    Colors.grey[100],
    Colors.cyanAccent[100],
    Colors.indigoAccent[100],
    Colors.tealAccent[100],
    Colors.limeAccent[100],
    Colors.amberAccent[100],
    Colors.deepOrangeAccent[100],
    Colors.deepPurpleAccent[100],
    Colors.indigoAccent[100],
    Colors.lightBlueAccent[100],
    Colors.lightGreenAccent[100],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kBackgroundDark,
          height: Get.height * .05,
          width: Get.width * .9,
          child: Obx(
            () => Wrap(
              spacing: 4,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: tList,
            ),
          ),
        ),
        Container(
            width: Get.width * .9,
            height: Get.height * .05,
            decoration: BoxDecoration(
              color: kBackgroundLight2,
              borderRadius: BorderRadius.circular(10),
              // ignore: prefer_const_literals_to_create_immutables
            ),
            child: Obx(
              () => TextField(
                maxLines: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textAlign: TextAlign.start,
                controller: controller,
                clipBehavior: Clip.none,
                enabled: widget.enabled.value,
                textInputAction: TextInputAction.done,
                onChanged: (_) {
                  setState(
                    () {
                      if (controller.text.isNotEmpty &&
                          controller.text.endsWith(' ')) {
                        String newTag = controller.text.toLowerCase().trim();
                        widget.note.tags!.add(newTag);

                        setState(() {
                          controller.clear();
                        });
                      }
                    },
                  );
                },
                onSubmitted: (_) {
                  setState(
                    () {
                      if (controller.text.isNotEmpty) {
                        String newTag = controller.text.toLowerCase().trim();
                        widget.note.tags!.add(newTag);

                        setState(() {
                          controller.clear();
                        });
                      }
                    },
                  );
                },
                buildCounter: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'tags',
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
                      borderSide: BorderSide(color: GC.accent.value, width: 1)),
                ),
              ),
            )),
      ],
    );
  }
}
