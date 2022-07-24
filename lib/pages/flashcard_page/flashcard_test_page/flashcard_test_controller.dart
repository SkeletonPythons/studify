// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors, non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/mybusinessqanda/v1.dart';

import '../../../utils/consts/app_colors.dart';
import '../../../models/flashcard_model.dart';
import '../../../services/db.dart';

class TestController extends GetxController with GetTickerProviderStateMixin {
  /// Random number generator
  final Random rng = Random(DateTime.now().millisecondsSinceEpoch);

  /// The list of questions to be displayed.
  RxList<String?> questions = <String>[].obs;

  /// The list of answers to be displayed.
  RxList<String?> answers = <String>[].obs;

  /// The List of all notes.
  RxList<Note> allNotes = <Note>[].obs;

  /// List of subjects
  List<String> subjects = [];

  /// Map of questions and answers.
  Map<String, String> QA = {};

  void setQA(String subject) async {
    for (Note note in allNotes) {
      if (note.subject == subject && note.front != '' && note.back != '') {
        QA[note.front!] = note.back!;
      }
    }
    questions = QA.keys.toList().obs;
    answers = QA.values.toList().obs;
  }

  /// The current question and its answer.
  Map<String, String> currentQA = {};

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

  /// Determines if the subject has been set.
  RxBool subjectSet = false.obs;

