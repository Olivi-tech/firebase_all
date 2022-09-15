import 'package:firebase_all/sign_in_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBfpfnHA788PYl3s8TU9PEiRbFbGSSi638",
            authDomain: "fir-all-82d6d.firebaseapp.com",
            projectId: "fir-all-82d6d",
            storageBucket: "fir-all-82d6d.appspot.com",
            messagingSenderId: "727556694158",
            appId: "1:727556694158:web:21328d7ac389e579e169df",
            measurementId: "G-JXSJ5P9L9P"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AnimatedSplashScreen(
          nextScreen: const HomePage(),
          splash: Lottie.asset('assets/loading-circles.json'),
          // duration: 2,
          splashTransition: SplashTransition.rotationTransition,
          centered: true,
          pageTransitionType: PageTransitionType.rightToLeft,
          animationDuration: const Duration(milliseconds: 1000),
        ),
      )));
}

//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       home: const HomePage(),
//       //  initialRoute: '/',
//       // routes: {
//       //   '/': (context) => const HomePage(),
//       //   '/login_email': (context) => SignInWithEmail(),
//       //   '/signed_in_page': (context) => const SignedInPage(),
//       // },
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//     );
//   }
// }
