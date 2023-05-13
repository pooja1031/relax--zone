// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../bottom_navigation_bar/main_page.dart';

class Screengetstarted extends StatelessWidget {
  const Screengetstarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: duplicate_ignore
      body: Container(
          width: double.infinity,
          height: double.infinity,
          // ignore: prefer_const_constructors, duplicate_ignore, duplicate_ignore
          decoration: BoxDecoration(
            // ignore: prefer_const_constructors
            image: DecorationImage(
                // ignore: prefer_const_constructors
                image: AssetImage("assests/images/background images.png"),
                fit: BoxFit.cover),
          ),
          // ignore: prefer_const_constructors
          padding: EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              Text(
                "FIND YOUR\nFAVOURITE\nMUSIC",
                style: GoogleFonts.orbitron(
                  textStyle: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 38.0,
                      height: 1.4,
                      fontWeight: FontWeight.w600),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 60,
                width: 150,
                child: MaterialButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final _sharedPrefs = await SharedPreferences.getInstance();
                    await _sharedPrefs.setBool(SAVE_KEY_NAME, true);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },

                  // ignore: sort_child_properties_last

                  child: Text(
                    'GET STARTED',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 8, 219, 117),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            ],
          )),

      // backgroundColor: Color.fromARGB(255, 94, 70, 157),
    );
  }
}
