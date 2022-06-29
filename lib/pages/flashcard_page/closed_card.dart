// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/flashcard_model.dart';
import '../../utils/consts/app_colors.dart';
import 'flashcard_controller.dart';

class ClosedCard extends StatelessWidget {
  const ClosedCard({
    required this.index,
    required this.onTap,
    required this.controller,
    required this.note,
    Key? key,
  }) : super(key: key);
  final int index;
  final Note note;
  final FlashcardController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    debugPrint(controller.notes.toString());
    return GetBuilder<CardController>(
      init: Get.put<CardController>(CardController()),
      initState: (_) {},
      builder: (_) {
        return GridTile(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => onTap(),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      controller.notes[index].title!,
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kAccent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      controller.notes[index].front,
                      textAlign: TextAlign.center,
                    ),
                  ],
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
