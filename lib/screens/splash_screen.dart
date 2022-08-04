import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/registration_screen.dart';
import 'package:grocery_vendor/screens/screen_login.dart';
import 'package:grocery_vendor/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'Splash screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double customOpacity = 0;
  @override
  void initState() {
    Timer(const  Duration(seconds:5),
        //callback function
            () {
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if(user == null) {
              Navigator.pushReplacementNamed(
                context,
                LoginScreen.id,
              );
            }
          });
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                onEnd: (){
                  setState(() {
                    customOpacity = 1;
                  });
                },
                curve:Curves.bounceOut,
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 50, end: 100),
                builder: (BuildContext context, double value, Widget? child) {
                  return Image.asset('assets/images/logo.png',
                    height: value,
                    width: value,
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: customOpacity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'GRO',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CO',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                        color: Colors.yellow,
                      ),
                    ),
                    Text(
                      '- VENDOR',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
