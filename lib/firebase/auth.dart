// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:iftar/firebase/user.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //get user's id
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Function to map Firebase User to custom user class
  use? _userFromFirebaseUser(User? user) {
    return user != null && user.emailVerified ? use(uid: user.uid) : null;
  }

  // Stream to listen to auth state changes and map to custom user class
  Stream<use?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<void> sendEmailVerificationLink() async {
    User? user = _firebaseAuth.currentUser;

    // Check if the user is logged in
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print("Verification email sent to ${user.email}");
      } catch (e) {
        print("Error sending verification email: $e");
      }
    } else {
      print("No user is logged in or user is already verified.");
    }
  }

  Future<use?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await sendEmailVerificationLink();
      return use(uid: user!.uid);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        var methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        print('Sign in methods for this email: $methods');
      }
      print("Detailed error: $e");
      return null;
    }
  }

  Future<use?> logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null && user.emailVerified) {
        return _userFromFirebaseUser(user);
      } else {
        print("Email not verified. Please verify your email.");
        await signOut();
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}

Future<void> saveUserToFirestore({
  required String uid,
  required String email,
  required String name,
  required String surname,
  required String phone,
  required String role,
}) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'surname': surname,
      'phone': phone,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("User data saved successfully");
  } catch (e) {
    print("Error saving user data: $e");
  }
}
