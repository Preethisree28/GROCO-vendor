import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/screens/screen_login.dart';

class HomesScreen extends StatelessWidget {
  static const String id = "home-screen";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('home screen'),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                    const LoginScreen(),
                  ),
                );
              });
            }, child:const Text('SIGN OUT')),
          ],
        ),
      ),
    );
  }
}
