import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studify/models/user_model.dart';
import 'package:studify/services/auth.dart';

class DB {
  static FirebaseFirestore store = FirebaseFirestore.instance;

  static Future<AppUser?>? getUser(String uid) {
    try {
      return store.collection('users').doc(uid).get().then((value) {
        if (value.exists) {
          return AppUser.fromJson(value.data()!);
        } else {
          return null;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> updateUser(AppUser user) {
    return store.collection('users').doc(user.uid).update(user.toJson());
  }

  static Future<void> updateUserData(String uid, Map<String, dynamic> data) {
    return store.collection('users').doc(uid).update(data);
  }
}
