import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
import 'package:get/get.dart';
import 'package:reminder/splashscreeen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyBtIxqKqEDHz2WL2_J_UnbYP4iczqdnGOw",
    appId: "1:89637514255:android:0c7622772b2254a373077a",
    messagingSenderId: '89637514255',
    projectId: "reminder-4414c",
    storageBucket: "reminder-4414c.appspot.com",
  ));

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: Splashscreen());
  }
}
