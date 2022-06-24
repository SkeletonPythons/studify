import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/controllers/flashcard_controller.dart';

import '../../../utils/sample_cards.dart';

class ClosedFC extends StatelessWidget {
  const ClosedFC({
    required this.index,
    required this.onTap,
    required this.controller,
    Key? key,
  }) : super(key: key);
  final int index;
  final FlashcardController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    debugPrint(controller.notes.toString());
    return GridTile(
      child: InkWell(
        onTap: () => onTap(),
        child: Center(
          child: Text(
            controller.notes[index].front,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ClosedCardController extends GetxController {}