  /// Determines if the timer has started.
  RxBool pauseTimer = true.obs;

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
  void submitAnswer({required String question, required String answer}) {
    if (currentQA.containsValue(answer)) {
      numCorrect.value += 1;
      addDot(true);
    } else {
      addDot(false);
    }
    currentIndex.value += 1;
    if (QA.isEmpty) {
      int avg = ((numCorrect.value / answers.length) * 100).round();
      resetTimers();
      currentIndex.value = 0;
      numCorrect.value = 0;
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
    answerBlock.value = setAnswers;

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
  Rx<Widget> questionBlock = Rx<Widget>(
    Container(),
  );

  Widget get setAnswers {
    String nextQuestion = QA.keys.toList()[rng.nextInt(QA.length)];
    currentQA = {nextQuestion: QA[nextQuestion]!};
    questionBlock.value = Text(
      nextQuestion,
      style: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
    QA.remove(nextQuestion);
    List<String> answers = [currentQA[nextQuestion]!];
    while (answers.length < 4) {
      String potential = answers[rng.nextInt(answers.length)];
      if (answers.contains(potential)) {
        continue;
      }
      answers.add(potential);
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
                onPressed: () =>
                    submitAnswer(question: nextQuestion, answer: answers[0]),
              ),
              SizedBox(width: Get.width * .2),
              Question(
                answer: answers[1],
                color: neutralColor,
                onPressed: () =>
                    submitAnswer(question: nextQuestion, answer: answers[1]),
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
                onPressed: () =>
                    submitAnswer(question: nextQuestion, answer: answers[2]),
              ),
              SizedBox(width: Get.width * .2),
              Question(
                answer: answers[3],
                color: neutralColor,
                onPressed: () =>
                    submitAnswer(question: nextQuestion, answer: answers[3]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setSubject(String subject) {
    subj = subject;
    setQA(subject);
    answerBlock.value = setAnswers;

    subjectSet.value = true;
    update();
  }

  Future<void> setNotes() async {
    await DB.instance.notes.get().then((s) {
      for (var note in s.docs.toList()) {
        allNotes.add(note.data());
      }
    });
    for (String subject in allNotes.map((note) => note.subject!).toList()) {
      if (!subjects.contains(subject)) {
        subjects.add(subject);
      }
    }
    debugPrint(allNotes.length.toString());
    debugPrint(subjects.length.toString());
  }

  @override
  void onInit() async {
    debugPrint('TestController/init');
    await setNotes();

    super.onInit();
  }

  @override
  void onReady() {
    debugPrint('TestController/ready');
    List<Widget> subjectButtons = [];
    for (String subject in subjects) {
      subjectButtons.add(
        SimpleDialogOption(
          child: Text(subject),
          onPressed: () {
            setSubject(subject);
            Get.back();
          },
        ),
      );
    }
    Get.dialog(
      SimpleDialog(
        title: Text('Select a subject'),
        children: subjectButtons,
      ),
    );
    super.onReady();
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

class TPC extends GetxController {
  Random rng = Random(DateTime.now().millisecondsSinceEpoch);

  String title = 'Test';

  RxString subject = ''.obs;

  RxList<String> answerPool = <String>[].obs;

  RxList<Map<String, String>> questions = <RxMap<String, String>>[].obs;

  RxInt index = (-1).obs;
  RxInt numCorrect = 0.obs;
  RxBool firstQuestion = true.obs;

  List<Note> notes = [];

  RxBool testPrepared = false.obs;

  RxMap<String, String> currentQA = <String, String>{}.obs;

  RxString currentQ = ''.obs;
  RxString currentA = ''.obs;
  RxString currentB = ''.obs;
  RxString currentC = ''.obs;
  RxString currentD = ''.obs;

  void next() {
    index.value++;
    if (index.value == questions.length - 1) {
      testComplete();
      return;
    }

    currentQA.value = questions[index.value];
    currentQ.value = currentQA['question']!;
    List<String> tempA = [currentQA['answer']!];
    while (tempA.length < 4) {
      String potential = answerPool[rng.nextInt(answerPool.length)];
      if (tempA.contains(potential)) {
        continue;
      }
      tempA.add(potential);
      tempA.shuffle();
    }
    currentA.value = tempA[0];
    currentB.value = tempA[1];
    currentC.value = tempA[2];
    currentD.value = tempA[3];
    update();
  }

  void first() {
    firstQuestion.value = false;
    currentQA.value = questions[0];
    List<String> tempA = [currentQA['answer']!];
    while (tempA.length < 4) {
      String potential = answerPool[rng.nextInt(answerPool.length)];
      if (tempA.contains(potential)) {
        continue;
      }
      tempA.add(potential);
      tempA.shuffle();
    }
    currentQ.value = currentQA['question']!;
    currentA.value = tempA[0];
    currentB.value = tempA[1];
    currentC.value = tempA[2];
    currentD.value = tempA[3];
  }

  void testComplete() {
    double score = ((numCorrect.value / questions.length.toDouble()) * 100)
        .roundToDouble();
    Get.dialog(
      AlertDialog(
        title: Text('Test Complete'),
        content: Text('You scored $score%'),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Get.back();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void submit(String answer) {
    if (answer == currentQA['answer']) {
      addDot(true);
      numCorrect.value++;
    } else {
      addDot(false);
    }
    next();
  }

  RxList<Widget> dots = <Widget>[].obs;

  void addDot(bool isCorrect) {
    dots.add(
      Container(
        height: Get.height * .03,
        width: Get.width * .03,
        decoration: BoxDecoration(
          color: isCorrect ? Colors.greenAccent : Colors.redAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Future<void> prepareTest() async {
    debugPrint('preparing test 1');
    index.value = 0;
    numCorrect.value = 0;
    List<String> subjects = [];
    await DB.instance.notes.get().then((s) {
      for (var note in s.docs.toList()) {
        notes.add(note.data());
      }
    });
    for (Note note in notes) {
      if (note.subject == '') {
        continue;
      }

      if (!subjects.contains(note.subject)) {
        subjects.add(note.subject!);
      }
    }
    Get.dialog(SimpleDialog(
      title: Text('Select a subject', style: GoogleFonts.roboto(fontSize: 20)),
      children: subjects
          .map((subject) => SimpleDialogOption(
                child: Text(
                  subject,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (setSubjectAndQuestions(subject)) {
                    Get.back();

                    testPrepared.value = true;
                    next();
                  }
                },
              ))
          .toList(),
    ));
    debugPrint('preparing test 2');
  }

  bool setSubjectAndQuestions(String subject) {
    this.subject.value = subject;
    questions.clear();
    answerPool.value = [];
    for (Note note in notes) {
      if (note.subject == subject) {
        questions.add({'question': note.front!, 'answer': note.back!}.obs);
        answerPool.add(note.back!);
      }
      questions.shuffle();
    }
    return questions.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    prepareTest();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('ready');
  }
}
