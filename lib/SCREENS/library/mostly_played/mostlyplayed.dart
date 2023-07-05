// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/SCREENS/library/recently_played/recently_played.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:music_app/functions/dbfunctions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../db/mostlyplayed.dart';
import '../../../db/recentlyplayedmodel.dart';
import '../../home/home_page.dart';

class MostPlayedPage extends StatefulWidget {
  const MostPlayedPage({super.key});

  @override
  State<MostPlayedPage> createState() => _MostPlayedPageState();
}

class _MostPlayedPageState extends State<MostPlayedPage> {
  // ignore: prefer_typing_uninitialized_variables
  var orientation, size, height, width;

  final box = MostplayedBox.getInstance();
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> songs = [];

  // @override
  // void initState() {
  //   List<MostPlayed> mostsong = box.values.toList();
  //   int i = 0;
  //   for (var element in mostsong) {
  //     if (element.count > 3) {
  //       mostplayedsongs.insert(i, element);
  //       i++;
  //     }
  //   }
  //   for (var items in mostplayedsongs) {
  //     songs.add(Audio.file(items.songurl,
  //         metas: Metas(
  //             title: items.songname,
  //             artist: items.artist,
  //             id: items.id.toString())));
  //   }

  //   super.initState();
  // }

  List<MostPlayed> mostplayedsongs = [];
  @override
  Widget build(BuildContext context) {
    List<MostPlayed> mostsong = box.values.toList();
    int i = 0;
    for (var element in mostsong) {
      if (element.count > 3) {
        mostplayedsongs.insert(i, element);
        i++;
      }
    }
    for (var items in mostplayedsongs) {
      songs.add(Audio.file(items.songurl,
          metas: Metas(
              title: items.songname,
              artist: items.artist,
              id: items.id.toString())));
    }
    orientation = MediaQuery.of(context).orientation;

    //size of the window
    size = MediaQuery.of(context).size;

    height = size.height;

    width = size.width;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 106, 94, 134),
          body: Stack(children: [
            Column(
              children: [
                SizedBox(
                  width: width / 1,
                  height: height / 9.5,
                  child: appbar(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.5),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: box.listenable(),
                          builder: (context, value, child) {
                            mostplayedsongs = box.values.toList();
                            mostplayedsongs.sort(
                              (a, b) => a.count.compareTo(b.count),
                            );
                            mostplayedsongs = mostplayedsongs.reversed
                                .toList()
                                .take(10)
                                .toList();
                            return mostplayedsongs.isNotEmpty
                                ? Expanded(
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      children: List.generate(
                                          mostplayedsongs.length, (index) {
                                        return favoritedummy(
                                            mostList: mostplayedsongs,
                                            audioplayer: audioPlayer,
                                            recentsongs: songs,
                                            index: index,
                                            context: context,
                                            song:
                                                mostplayedsongs[index].songname,
                                            image: mostplayedsongs[index].id,
                                            time: mostplayedsongs[index]
                                                .duration);
                                      }),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      " Mostly Played songs!!!",
                                      style: GoogleFonts.kanit(
                                          color: Colors.black),
                                    ),
                                  );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

//tittle
Padding titleslib({required String title}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, bottom: 10, top: 10),
    child: Row(
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            textStyle: TextStyle(letterSpacing: .5, fontSize: 20),
          ),
        ),
      ],
    ),
  );
}

//favourite to build dummy datas
Padding favoritedummy({
  required String song,
  required int image,
  required int time,
  required AssetsAudioPlayer audioplayer,
  required List<Audio> recentsongs,
  required int index,
  required BuildContext context,
  required List mostList,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // audioPlayer.open(Playlist(audios: recentsongs, startIndex: index),
            //     showNotification: true,
            //     headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
            //     loopMode: LoopMode.playlist);

            nowplayingscreen.nowPlayingList.value = mostList;
            nowplayingscreen.nowPlayingIndex.value = index;
            addMostplayed(mostList[index]);
            final value = RecentlyPlayedModel(
              id: mostList[index].id,
              index: index,
              songname: mostList[index].songname,
              artist: mostList[index].artist,
              songurl: mostList[index].songurl,
              duration: mostList[index].duration,
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
              artworkWidth: 138,
              artworkHeight: 138,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(48), // Image radius
                  child: Image.asset('assests/images/homemusics.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          song,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                letterSpacing: .5, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

AppBar appbar() {
  return AppBar(
    // ignore: prefer_const_constructors
    backgroundColor: Color.fromARGB(255, 131, 116, 167),
    // ignore: prefer_const_constructors
    title: Padding(
      padding: const EdgeInsets.only(top: 30, left: 20),
      child: Text('Mostly Played',
          style:
              GoogleFonts.orbitron(fontSize: 27, fontWeight: FontWeight.bold)),
    ),
  );
}
