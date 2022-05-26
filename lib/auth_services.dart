import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

///For authenticating user using firebase authentication
///handles signIn, signOut, logOut, forgotPassword

class AuthServices {
  late SharedPreferences loginState;

  FirebaseAuth auth = FirebaseAuth.instance;

  //for logging in the user
  Future login(String email, String password) async {
    loginState = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }

    //   auth.signInWithEmailAndPassword(email: email, password: password,)
    //     .then((value) {
    //       print("Value : $value");
    //   loginState.setBool('loggedIn', true);
    //
    //   //Get.offAndToNamed('/home');
    // })
    //     .catchError((error){
    //     print(error);
    //       //catchError(error.code);
    // });
  }

  //create new user
  Future register(String email, String password, String fName) async {
    loginState = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      User? user = FirebaseAuth.instance.currentUser;

      FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
          {'name': fName, 'email': user.email, 'token': fcmToken},
          SetOptions(merge: true));

      loginState.setBool('loggedIn', false);

      //Get.offAndToNamed('/login');
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    } catch (e) {
      print("E: $e");
      return e;
    }
  }

  //logs out the user
  logOut() async {
    loginState = await SharedPreferences.getInstance();
    auth.signOut();
    GoogleSignIn().signOut();
    loginState.setBool('loggedIn', false);
    Get.offNamedUntil('/login', (route) => false);
  }

  //for signingIn with google
  Future googleSignIn() async {
    loginState = await SharedPreferences.getInstance();

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential =
            await auth.signInWithCredential(authCredential);
        User? user = userCredential.user;

        if (user != null) {
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          User? user = FirebaseAuth.instance.currentUser;

          print(
              "Email: ${user!.email} Name: ${user.displayName} TOken : ${fcmToken}");

          FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': user.displayName,
            'email': user.email,
            'token': fcmToken
          }, SetOptions(merge: true));

          loginState.setBool('loggedIn', true);
          //Get.offAndToNamed('/home');

          return "Success";
        }
      }
      return "none";
    } on FirebaseAuthException catch (e) {
      print("e.code : ${e.code}");
      return e.code;
    } catch (e) {
      print("Error : $e");
      return "undefined";
    }
  }

  //resets the password
  Future forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showSnackBar("Password reset email sent.", backgroundColor: Colors.green);
      //Get.offAndToNamed("/login");
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
  }

  //catches Firebase Auth error
  catchError(String errorCode) {
    switch (errorCode) {
      case "invalid-emailL":
        showSnackBar("Your email address appears to be malformed.");
        break;
      case "weak-password":
        showSnackBar("Password should be of at least 6  characters");
        break;
      case "wrong-password":
        showSnackBar("Your password is wrong.");
        break;
      case "user-not-found":
        showSnackBar("User with this email doesn't exist.");
        break;
      case "ERROR_USER_DISABLED":
        showSnackBar("User with this email has been disabled.");
        break;
      case "email-already-in-use":
        showSnackBar("This email address is already being used.");
        break;
      case "network-request-failed":
        showSnackBar("You are offline.");
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        showSnackBar("Too many requests. Try again later.");
        break;
      case "none":
        break;
      // case "ERROR_OPERATION_NOT_ALLOWED":
      //   errorMessage = "Signing in with Email and Password is not enabled.";
      //   break;
      default:
        showSnackBar("An undefined Error happened.");
    }
  }

  //displays snackBar
  showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    Get.snackbar(
      message,
      '',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: backgroundColor,
    );
  }
}
