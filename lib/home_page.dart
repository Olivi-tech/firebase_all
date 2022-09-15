import 'package:firebase_all/phone_number_auth.dart';
import 'package:firebase_all/sign_in_provider.dart';
import 'package:firebase_all/sign_in_with_email.dart';
import 'package:firebase_all/signed_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Some Thing Has Went Wrong',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  backgroundColor: Colors.red),
            ));
          } else if (snapshot.hasData) {
            return const SignedInPage();
          } else {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  'FireBase',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                      child: const Center(
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: SizedBox(
                        height: height * 0.2,
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            'assets/my_picture.jpg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: SizedBox(
                        height: height * 0.3,
                        child: Center(
                          child: Column(
                            children: [
                              SignInButton(Buttons.Google, onPressed: () {
                                provider.googleLogin(context);
                              }),
                              ElevatedButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(220, 35))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PhoneNumberAuth()));
                                  },
                                  icon:
                                      const Icon(Icons.perm_phone_msg_outlined),
                                  label: const Padding(
                                    padding: EdgeInsets.only(right: 55.0),
                                    child: Text('Login with Phone'),
                                  )),
                              SignInButton(Buttons.Email, onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignInWithEmail()));
                              }),
                              SignInButton(Buttons.FacebookNew,
                                  onPressed: () async {
                                await provider.signInWithFacebook();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           const SignedInPage(),
                                //     ));
                              }),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
