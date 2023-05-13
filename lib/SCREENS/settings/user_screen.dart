// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/SCREENS/settings/aboutus/about_us.dart';
import 'package:music_app/SCREENS/settings/privacy/privacy%20_policy.dart';
import 'package:music_app/SCREENS/settings/Terms_and_conditions/terms_conditions.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        // ignore: duplicate_ignore
        child: Scaffold(
          // ignore: prefer_const_constructors
          backgroundColor: Color.fromARGB(255, 131, 116, 167),
          body: Column(children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Settings',
              // ignore: prefer_const_constructors
              style: GoogleFonts.orbitron(
                textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Privacy()),
                );
              },
              child: ListTile(
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.lock_outlined),
                  color: Color.fromARGB(255, 12, 12, 12),
                  iconSize: 35,
                ),
                title: Text(
                  'Privacy and Policy',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Terms()),
                );
              },
              child: ListTile(
                leading: IconButton(
                  onPressed: (() {}),
                  icon: Icon(Icons.privacy_tip_outlined),
                  color: Colors.black,
                  iconSize: 35,
                ),
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Aboutus()),
                );
              },
              child: ListTile(
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.event_note_outlined),
                  color: Colors.black,
                  iconSize: 35,
                ),
                title: Text(
                  'About Us',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }
}
