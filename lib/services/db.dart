import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class DB extends GetxController {
  static final DB instance = Get.find();
  FirebaseDatabase db = FirebaseDatabase.instance;
  RxBool isInit = false.obs;

  late DatabaseReference? userRef;
  late DatabaseReference? notesRef;
  late DatabaseReference? tasksRef;
  late DatabaseReference? eventsRef;

  void init(AppUser user) {
    if (user.uid.isEmpty) return;
    if (isInit.value) return;
    userRef = db.ref(user.db);
    notesRef = db.ref(user.db).child('notes');
    tasksRef = db.ref(user.db).child('tasks');
    eventsRef = db.ref(user.db).child('events');
    isInit.value = true;
  }
}
