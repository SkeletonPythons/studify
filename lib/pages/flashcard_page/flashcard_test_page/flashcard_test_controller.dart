// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/consts/app_colors.dart';
import '../../../models/flashcard_model.dart';
import '../../../services/db.dart';

class TestController extends GetxController with GetTickerProviderStateMixin {
  List<Note> notes = <Note>[];
  List<String?> questions = [];
  List<String?> answers = [];
  String subj = '';
  int timer = 10;
  RxBool subjectSet = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('TestController/init');
    populateNotes();
  }

  List<String?> get populateQuestions {
    List<String?> questions = [];
    for (Note note in notes) {
      if (note.front != null) {
        questions.add(note.front);
      }
    }
    return questions;
  }

  List<String?> get populateAnswers {
    List<String?> answers = [];
    for (Note note in notes) {
      if (note.back != null) {
        answers.add(note.back);
      }
    }
    return answers;
  }

  void populateNotes() async {
    subj = Get.arguments ?? 'all';
    await DB.instance.notes.get().then((value) {
      for (var val in value.docs) {
        notes.addIf(
            () => val.data().subject == subj || subj == 'all', val.data());
      }
    });
    questions = populateQuestions;
    answers = populateAnswers;
    update();
  }
}

class Question extends StatefulWidget {
  const Question(this.question, this.answer,
      {required this.allAnswers, Key? key})
      : super(key: key);
  final String question;
  final String answer;
  final List<String> allAnswers;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  bool _isCorrect = false;
  bool _isAnswered = false;

  List<String> get wrongAnswers {
    List<String> wrongAnswers = [];
    while (wrongAnswers.length < 3) {
      int ind = Random().nextInt(widget.allAnswers.length);
      String potential = widget.allAnswers[ind];
      if (potential != widget.answer && !wrongAnswers.contains(potential)) {
        wrongAnswers.add(potential);
      }
    }
    return wrongAnswers;
  }

  List<String> get questionAnswers {
    List<String> questionAnswers = [];
    questionAnswers.add(widget.answer);
    questionAnswers.addAll(wrongAnswers);
    return questionAnswers
      ..shuffle()
      ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .6,
      width: Get.width * .9,
      decoration: BoxDecoration(
        color: kBackgroundLight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.question,
            style: TextStyle(fontSize: Get.height * .05),
          ),
          SizedBox(height: Get.height * .02),
          Expanded(
            child: ListView.builder(
              itemCount: questionAnswers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questionAnswers[index]),
                  onTap: () {
                    if (!_isAnswered) {
                      _isAnswered = true;
                      if (questionAnswers[index] == widget.answer) {
                        _isCorrect = true;
                      } else {
                        _isCorrect = false;
                      }
                      _controller.forward();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
