// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stepwise/core/components/failure/faliure_bar.dart';
import 'package:stepwise/core/components/success/success_bar.dart';

class AuthController {
  //  Instance for Firebase Firestore
  final FirebaseAuth auth = FirebaseAuth.instance;

  //  Method to sign the user into the application
  Future<void> signInWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      successBar(context: context, message: "User Signed In Successfully");
    } catch (error) {
      faliureBar(
        context: context,
        message: "Unexpected Error Occurred while Signing In: $error",
      );
      throw Exception("Unexpected Error Occurred while Signing In: $error");
    }
  }

  //  Method to sign the user out of the application
  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      successBar(context: context, message: "User Signed Out Successfully");
    } catch (error) {
      faliureBar(
        context: context,
        message: "Unexpected Error Occurred while Signing Out: $error",
      );
      throw Exception("Unexpected Error Occurred while Signing Out: $error");
    }
  }

  //  Method to sign the user up for the application
  Future<void> signUpWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      successBar(context: context, message: "User Signed Up Successfully");
    } catch (error) {
      faliureBar(
        context: context,
        message: "Unexpected Error Occurred while Signing Up: $error",
      );
      throw Exception("Unexpected Error Occurred while Signing Up: $error");
    }
  }

  //  Method to recover forgotten password using redirection services form firebase
  Future<void> recoverPassword(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      successBar(context: context, message: "Password Reset Email Sent");
    } catch (error) {
      faliureBar(
        context: context,
        message: "Unexpected Error Occurred while Recovering Password: $error",
      );
      throw Exception("Unexpected Error Occurred: $error");
    }
  }
}
