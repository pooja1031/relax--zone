// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/SCREENS/bottom_navigation_bar/main_page.dart';

import 'package:music_app/db/songfilemodel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/mostlyplayed.dart';
import '../../main.dart';
import '../get_started/pageone.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

final audioQuery = OnAudioQuery();
final box = SongBox.getInstance();
final mostbox = MostplayedBox.getInstance();

final AudioPlayer _player = AudioPlayer();
String currentsongtitle = '';
int currentIndex = 0;

//final mostbox = Mostbox.getInstance();
List<SongModel> allSongs = [];
List<SongModel> getSongs = [];

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    gotohome();
    // TODO: implement initState
    super.initState();
    reqstpermission();
  }

  reqstpermission() async {
    bool permissionstatus = await audioQuery.permissionsStatus();
    if (!permissionstatus) {
      await audioQuery.permissionsRequest();
      getSongs = await audioQuery.querySongs();
      for (var element in getSongs) {
        if (element.fileExtension == "mp3") {
          allSongs.add(element);
        }
      }
      for (var element in allSongs) {
        await box.add(Songs(
            artist: element.artist,
            duration: element.duration,
            id: element.id,
            songurl: element.uri,
            songname: element.title));
      }

      // for (var items in allSongs) {
      //   mostbox.add(MostPlayed(
      //       songname: items.title,
      //       songurl: items.uri!,
      //       duration: items.duration!,
      //       artist: items.artist!,
      //       count: 0,
      //       id: items.id));
      // }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors

    return const Scaffold(
      backgroundColor: Colors.black,
      // ignore: prefer_const_constructors
      body: Center(
          // ignore: prefer_const_constructors
          child: Text('RELAX zone',
              // ignore: prefer_const_constructors
              style: TextStyle(
                // ignore: prefer_const_constructors
                color: Color.fromARGB(255, 94, 70, 157),
                fontSize: 30,
              ))),
    );
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotohome() async {
    // ignore: prefer_const_constructors
    await Future.delayed(Duration(seconds: 3));

    final sharedPrefs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPrefs.getBool(SAVE_KEY_NAME);

    if (userLoggedIn == null || userLoggedIn == false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const Screengetstarted()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const MainPage()),
      );
    }
  }
}
