// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, sort_child_properties_last, duplicate_ignore
import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../db/mostlyplayed.dart';
import '../../../db/playlist.dart';
import '../../../db/recentlyplayedmodel.dart';
import '../../../db/songfilemodel.dart';
import '../../../functions/dbfunctions.dart';
import '../../home/home_page.dart';

// ignore: must_be_immutable
class CurrentPlaylist extends StatefulWidget {
  CurrentPlaylist({super.key, required this.index, required this.playlistname});
  int? index;
  String? playlistname;
  @override
  State<CurrentPlaylist> createState() => _CurrentPlaylistState();
}

class _CurrentPlaylistState extends State<CurrentPlaylist> {
  var orientation, size, height, width;
  final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
  List<Audio> converted = [];
  @override
  void initState() {
    final playlistbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsong = playlistbox.values.toList();
    for (var i in playlistsong[widget.index!].playlistssongs!) {
      converted.add(
        Audio.file(
          i.songurl!,
          metas: Metas(
            title: i.songname,
            artist: i.artist,
            id: i.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    //size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final playlistbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsong = playlistbox.values.toList();
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                width: width / 1,
                height: height / 3.5,
                child: appbar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.5),
                  child: Column(
                    children: [
                      titleslib(
                          title: playlistsong[widget.index!].playlistname!),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: playlistbox.listenable(),
                          builder: (context, playlistsongs, child) {
                            List<PlaylistSongs> playlistsong =
                                playlistsongs.values.toList();
                            List<Songs> playsong =
                                playlistsong[widget.index!].playlistssongs!;

                            return playsong.isNotEmpty
                                ? GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    children: List.generate(
                                      playsong.length,
                                      (index) {
                                        log(playsong[index].songname!);
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    nowplayingscreen
                                                        .nowPlayingList
                                                        .value = playsong;
                                                    nowplayingscreen
                                                        .nowPlayingIndex
                                                        .value = index;
                                                    final mostValue =
                                                        MostPlayed(
                                                      id: playsong[index].id!,
                                                      count: 1,
                                                      songname: playsong[index]
                                                          .songname!,
                                                      artist: playsong[index]
                                                          .artist!,
                                                      songurl: playsong[index]
                                                          .songurl!,
                                                      duration: playsong[index]
                                                          .duration!,
                                                    );
                                                    addMostplayed(mostValue);
                                                    final value =
                                                        RecentlyPlayedModel(
                                                      id: playsong[index].id,
                                                      index: index,
                                                      songname: playsong[index]
                                                          .songname,
                                                      artist: playsong[index]
                                                          .artist,
                                                      songurl: playsong[index]
                                                          .songurl,
                                                      duration: playsong[index]
                                                          .duration,
                                                    );
                                                    addRecently(value);

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              nowplayingscreen()),
                                                    );
                                                    player.open(
                                                      Playlist(
                                                          audios: converted,
                                                          startIndex: index),
                                                      headPhoneStrategy:
                                                          HeadPhoneStrategy
                                                              .pauseOnUnplugPlayOnPlug,
                                                      showNotification: true,
                                                    );
                                                    Navigator.of(context)
                                                        .pushNamed('current');
                                                  },
                                                  child: QueryArtworkWidget(
                                                    id: playsong[index].id!,
                                                    type: ArtworkType.AUDIO,
                                                    nullArtworkWidget:
                                                        ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.asset(
                                                        'assests/images/logos.jpg',
                                                        height: 80,
                                                        width: 80,
                                                      ),
                                                    ),
                                                    keepOldArtwork: true,
                                                    artworkHeight: 123,
                                                    artworkWidth: 123,
                                                    artworkBorder:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        playsong[index]
                                                            .songname!,
                                                        // player
                                                        //     .getCurrentAudioTitle,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      .5,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    PopupMenuButton<int>(
                                                      itemBuilder: (context) =>
                                                          [
                                                        // PopupMenuItem 1
                                                        PopupMenuItem(
                                                          onTap: () {
                                                            playsong.removeAt(
                                                                index);
                                                            playlistbox.putAt(
                                                                widget.index!,
                                                                PlaylistSongs(
                                                                    playlistname:
                                                                        widget
                                                                            .playlistname,
                                                                    playlistssongs:
                                                                        playsong));
                                                          },
                                                          value: 1,
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                  Icons.delete),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text("Remove")
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                            //   },
                                            // ),
                                            );
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 158.0),
                                    child: Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                          );
                                        },
                                        child: Text(
                                          'Add songs',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 18, 15, 15)),
                                        ),
                                        color: Color.fromARGB(255, 8, 219, 117),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      // child: Text('NO SONGS'),
                                    ),
                                  );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

Padding titleslib({required String title}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, bottom: 10, top: 10),
    child: Row(
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            // ignore: prefer_const_constructors
            textStyle: TextStyle(letterSpacing: .5, fontSize: 20),
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
      child: Text('My Playlist',
          style:
              GoogleFonts.orbitron(fontSize: 27, fontWeight: FontWeight.bold)),
    ),
  );
}
