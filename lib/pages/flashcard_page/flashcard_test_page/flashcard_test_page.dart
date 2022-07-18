// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/widgets/timer_widgets/timer_cards.dart';

import '../../../models/flashcard_model.dart';
import '../../../utils/consts/app_colors.dart';
import 'flashcard_test_controller.dart';

class TestPage extends StatefulWidget {
  const TestPage({required this.notes, Key? key}) : super(key: key);

  final Map<String, List<Note>> notes;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TestController controller = Get.put(TestController());

  @override
  void initState() {
    super.initState();
    controller.setNotes(widget.notes);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestController>(
      init: Get.find<TestController>(),
      builder: (_) {
        return !_.subjectSet.value
            ? const Material(
                child: Center(
                  child: Text('Loading...'),
                ),
              )
            : SafeArea(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: kBackground,
                  ),
                  child: GetBuilder<TestController>(
                    init: Get.find<TestController>(),
                    builder: (_) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: Get.width * 0.9,
                              height: Get.height * 0.1,
                              color: kBackground,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(),
                                      clipBehavior: Clip.hardEdge,
                                      width: Get.width * 0.3,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: _.subj),
                                            TextSpan(
                                              text:
                                                  '\n${_.currentIndex.value + 1} of ${_.questions.length}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                          style: GoogleFonts.roboto(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Material(
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Obx(
                                                  () =>
                                                      CircularProgressIndicator(
                                                    value: _.timer.value,
                                                    backgroundColor: kAccent,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      kBackground,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                  child: Obx(() => Text(_
                                                      .timerToo.value
                                                      .toString())))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Material(
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: kBackgroundDark,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kBackgroundDark,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            height: Get.height * 0.25,
                            width: Get.width * 0.9,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Center(
                              child: Obx(
                                () => Text(
                                  _.questions[_.currentIndex.value]!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.05),
                        _.answerBlock.value,
                        SizedBox(
                          height: Get.height * 0.1,
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Obx(() => Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: _.dots)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
