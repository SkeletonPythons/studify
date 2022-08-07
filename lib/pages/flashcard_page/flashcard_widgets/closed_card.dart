// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/note_model.dart';
import '../../../utils/consts/app_colors.dart';

class ClosedCard extends StatelessWidget {
  const ClosedCard({
    required this.note,
    required this.onTap,
    required this.isSelected,
    required this.selectionEnabled,
    Key? key,
  }) : super(key: key);
  final Note note;
  final VoidCallback onTap;
  final RxBool isSelected;
  final RxBool selectionEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Material(
          elevation: 4,
          borderOnForeground: isSelected.value,
          borderRadius: BorderRadius.circular(8),
          color: Color(0xff2f2f2f),
          type: MaterialType.card,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                child: Text(
                  note.front!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: GoogleFonts.mPlus1Code(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
