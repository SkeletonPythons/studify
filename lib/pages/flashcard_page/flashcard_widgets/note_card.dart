import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/flashcard_model.dart';
import '../../../utils/consts/app_colors.dart';
import './closed_card.dart';
import '../note_controller.dart';
import 'open_card.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
    this.controller, {
    required this.note,
    Key? key,
  }) : super(key: key);

  final NotePageController controller;

  final Note note;

  @override
  Widget build(BuildContext context) {
    return (OpenContainer(
      transitionDuration: const Duration(milliseconds: 900),
      closedColor: Colors.transparent,
      openColor: kBackgroundLight,
      transitionType: ContainerTransitionType.fadeThrough,
      closedElevation: 0,
      openElevation: 0,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return ClosedCard(
          note: note,
          onTap: openContainer,
          isSelected: false.obs,
        );
      },
      openBuilder: (BuildContext context, VoidCallback closeContainer) {
        return OpenCard(
          note: note,
          callback: closeContainer,
        );
      },
    ));
  }
}
