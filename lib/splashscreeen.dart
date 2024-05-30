import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder/wrapper.dart';
import 'homepage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const wrapper()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Homepage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.pink.shade100,
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(700),
                  bottomLeft: Radius.circular(300),
                  bottomRight: Radius.circular(700),
                  topRight: Radius.circular(300))),
        ),
        SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Center(
                child: Text(
                  'Welcome To Reminders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.orange,
                    decorationStyle: TextDecorationStyle.dashed,
                    letterSpacing: 2.0,
                    wordSpacing: 4.0,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 200,
                child: Image.asset("assets/image1.png"),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Made In Bharat with ❤️',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  decorationStyle: TextDecorationStyle.dashed,
                  letterSpacing: 2.0,
                  wordSpacing: 4.0,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
