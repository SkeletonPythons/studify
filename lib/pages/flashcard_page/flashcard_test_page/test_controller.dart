// ignore_for_file: no_leading_underscores_for_local_identifiers

part of './tester.dart';

enum TestState {
  /// The test is ready to begin.
  prepped,

  /// Question is displayed
  question,

  /// Answer is displayed
  answer,

  /// Test is paused.
  paused,

  /// Initialize test
  init,

  /// Test is finished.
  end
}

class TestController extends GetxController {
  /// Random number generator
  final Random rng = Random(DateTime.now().millisecondsSinceEpoch);

  /// The Chosen Subject.
  RxString subject = ''.obs;

  /// The list of questions and answers to be displayed.
  RxMap<String, String> questions = <String, String>{}.obs;

  /// List of answers of questions that have been answered for use as wrong answers.
  List<String> answeredAlready = <String>[];

  /// Number of questions in the test.
  RxInt numQuestions = 0.obs;

  /// Number of questions answered correctly.
  RxInt numCorrect = 0.obs;

  /// Current question number.
  RxInt currentIndex = 0.obs;

  /// Time remaining for the current question.
  RxDouble timeRemaining = RxDouble(0);

  /// Time remaining for the entire test if set by the user.
  RxDouble timeLimit = RxDouble(-1);

  /// StreamSubscription that listens for when the state changes.
  GetStream<TestState> stateMachine = GetStream<TestState>();

  /// The current [Widget] to be displayed.
  Rx<Widget> screen = Container().obs;

  /// Matrix4 for the question.
  Rx<Matrix4> questionMatrix = Matrix4.identity().obs;

  /// Matrix4 for A.
  Rx<Matrix4> aMatrix = Matrix4.identity().obs;

  /// Matrix4 for  B.
  Rx<Matrix4> bMatrix = Matrix4.identity().obs;

  /// Matrix4 for  C.
  Rx<Matrix4> cMatrix = Matrix4.identity().obs;

  /// Matrix4 for  D.
  Rx<Matrix4> dMatrix = Matrix4.identity().obs;

  /// Shortcut for Identity Matrix.
  Matrix4 get idMatrix => Matrix4.identity();

  /// Shortcut for 0x scale Matrix.
  Matrix4 get scale0x => Matrix4.diagonal3Values(0, 0, 0);

  /// Shortcut for 1.5x scale Matrix.
  Matrix4 get scale1p5x => Matrix4.diagonal3Values(1.5, 1.5, 1);

  /// Shortcut for 2x scale Matrix.
  Matrix4 get scale2x => Matrix4.diagonal3Values(2, 2, 1);

  /// Fade Transition Widget A.
  Rx<Widget> a = Container().obs;

  /// Fade Transition Widget B.
  Rx<Widget> b = Container().obs;

  /// Method to change the [state] of the test.
  void stateChange(TestState to) {
    stateMachine.add(to);
    update();
  }

  /// Method to generate the questions and answers.
  Map<String, dynamic> generateQuestions(String currentQuestion) {
    Map<String, dynamic> results = <String, dynamic>{};
    results['question'] = currentQuestion;
    results['correctAnswer'] = questions['currentQuestion'];
    results['answers'] = <String>[questions['currentQuestion']!];
    while (results['answers'].length < 4) {
      List<String> pool = <String>[...answeredAlready, ...questions.values];

      int randomNumber = rng.nextInt(pool.length);

      String randomAnswer = pool[randomNumber];
      if (results['answers'].contains(randomAnswer)) {
        continue;
      }
      results['answers'].add(randomAnswer);
    }
    results['answers'].shuffle();
    answeredAlready.add(results['correctAnswer']);
    questions.remove(currentQuestion);
    return results;
  }

