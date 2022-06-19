import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import './open_card.dart';
import '../../../utils/sample_cards.dart';

class ClosedFC extends StatelessWidget {
  const ClosedFC(
    this.index, {
    Key? key,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: InkWell(
        onTap: () {
          OpenFC(index);
        },
        child: Center(
          child: Text(
            statesAndCapital['$index']['q'],
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
