import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthProvider extends ChangeNotifier {

  static User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> authMethod(String email, String password, bool isLogIn) async {
    if (isLogIn) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          throw 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          throw 'Wrong password provided for that user.';
        }
      }
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          throw 'The account already exists for that email.';
        }
      } catch (e) {
        print(e);
        throw e;
      }
    }
  }

  logout() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
