import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  void googleLogin(BuildContext context) async {
    try {
      var googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      } else {
        _user = googleUser;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Some thing went wrong')));
      notifyListeners();
    }
  }

  Future logOut() async {
    await googleSignIn.disconnect().whenComplete(() async {
      await FirebaseAuth.instance.signOut();
    });
    await FacebookAuth.instance.logOut().whenComplete(() async {
      await FirebaseAuth.instance.signOut();
    });
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }
}
