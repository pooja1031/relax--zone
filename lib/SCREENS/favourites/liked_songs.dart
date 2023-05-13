// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/SCREENS/favourites/addtofavourites.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:music_app/db/likedsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../db/mostlyplayed.dart';
import '../../db/recentlyplayedmodel.dart';
import '../../functions/dbfunctions.dart';

class LikedSongs extends StatefulWidget {
  const LikedSongs({super.key});

  @override
  State<LikedSongs> createState() => _LikedSongsState();
}

final player = AssetsAudioPlayer.withId('0');

class _LikedSongsState extends State<LikedSongs> {
  final List<favourites> likedsongs = [];
  final box = FavouriteBox.getInstance();
  late List<favourites> liked = box.values.toList();
  List<Audio> favsongs = [];
  @override
  void initState() {
    final List<favourites> favsong = box.values.toList().reversed.toList();
    for (var i in favsong) {
      favsongs.add(Audio.file(i.songurl.toString(),
          metas: Metas(
            artist: i.artist,
            title: i.songname,
            id: i.id.toString(),
          )));
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height;
    return Container(
      color: Color.fromARGB(255, 9, 5, 5),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: height,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Color.fromARGB(66, 124, 114, 114),
                ),
              ),
              color: Color.fromARGB(255, 131, 116, 167),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  appbar(),
                  ValueListenableBuilder<Box<favourites>>(
                    valueListenable: box.listenable(),
                    builder: (context, Box<favourites> dbfavour, child) {
                      List<favourites> likedsongs =
                          dbfavour.values.toList().reversed.toList();
                      log(likedsongs.toString());
                      //log(likedsongs[0].songname!);
                      return Expanded(
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                            likedsongs.length,
                            (index) => favorite(
                              favour: favsongs,
                              audioPlayer: player,
                              index: index,
                              song: likedsongs[index].songname!,
                              image: likedsongs[index].id!,
                              time: likedsongs[index].duration!,
                              context: context,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//favorite gridview functions
Padding favorite({
  required List<Audio> favour,
  required AssetsAudioPlayer audioPlayer,
  required String song,
  required int image,
  required int time,
  required int index,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, top: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            List favSongs =
                FavouriteBox.getInstance().values.toList().reversed.toList();
            nowplayingscreen.nowPlayingList.value = favSongs;
            nowplayingscreen.nowPlayingIndex.value = index;
            final mostValue = MostPlayed(
              id: favSongs[index].id,
              count: 1,
              songname: favSongs[index].songname,
              artist: favSongs[index].artist,
              songurl: favSongs[index].songurl,
              duration: favSongs[index].duration,
            );
            addMostplayed(mostValue);
            final value = RecentlyPlayedModel(
              id: favSongs[index].id,
              index: index,
              songname: favSongs[index].songname,
              artist: favSongs[index].artist,
              songurl: favSongs[index].songurl,
              duration: favSongs[index].duration,
            );
            addRecently(value);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nowplayingscreen()),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: QueryArtworkWidget(
              keepOldArtwork: true,
              artworkBorder: BorderRadius.circular(10),
              id: image,
              artworkWidth: 140,
              artworkHeight: 140,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assests/images/logos.jpg',
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                song,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      letterSpacing: .5,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  List<favourites> likedsongs = favouritedb.values.toList();
                  int deletingIndex = likedsongs.length - index - 1;

                  favouritedb.deleteAt(deletingIndex);
                },
                icon: Icon(Icons.delete))
          ],
        ),
      ],
    ),
  );
}

AppBar appbar() {
  return AppBar(
    backgroundColor: Color.fromARGB(255, 131, 116, 167),
    title: Text('Liked songs'),
  );
}
