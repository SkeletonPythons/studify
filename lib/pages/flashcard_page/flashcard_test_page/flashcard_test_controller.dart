// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/mybusinessqanda/v1.dart';

import '../../../utils/consts/app_colors.dart';
import '../../../models/flashcard_model.dart';
import '../../../services/db.dart';

class TestController extends GetxController with GetTickerProviderStateMixin {
  /// The list of questions to be displayed.
  List<String?> questions = [];

  /// The list of answers to be displayed.
  List<String?> answers = [];

  /// The list of flashcards to be displayed.
  List<Note> listOfNotes = [];

  /// The chosen subject.
  String subj = '';

  /// Value of the timer indicator.
  RxDouble timer = 0.0.obs;

  /// Value of the timer.
  RxInt timerToo = 20.obs;

  /// The current question index.
  RxInt currentIndex = 0.obs;

  /// The number of questions answered correctly.
  RxInt numCorrect = 0.obs;

  // RxList<bool> answersList = <bool>[].obs;

  /// Determines if the subject has been set.
  RxBool subjectSet = false.obs;

  /// Determines if the timer has started.
  RxBool pauseTimer = true.obs;

  /// Map of all notes used to set questions and answers.
  Map<String, List<Note>> notes = {};

  /// Controls the value of the timer indicator.
  void tick() async {
    if (pauseTimer.value) {
      return;
    }
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        timerToo.value -= 1;
        timer.value += 0.05;
        debugPrint(timer.value.toString());
        if (timer.value < 1.0) {
          return tick();
        }
      },
    );
    if (timer.value >= 1) {
      pauseTimer.value = true;
      timer.value = 0.0;
      timerToo.value = 20;
      return;
    }
  }

  /// Resets the timer.
  void resetTimers() {
    timer.value = 0.0;
    timerToo.value = 20;
    pauseTimer.value = true;
  }

  /// Called when the user clicks an answer.
  void submitAnswer(String answer) {
    if (listOfNotes[currentIndex.value].back == answer) {
      numCorrect.value += 1;
      addDot(true);
    } else {
      addDot(false);
    }
    currentIndex.value += 1;
    if (currentIndex.value == listOfNotes.length) {
      int avg = ((numCorrect.value / listOfNotes.length) * 100).round();
      resetTimers();
      currentIndex.value = 0;
      numCorrect.value = 0;
      Get.back();
      Get.dialog(AlertDialog(
        title: Text('Test Complete'),
        content: Text('You got a score of $avg%! '),
        actions: [
          OutlinedButton(
            child: Text('OK'),
            onPressed: () {
              Get.back();
              Get.back();
              return;
            },
          ),
        ],
      ));
    }
    answerBlock.value = setAnswers();
    update();
  }

  Color correctColor = Colors.greenAccent[700]!;
  Color incorrectColor = Colors.redAccent[400]!;
  Color neutralColor = Colors.grey[700]!;

  bool isCorrect(String question, String answer) {
    return question == answer;
  }

  Rx<Widget> answerBlock = Rx<Widget>(
    Container(),
  );

  Widget setAnswers() {
    List<String> answers = [];
    answers.add(listOfNotes[currentIndex.value].back!);
    while (answers.length < 4) {
      int randomIndex = Random().nextInt(listOfNotes.length);
      if (answers.contains(listOfNotes[randomIndex].back!)) {
        continue;
      }
      answers.add(listOfNotes[randomIndex].back!);
    }
    answers.shuffle();
    return Container(
        height: Get.height * .25,
        width: Get.width,
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Question(
                  answer: answers[0],
                  color: neutralColor,
                  onPressed: () => submitAnswer(answers[0]),
                ),
                SizedBox(width: Get.width * .2),
                Question(
                  answer: answers[1],
                  color: neutralColor,
                  onPressed: () => submitAnswer(answers[1]),
                ),
              ],
            ),
            SizedBox(height: Get.height * .05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Question(
                  answer: answers[2],
                  color: neutralColor,
                  onPressed: () => submitAnswer(answers[2]),
                ),
                SizedBox(width: Get.width * .2),
                Question(
                  answer: answers[3],
                  color: neutralColor,
                  onPressed: () => submitAnswer(answers[3]),
                ),
              ],
            ),
          ],
        ));
  }

  void setNotes(
    Map<String, List<Note>> notes,
  ) {
    this.notes = notes;
  }

  void setSubject(String subject) {
    subj = subject;
    subjectSet.value = true;
    questions = notes[subject]?.map((note) => note.front).toList() ?? []
      ..shuffle();
    answers = notes[subject]?.map((note) => note.back).toList() ?? [];
  }

  void intro() {
    List<Widget> childs = [];
    for (String key in notes.keys) {
      childs.add(
        SimpleDialogOption(
          padding: const EdgeInsets.all(8),
          child: Text(key, style: GoogleFonts.roboto()),
          onPressed: () {
            setSubject(key);
            listOfNotes = notes[key]!;
            answerBlock.value = setAnswers();
            update();
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

  void startTest() {
    numCorrect.value = 0;
    for (Note note in notes[subj]!) {
      questions.add(note.front);
    }
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('TestController/init');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('TestController/ready');
    intro();
  }

  RxList<Widget> dots = <Widget>[].obs;

  void addDot(bool isCorrect) {
    dots.add(
      Container(
        height: Get.height * .03,
        width: Get.width * .03,
        decoration: BoxDecoration(
          color: isCorrect ? correctColor : incorrectColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Question extends StatelessWidget {
  const Question(
      {required this.color,
      required this.answer,
      required this.onPressed,
      Key? key})
      : super(key: key);

  final String answer;
  final void Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: Get.height * 0.1,
      width: Get.width * 0.35,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          answer,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
