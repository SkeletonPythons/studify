// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/flashcard_model.dart';
import '../../utils/consts/app_colors.dart';
import 'flashcard_controller.dart';

class ClosedCard extends StatelessWidget {
  const ClosedCard({
    required this.note,
    required this.onTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);
  final Note note;
  final VoidCallback onTap;
  final RxBool isSelected;

  @override
  Widget build(BuildContext context) {
    return Obx(
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
                  note.subject!,
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
                  overflow: TextOverflow.fade,
                  softWrap: true,
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
    );
  }
}
