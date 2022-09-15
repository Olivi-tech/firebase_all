import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithEmail extends StatefulWidget {
  SignInWithEmail({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  late final TextEditingController _userControllerSignUp;
  late final TextEditingController _pwdControllerSignUp;
  late final TextEditingController _userControllerForLogin;
  late final TextEditingController _pwdControllerForLogin;
  late final TextEditingController _emailLinkController;
  final GlobalKey<FormState> _globalKeySignIn = GlobalKey<FormState>();

  //final GlobalKey<FormState> _globalKeySignUp = GlobalKey<FormState>();
  final GlobalKey<FormState> _globalKeySignSendLink = GlobalKey<FormState>();
  final FocusNode _focusNodeSignUp = FocusNode();
  final FocusNode _focusNodeEmailLink = FocusNode();
  final FocusNode _focusNodeSignIn = FocusNode();
  final GlobalKey<FormState> _globalKeySignUp = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userControllerSignUp = TextEditingController();
    _pwdControllerSignUp = TextEditingController();
    _userControllerForLogin = TextEditingController();
    _pwdControllerForLogin = TextEditingController();
    _emailLinkController = TextEditingController();
  }

  @override
  void dispose() {
    _userControllerSignUp.dispose();
    _pwdControllerSignUp.dispose();
    _userControllerForLogin.dispose();
    _pwdControllerForLogin.dispose();
    _emailLinkController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Email Screen',
          style: TextStyle(
              color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _globalKeySignIn,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusNodeSignIn);
                      },
                      controller: _userControllerForLogin,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('User Email'),
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _pwdControllerForLogin,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('User Pwd'),
                          hintText: 'User Pwd'),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Put Password';
                        }
                        return null;
                      },
                      focusNode: _focusNodeSignIn,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_globalKeySignIn.currentState!.validate()) {
                            var status = await loginUser();
                            customMessageSignIn(context, status);
                            Navigator.pop(context);
                            // Navigator.pushNamed(context, '/signed_in_page');
                          }
                        },
                        child: const Text('Login')),
                  ],
                ),
              ),
              Form(
                key: _globalKeySignUp,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusNodeSignUp);
                      },
                      controller: _userControllerSignUp,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('User Email'),
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter User Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _pwdControllerSignUp,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('User Pwd'),
                          hintText: 'User Pwd'),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "User Password Can't be Empty";
                        }
                      },
                      focusNode: _focusNodeSignUp,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_globalKeySignUp.currentState!.validate()) {
                            var status = await signUpUser();
                            customMessageSignUp(context, status);
                            Navigator.pop(context);
                            //   Navigator.pushNamed(context, '/signed_in_page');
                          }
                        },
                        child: const Text('Sign Up')),
                  ],
                ),
              ),
              Column(
                children: [
                  Form(
                    key: _globalKeySignSendLink,
                    child: TextFormField(
                      // autofocus: true,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodeEmailLink);
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please put your email';
                        }
                      },
                      controller: _emailLinkController,
                      decoration: const InputDecoration(
                        label: Text('Put email'),
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_globalKeySignSendLink.currentState!.validate()) {
                        await _signInWithEmailAndLink();
                        Navigator.pop(context);
                        //   Navigator.pushNamed(context, '/signed_in_page');
                      }
                    },
                    child: const Text('Send Link'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndLink() async {
    var userEmail = _emailLinkController.text;
    return await widget._auth
        .sendSignInLinkToEmail(
          email: userEmail,
          actionCodeSettings: ActionCodeSettings(
            url: 'https://Shakilawan.com',
            handleCodeInApp: true,
            androidPackageName: 'https:/com.example.firebase_all',
            androidInstallApp: false,
            androidMinimumVersion: '5',
          ),
        )
        .catchError(
            (onError) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Try Again Reason: $onError'),
                  backgroundColor: Colors.red,
                )))
        .then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Email for Login sent Successfully'),
              backgroundColor: Colors.green,
            )));
  }

  Future<String> signUpUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _userControllerSignUp.text,
        password: _pwdControllerSignUp.text,
      );
      return 'Account Created';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
    } catch (e) {
      return (e.toString());
    }
    return '';
  }

  Future<String> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userControllerForLogin.text,
          password: _pwdControllerForLogin.text);
      return 'Logged In';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return '';
  }

  void customMessageSignIn(BuildContext context, String status) {
    if (status == 'Logged In') {
      //    Navigator.pushNamed(context, '/second');
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(status),
      backgroundColor: status == 'Logged In' ? Colors.green : Colors.red,
    ));
  }

  void customMessageSignUp(BuildContext context, String status) {
    if (status == 'Account Created') {
      //  Navigator.pushNamed(context, '/second');
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(status),
      backgroundColor: status == 'Account Created' ? Colors.green : Colors.red,
    ));
  }
}
