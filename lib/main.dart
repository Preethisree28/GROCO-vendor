import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor/providers/auth_provider.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/screen_login.dart';
import 'package:grocery_vendor/screens/splash_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textButtonTheme:TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(8),
            ) ,
            side: MaterialStateProperty.all(
              const BorderSide(
                color: Colors.grey,
            ),
            ),
          ),
        ) ,
        primarySwatch: Colors.lightGreen,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(8),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomesScreen.id: (context) => HomesScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
