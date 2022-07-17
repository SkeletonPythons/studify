import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void intro() {
    List<Widget> childs = [];
    for (String key in widget.notes.keys) {
      childs.add(
        SimpleDialogOption(
          child: Text(key),
          onPressed: () {
            controller.subj = key;
            controller.subjectSet.value = true;
            Get.back();
          },
        ),
      );
    }
    Get.dialog(
      SimpleDialog(
        title: Text('Select a topic', style: GoogleFonts.roboto()),
        children: childs,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    intro();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestController>(
      init: Get.find<TestController>(),
      builder: (_) {
        return _.subjectSet.value
            ? const Center(
                child: Text('Loading...'),
              )
            : Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: kBackground,
                ),
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _.subj,
                          style: GoogleFonts.roboto(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 6,
          child: Text('test question'),
        ),
        SizedBox(
          height: Get.height * .02,
        ),
        Row(
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Text(''),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
