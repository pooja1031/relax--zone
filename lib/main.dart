import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/db/mostlyplayed.dart';
import 'package:music_app/functions/dbfunctions.dart';
import 'SCREENS/splash/splash.dart';
import 'db/likedsongs.dart';
import 'db/playlist.dart';
import 'db/recentlyplayedmodel.dart';
import 'db/songfilemodel.dart';

const SAVE_KEY_NAME = 'UserLoggedIn';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>(boxname);
  Hive.registerAdapter(RecentlyPlayedModelAdapter());
  await Hive.openBox<RecentlyPlayedModel>(recentbox);
  openrecentlyplayeddb();
  Hive.registerAdapter(favouritesAdapter());
  openfavourite();
  Hive.registerAdapter(PlaylistSongsAdapter());
  await Hive.openBox<PlaylistSongs>('playlist');
  Hive.registerAdapter(MostPlayedAdapter());
  openmostplayeddb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenSplash(),
    );
  }
}
