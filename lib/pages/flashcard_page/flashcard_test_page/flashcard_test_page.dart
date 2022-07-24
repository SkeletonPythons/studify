// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/timer_widgets/timer_cards.dart';
import '../../../models/flashcard_model.dart';
import '../../../utils/consts/app_colors.dart';
import 'flashcard_test_controller.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TestController controller = Get.put(TestController());

  @override
  void initState() {
    super.initState();
    debugPrint('\nTestPage initState\n');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestController>(
      init: Get.find<TestController>(),
      builder: (_) {
        return SafeArea(
          child: !_.subjectSet.value
              ? CircularProgressIndicator()
              : Container(
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
                            transform: Matrix4.translationValues(0, 0, 0),
                            transformAlignment: Alignment.center,
                            child: Obx(() => Center(
                                  child: _.questionBlock.value,
                                )),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.05),
                        _.answerBlock.value,
                        SizedBox(
                          height: Get.height * 0.1,
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Obx(
                              () => Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 5,
                                  children: _.dots),
                            ),
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

class TP extends GetView<TPC> {
  const TP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Obx(() => Text(
                  '${controller.subject}: ${controller.index.value + 1} of ${controller.answerPool.length}',
                  style: GoogleFonts.ubuntu(color: Colors.white),
                )),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text(
                      'Exit Test?',
                      style: GoogleFonts.ubuntu(),
                    ),
                    content: Text(
                      'Are you sure you want to stop the test?',
                      style: GoogleFonts.ubuntu(),
                    ),
                    actions: [
                      ElevatedButton(
                        child: Text(
                          'Yes',
                          style: GoogleFonts.ubuntu(),
                        ),
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          'No',
                          style: GoogleFonts.ubuntu(),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: !controller.testPrepared.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: Get.height * .25,
                          width: Get.width - 20,
                          decoration: BoxDecoration(
                            color: kBackgroundDark,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kBackground,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () => Text(
                                  controller.currentQ.value,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: Get.height * 0.1,
                                width: Get.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () => controller
                                      .submit(controller.currentA.value),
                                  child: Obx(
                                      () => Text(controller.currentA.value)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: Get.height * 0.1,
                                width: Get.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () => controller
                                      .submit(controller.currentB.value),
                                  child: Obx(
                                      () => Text(controller.currentB.value)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: Get.height * 0.1,
                                width: Get.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () => controller
                                      .submit(controller.currentC.value),
                                  child: Obx(
                                      () => Text(controller.currentC.value)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: Get.height * 0.1,
                                width: Get.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () => controller
                                      .submit(controller.currentD.value),
                                  child: Obx(
                                      () => Text(controller.currentD.value)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.1,
                          child: Obx(
                            () => Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: controller.dots,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
