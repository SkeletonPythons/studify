// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/flashcard_model.dart';
import '../../utils/consts/app_colors.dart';
import 'flashcard_controller.dart';

typedef SelectedCallback = int Function(int index);

class ClosedCard extends StatelessWidget {
  const ClosedCard(
    this.index, {
    required this.note,
    required this.onTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);
  final Note note;
  final VoidCallback onTap;
  final RxBool isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    debugPrint(note.toJson().toString());
    return GetBuilder<CardController>(
      init: Get.put<CardController>(CardController()),
      initState: (_) {},
      builder: (_) {
        return GridTile(
          child: Obx(
            () => Material(
              elevation: 4,
              borderOnForeground: isSelected.value,
              borderRadius: BorderRadius.circular(8),
              color: Color(0xff2f2f2f),
              type: MaterialType.card,
              child: InkWell(
                onTap: () => onTap(),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        note.title!,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kAccent,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Text(
                        note.front!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ubuntu(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CardController extends GetxController {}

class ClosedCardController extends GetxController {}
