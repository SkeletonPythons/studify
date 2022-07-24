import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/pages/OLD/flashcard_controller.dart';

import '../../../models/flashcard_model.dart';
import '../../../services/db.dart';

part 'test_controller.dart';

/// It's a StatefulWidget that has a State that has a Controller that has a Model
/// that has a List of Models.
class Tester extends StatefulWidget {
  Tester({Key? key}) : super(key: key);

  @override
  State<Tester> createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  // ignore: non_constant_identifier_names

  /// Build Method
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: Material(
          child: GetBuilder<TestController>(
            init: Get.put(TestController()),
            initState: (_) {},
            builder: (_) {
              return Column(children: [
                Container(),
                _.screen.value,
                Container(),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class Question extends StatefulWidget {
  const Question({required this.questions, Key? key}) : super(key: key);

  final Map<String, dynamic> questions;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  void initState() {
    super.initState();
    debugPrint('Question/initState fired');
  }

  @override
  Widget build(BuildContext context) {
    /// It's returning a Container.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GetBuilder<TestController>(
            init: Get.find<TestController>(),
            initState: (_) {},
            builder: (_) {
              return AnimatedContainer(
                height: Get.height * 0.3,
                width: Get.width * 0.8,
                duration: const Duration(milliseconds: 600),
                transform: _.questionMatrix.value,
                child: Text(
                  widget.questions['question'],
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
        Row(
          children: [
            GetBuilder<TestController>(
              init: Get.find<TestController>(),
              initState: (_) {},
              builder: (_) {
                return AnimatedContainer(
                  height: Get.height * 0.1,
                  width: Get.width * 0.4,
                  duration: const Duration(milliseconds: 300),
                  transform: _.aMatrix.value,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      widget.questions['answers'][0],
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
            GetBuilder<TestController>(
              init: Get.find<TestController>(),
              initState: (_) {},
              builder: (_) {
                return AnimatedContainer(
                  height: Get.height * 0.1,
                  width: Get.width * 0.4,
                  duration: const Duration(milliseconds: 400),
                  transform: _.bMatrix.value,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      widget.questions['answers'][1],
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            GetBuilder<TestController>(
              init: Get.find<TestController>(),
              initState: (_) {},
              builder: (_) {
                return AnimatedContainer(
                  height: Get.height * 0.1,
                  width: Get.width * 0.4,
                  duration: const Duration(milliseconds: 700),
                  transform: _.cMatrix.value,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      widget.questions['answers'][2],
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
            GetBuilder<TestController>(
              init: Get.find<TestController>(),
              initState: (_) {},
              builder: (_) {
                return AnimatedContainer(
                  height: Get.height * 0.1,
                  width: Get.width * 0.4,
                  duration: const Duration(milliseconds: 800),
                  transform: _.dMatrix.value,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      widget.questions['answers'][3],
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

enum CircleState {
  correct,
  wrong,
  normal,
}

class AnswerCircle extends StatelessWidget {
  const AnswerCircle({required this.state, Key? key}) : super(key: key);
  final CircleState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: state == CircleState.correct
            ? Colors.green
            : state == CircleState.wrong
                ? Colors.red
                : Colors.grey,
        borderRadius: BorderRadius.circular(21),
      ),
    );
  }
}
