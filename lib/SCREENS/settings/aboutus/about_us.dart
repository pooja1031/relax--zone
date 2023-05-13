import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Color.fromARGB(255, 131, 116, 167),
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    // ignore: prefer_const_constructors
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 68.0),
                  child: Text(
                    "About Us",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(right: 28.0, left: 30),
              // ignore: prefer_const_constructors
              child: Text(
                "\n\nWe are a team of passionate music lovers who have come together to create a better music listening experience for you. Our app is designed to make it easy for you to discover new music, create personalized playlists, and enjoy your favorite tracks anytime, anywhere.We believe in the power of music to bring people together, and we strive to create a welcoming and inclusive community for music fans of all kinds. We are constantly working to improve the app and add new features to enhance your listening experience.Thank you for choosing [app name] as your go-to music player. We hope you enjoy using it as much as we enjoyed creating it. If you have any feedback or suggestions, we would love to hear from you. Contact us at [contact information].''',",
                // ignore: prefer_const_constructors
              ),
            )
          ],
        ),
      )),
    );
  }
}
