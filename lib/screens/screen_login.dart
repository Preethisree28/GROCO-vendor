import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:grocery_vendor/screens/landing_screen.dart';


import '../utils/colors.dart';

class LoginScreen extends StatelessWidget {

  static const String id = "login-screen";
   const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // If the user is already signed-in, use it as initial data
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          // User is not signed in
          if (!snapshot.hasData) {
            return SignInScreen(
                headerBuilder: (context, constraints, _) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Expanded(
                        child: Column(
                          children: [
                            Image.asset("assets/images/logo.png", height: 65,),
                            const SizedBox(height: 2,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [

                                Text(
                                  'GRO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25,
                                    color: lightGreen,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'CO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25,
                                    color: ochre,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '- VENDOR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color:lightGreen,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                subtitleBuilder: (context, action) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        action == AuthAction.signIn
                            ? 'Welcome to GROCO- vendor! Please sign in to continue.'
                            : 'Welcome to GROCO- vendor! Please create an account to continue',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  );
                },
                footerBuilder: (context, _) {
                  return Column(
                    children: const [
                       SizedBox(height: 28,),
                      Text(
                        'By signing in, you agree to our terms and conditions.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
                providerConfigs: const [
                  EmailProviderConfiguration(),
                  // GoogleProviderConfiguration(clientId:'1:566940383901:android:9d96372f19a20f8b5c7274'),
                  PhoneProviderConfiguration(),
                ]);
          }

          // Render your application if authenticated

          return const LandingScreen();
        },
      ),
    );
  }
}
