import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/firebase_services.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/registration_screen.dart';
import 'package:grocery_vendor/screens/screen_login.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _services = FirebaseService();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: _services.vendor.doc(_services.user!.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                    //while loading
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData && !snapshot.data!.exists) {//if no data exists
              return const RegistrationScreen();
            }

            Map<String, dynamic> vendor = snapshot.data!.data() as Map<String, dynamic>;
            if (vendor['approved'] == true) {
              return HomesScreen();
            }

               //landing screen
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl:vendor['logo'],
                            placeholder: (context, url) => Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        vendor['shopName'],
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Your application is sent to GROCO App Admin.\nAdmin will contact you soon, Confirmation pending!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen(),
                              ),
                            );
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text('Sign Out'),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

          }),
    );
  }
}
