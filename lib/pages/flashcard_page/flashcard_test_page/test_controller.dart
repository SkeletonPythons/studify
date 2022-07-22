part of './tester.dart';

enum TestState {
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

  RxInt numQuestions = 0.obs;

  RxInt numCorrect = 0.obs;

  RxInt currentIndex = 0.obs;

  RxBool pauseTimer = true.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('TestController/init');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('TestController/ready');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('TestController/dispose');
  }

  RxDouble timeRemaining = RxDouble(0);

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

  Future<List<String>> get subjects async {
    List<String> subjects = [];
    for (Note note in await getNotes) {
      if (!subjects.contains(note.subject) && note.subject != '') {
        subjects.add(note.subject!);
      }
    }
    return subjects;
  }

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

  void subjectPicker() {
    Get.dialog(SimpleDialog());
  }

  void reset() {
    questions.clear();
    subject.value = '';
  }

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
    }
  }
}
