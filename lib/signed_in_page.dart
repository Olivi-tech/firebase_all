import 'package:firebase_all/sign_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignedInPage extends StatelessWidget {
  const SignedInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        centerTitle: true,
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                // primary: Colors.red,
              ),
              onPressed: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logOut();
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                    //backgroundColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 140,
            ),
            const Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 60,
              // backgroundImage: NetworkImage(user?.photoURL.toString()) ??
              //     NetworkImage(
              //         'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg'),
              backgroundImage: user?.photoURL == null
                  ? const NetworkImage(
                      'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg')
                  : NetworkImage(user!.photoURL.toString()),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              //user?.displayName.toString() ?? 'No UserName'.toString(),
              user?.displayName == null
                  ? 'No UserName'.toString()
                  : user!.displayName.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'No eMail Given',
              //   user?.email == null ? 'Null' : user!.email.toString(),
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text(
              'UID : ${user!.uid}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.phoneNumber ?? 'No Number provider',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
