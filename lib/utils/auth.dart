import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hera2/utils/router.dart' as router;

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    @required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      postSignIn(context);
    }

    return firebaseApp;
  }

  static Future<DocumentSnapshot> tryCreateUserRecord(
      BuildContext context) async {
    User user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userRecord = await ref.doc(user.uid).get();
    if (!userRecord.exists) {
      // no user record exists, time to create

      ref.doc(user.uid).set({});
      userRecord = await ref.doc(user.uid).get();
    }
    return userRecord;
  }

  static Future<void> postSignIn(BuildContext context) async {
    var userRecord = await tryCreateUserRecord(context);
    String nextRoute = router.DueDateRoute;
    if (userRecord.data().containsKey("dueDate")) {
      if (userRecord.data().containsKey("initialWeight")) {
        nextRoute = router.HomePageRoute;
      } else {
        nextRoute = router.InitialMeasurementsRoute;
      }
    }
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<User> signInWithGoogle({@required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'The account already exists with a different credential',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  static Future<void> signOut({@required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