  /// onInit()
  @override
  void onInit() {
    super.onInit();

    debugPrint('TestController/init');
    stateMachine.listen(
      (st) async {
        switch (st) {
          case TestState.init:
            debugPrint('TestController/init');
            screen.value = Container(child: CircularProgressIndicator());
            while (true) {
              subjectPicker();
              if (subject.value != '') {
                break;
              }
            }
            populateQuestions();
            stateChange(TestState.prepped);
            update();
            break;
          case TestState.prepped:
            debugPrint('TestController/prepped');
            if (isPrepped) {
              stateChange(TestState.question);
            } else {
              stateChange(TestState.init);
            }
            break;
          case TestState.question:
            debugPrint('TestController/question');
            int _rng = rng.nextInt(questions.length);
            screen.value = Question(
                questions: generateQuestions(questions.keys.toList()[_rng]));
            update();
            break;
          case TestState.answer:
            debugPrint('TestController/answer');
            if (questions.isNotEmpty) {
              stateChange(TestState.question);
            } else {
              stateChange(TestState.end);
            }
            update();
            break;
          case TestState.paused:
            debugPrint('TestController/paused');
            update();
            break;
          case TestState.end:
            debugPrint('TestController/end');
            double _score = (numCorrect.value / numQuestions.value) * 100;
            Get.defaultDialog(
              title: 'Test Complete',
              content: Text('You scored $_score%'),
              actions: [
                OutlinedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Get.back();
                    reset();
                  },
                ),
              ],
            );
            update();
            break;
        }
      },
      onError: (e) {
        debugPrint('TestController/error');
        debugPrint(e.toString());
      },
    );
    stateMachine.add(TestState.init);
  }

  /// onReady()
  @override
  void onReady() {
    super.onReady();
    debugPrint('TestController/ready');
  }

  /// onClose()
  @override
  void onClose() {
    super.onClose();
    debugPrint('TestController/dispose');
  }

  /// Checker for prepped state.
  bool get isPrepped {
    if (subject.value == '') {
      return false;
    } else if (questions.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  /// Gettter for the list of [Notes].
  Future<List<Note>> get getNotes async {
    List<Note> notes = [];
    await DB.instance.notes.get().then((QuerySnapshot<Note> snapshot) async {
      List<QueryDocumentSnapshot<Note>> docs = snapshot.docs;

      for (QueryDocumentSnapshot<Note> doc in docs) {
        notes.add(doc.data());
      }
      return notes;
    }).catchError((e) {
      debugPrint('error getting data: $e');
    });
    notes.shuffle();
    return notes;
  }

  /// Gettter for the list of [Note]s that have the same [subject].
  Future<List<String>> get subjects async {
    List<String> subjects = [];
    for (Note note in await getNotes) {
      if (!subjects.contains(note.subject) && note.subject != '') {
        subjects.add(note.subject!);
      }
    }
    return subjects;
  }

  /// Method that populates the [questions] list with the questions and answers.
  void populateQuestions() async {
    for (Note note in await getNotes) {
      if (note.subject == subject.value) {
        if (note.front != '' &&
            note.back != '' &&
            note.front != null &&
            note.back != null) {
          questions[note.front!] = note.back!;
        }
      }
    }
  }

  /// Method at the beginning of the test flow.
  /// Selects the subject and populates the [questions] list.
  void subjectPicker() async {
    List<Widget> subjectButtons = <Widget>[];

    for (String sub in await subjects) {
      subjectButtons.add(
        SimpleDialogOption(
          child: Text(
            sub,
            style: GoogleFonts.ubuntu(fontSize: 16),
          ),
          onPressed: () {
            subject.value = sub;
            Get.back();
          },
        ),
      );
      Get.dialog(
        SimpleDialog(
          title: Text(
            'Choose a subject!',
            style: GoogleFonts.ubuntu(fontSize: 16),
          ),
          children: subjectButtons,
        ),
      );
    }
  }

  /// Method that resets all the variables to their initial values
  /// and begins the test flow again.
  void reset() {
    questions.clear();
    currentIndex.value = 0;
    numCorrect.value = 0;
    numQuestions.value = 0;
    timeRemaining.value = 0;
    timeLimit.value = -1;
    subject.value = '';
    stateMachine.add(TestState.end);
  }
}
