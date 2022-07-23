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
  /// The Chosen Subject.
  RxString subject = ''.obs;

  /// The list of questions and answers to be displayed.
  RxMap<String, String> questions = <String, String>{}.obs;

  /// The state of the test.
  Rx<TestState> state = TestState.init.obs;

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
  GetStream<TestState> stateMachine = GetStream();

  /// onInit()
  @override
  void onInit() {
    super.onInit();
    debugPrint('TestController/init');
    stateMachine.listen(
      (st) {
        switch (st) {
          case TestState.init:
            debugPrint('TestController/init');
            state.value = TestState.prepped;
            break;
          case TestState.prepped:
            debugPrint('TestController/prepped');
            state.value = TestState.question;
            break;
          case TestState.question:
            debugPrint('TestController/question');
            state.value = TestState.answer;
            break;
          case TestState.answer:
            debugPrint('TestController/answer');
            state.value = TestState.question;
            break;
          case TestState.paused:
            debugPrint('TestController/paused');
            state.value = TestState.paused;
            break;
          case TestState.end:
            debugPrint('TestController/end');
            state.value = TestState.end;
            break;
        }
      },
    );
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
    state.value = TestState.init;
  }

  /// Method that controls the test flow.
  void loop() {
    switch (state.value) {
      case TestState.init:
        reset();
        break;
      case TestState.question:
        break;
      case TestState.answer:
        break;
      case TestState.paused:
        break;
      case TestState.end:
        break;
      case TestState.prepped:
        break;
      default:
        break;
    }
  }
}
