import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/flashcard_model.dart';
import '../../../services/db.dart';

part 'test_controller.dart';

class Tester extends StatefulWidget {
  Tester({Key? key}) : super(key: key);

  @override
  State<Tester> createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  // ignore: non_constant_identifier_names
  TestController TC = Get.put(TestController());

  /// Build Method
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(),
      ),
    );
  }
}
