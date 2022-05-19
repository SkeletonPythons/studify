//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
// App: Studify
// Team: Skeleton Pythons
// Author: Justin.Morton
// Date Created: 05/15/2022
// Last Modified By: Justin.Morton
// Last Modified Date: 05/15/2022
//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

// This alias is used to handle the login
// and registration of the user with email and pass.
// Used for readability..
typedef LoginOrRegisterFunction = Future<UserCredential> Function({
  required String email,
  required String password,
});

class Auth {
  /// This class is the entry point for the authentication with
  /// the Firebase Authentication SDK.

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static AppUser? _user;

  // ignore: non_constant_identifier_names
  static Future<AppUser?> get User async {
    return _user;
  }

  /// Preps the user for the login or registration process
  /// cleans the errors and and handles the user credentials.
  static Future<bool> _authHelper({
    required LoginOrRegisterFunction fn,
    required String email,
    required String password,
  }) async {
    try {
      await fn(email: email, password: password);
      // TODO: Handle user credentials.

      return true;
    } catch (e) {
      // TODO: Handle errors.
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> register({
    required String email,
    required String password,
  }) async {
    return await _authHelper(
      fn: _auth.createUserWithEmailAndPassword,
      email: email,
      password: password,
    );
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    return await _authHelper(
      fn: _auth.signInWithEmailAndPassword,
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  // TODO: Create a USER from model and get the users database.
}
