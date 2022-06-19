import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/sample_cards.dart';

class OpenFC extends StatelessWidget {
  const OpenFC(
    this.index, {
    Key? key,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: Get.height * .5,
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Front of Card:',
            style: GoogleFonts.neucha(
              fontSize: 20,
              color: const Color.fromARGB(255, 100, 100, 100),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            statesAndCapital['$index']['q'],
            style: GoogleFonts.ubuntuMono(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          Text('Back of Card:',
              style: GoogleFonts.neucha(
                fontSize: 20,
                color: const Color.fromARGB(255, 100, 100, 100),
              )),
          Text(
            statesAndCapital['$index']['a'],
            style: GoogleFonts.ubuntuMono(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    ));
  }
}
