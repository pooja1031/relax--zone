// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:music_app/SCREENS/splash/splash.dart';
import 'package:music_app/db/recentlyplayedmodel.dart';
import 'package:music_app/functions/dbfunctions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart' hide Action;
import '../../../db/mostlyplayed.dart';
import '../../../db/songfilemodel.dart';

import '../favourites/addtofavourites.dart';
import '../library/playlist/playlist_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static int? index = 0;
  static ValueNotifier<int> currentvalue = ValueNotifier<int>(index!);

  @override
  State<HomePage> createState() => _HomePageState();
}

final audioPlayer = AssetsAudioPlayer.withId('0');
final box = SongBox.getInstance();
List<Audio> convertAudios = [];

class _HomePageState extends State<HomePage> {
  var ProgressBar;

  // Stream<DurationState> get _durationStateStream =>
  //     Rx.combineLatest2<Duration, Duration?, DurationState>(
  //         _player.positionStream,
  //         _player.durationStream,
  //         (postion, duration) => DurationState(
  //             position: postion, total: duration ?? Duration.zero));
  int index = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final Screens = [const Center(child: Text("Home"))];
  final AudioPlayer _player = AudioPlayer();

  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  List allsongList = SongBox.getInstance().values.toList();
  bool isPlayerViewVisible = false;

  void _changePlayerViewVsibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  @override
  void initState() {
    // FocusManager.instance.primaryFocus?.unfocus();
    log(SongBox.getInstance().values.toList().toString());
    log(SongBox.getInstance().values.toList().toString());
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updatecurrentplayingsongDetails(index);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerViewVisible) {
      return nowPlaying(context);
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 114),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromARGB(255, 106, 94, 134),
                flexibleSpace: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    children: [
                                      // ignore: prefer_const_constructors
                                      Text("ALL SONGS",
                                          // ignore: prefer_const_constructors
                                          style: GoogleFonts.orbitron(
                                              textStyle: TextStyle(
                                                  // ignore: prefer_const_constructors
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontSize: 25,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 90,
                                            ),
                                            IconButton(
                                                iconSize: 40,
                                                onPressed: () {
                                                  showPlaylistOptionsadd(
                                                      context);
                                                },
                                                icon: const Icon(Icons.add))
                                          ],
                                        ),
                                      )
                                    ],
                                  )))
                        ])),
              )),
          //---------------songs view in home-----------------------------------

          backgroundColor: Color.fromARGB(255, 68, 67, 67),

          body: FutureBuilder<List<SongModel>>(
              future: audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                if (item.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (item.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    'No Songs Found',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  ));
                }
                songs.clear();
                songs = item.data!;
                return ListView.separated(
                  itemCount: allsongList.length,
                  itemBuilder: (context, index) {
                    Divider(height: 20);
                    return ListTile(
                      // ignore: prefer_const_constructors
                      leading: QueryArtworkWidget(
                        keepOldArtwork: true,
                        artworkBorder: BorderRadius.circular(10),
                        id: allsongList[index].id,
                        artworkHeight: 60,
                        artworkWidth: 60,
                        nullArtworkWidget: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(9), // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(38), // Image radius
                            child: Image.asset('assests/images/homemusics.png',
                                fit: BoxFit.cover),
                          ),
                        ),
                        //  ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child:
                        //   Image.asset(
                        //     // 'assests/images/4.jpeg',
                        //     "assests/images/homemusics.png",
                        //     height: 80,
                        //     width: 80,
                        //   ),
                        // ),
                        type: ArtworkType.AUDIO,
                      ),

                      title: Text(allsongList[index].songname,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              // ignore: prefer_const_constructors
                              overflow: TextOverflow.ellipsis,
                              color: Color.fromARGB(255, 236, 228, 228),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),

                      //  subtitle: Text(item.data![index].displayName),
                      trailing: IconButton(
                          iconSize: 27,
                          onPressed: () {
                            showOptions(context, index);
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color.fromARGB(255, 246, 238, 238),
                          )),

                      onTap: () async {
                        //show the player view
                        //  _changePlayerViewVsibility();
                        nowplayingscreen.nowPlayingList.value =
                            SongBox.getInstance().values.toList();

                        nowplayingscreen.nowPlayingIndex.value = index;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => nowplayingscreen(),
                        ));
                        final recentValue = RecentlyPlayedModel(
                          id: allsongList[index].id,
                          index: index,
                          songname: allsongList[index].songname,
                          artist: allsongList[index].artist,
                          songurl: allsongList[index].songurl,
                          duration: allsongList[index].duration,
                        );
                        addRecently(recentValue);

                        final mostValue = MostPlayed(
                          id: allsongList[index].id,
                          count: 1,
                          songname: allsongList[index].songname,
                          artist: allsongList[index].artist,
                          songurl: allsongList[index].songurl,
                          duration: allsongList[index].duration,
                        );

                        addMostplayed(mostValue);

                        // toast(context, "Playing:" + item.data![index].title);
                        // String? uri = item.data![index].uri;
                        //await _player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
                        await _player.setAudioSource(createPlaylist(item.data!),
                            initialIndex: index);
                        await _player.play();
                      },
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                );
              }),
        ),
      ),
    );
  }

  Scaffold nowPlaying(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 143, 244),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 56.0, right: 20.0, left: 20.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 172, 143, 244),
          ),
          child: Column(
            children: <Widget>[
              //exit button and song tittle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: InkWell(
                    // onTap: _changePlayerViewVsibility,
                    // onPressed
                    onTap: () {
                      final value = RecentlyPlayedModel(
                          id: songs[currentIndex].id,
                          index: index,
                          songname: songs[currentIndex].title,
                          songurl: songs[currentIndex].uri,
                          artist: songs[currentIndex].artist,
                          duration: songs[currentIndex].duration);
                      final mostValue = MostPlayed(
                          count: 1,
                          id: songs[currentIndex].id,
                          songname: songs[currentIndex].title,
                          songurl: songs[currentIndex].uri!,
                          artist: songs[currentIndex].artist!,
                          duration: songs[currentIndex].duration!);
                      addMostplayed(mostValue);

                      addRecently(value);
                      _changePlayerViewVsibility;
                    },

                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: getDecoration(
                          BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  )),
                  Flexible(
                    // ignore: sort_child_properties_last
                    child: Text(
                      currentsongtitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    flex: 5,
                  ),
                  Flexible(
                      child: IconButton(
                          onPressed: () {
                            showOptions(context, index);
                          },
                          icon: Icon(Icons.more_vert)))
                ],
              ),

              //mainplayer image
              Container(
                width: 440,
                height: 340,
                decoration: getDecoration(
                  BoxShape.rectangle,
                  const Offset(2, 2),
                  2.0,
                  0.0,
                ),
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                child: QueryArtworkWidget(
                  id: songs[currentIndex].id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(200.0),
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assests/images/logos.jpg',
                      //  'assests/images/relaxzone.png',
                      height: 60,
                      width: 100,
                    ),
                  ),
                ),
              ),

              //slider
              Column(
                children: [
                  //slider bar container
                  Container(
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.only(bottom: 4.0),
                    decoration: getRectDecoration(
                      BorderRadius.circular(20.0),
                      Offset(2, 2),
                      2.0,
                      0.0,
                    ),
                  ),

                  //  position/ progress
                  //   StreamBuilder<DurationState>(
                  //       stream: _durationStateStream,
                  //       builder: (context, snapshot) {
                  //         final durationState = snapshot.data;
                  //         final progress =
                  //             durationState?.position ?? Duration.zero;
                  //         final total = durationState?.total ?? Duration.zero;
                  //         return Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           mainAxisSize: MainAxisSize.max,
                  //           children: [
                  //             Flexible(
                  //                 child: Text(
                  //               progress.toString().split('.')[0],
                  //               style: const TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 15,
                  //               ),
                  //             )),
                  //             Flexible(
                  //                 child: Text(
                  //               total.toString().split('.')[0],
                  //               style: const TextStyle(
                  //                 color: Color.fromARGB(255, 239, 235, 235),
                  //                 fontSize: 15,
                  //               ),
                  //             )),
                  //           ],
                  //         );
                  //       })
                ],
              ),

              //prev, play/pause & seek next control buttons
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //skip to previous
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (_player.hasPrevious) {
                            _player.seekToPrevious();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: getDecoration(
                              BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    //play pause
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (_player.playing) {
                            _player.pause();
                          } else {
                            if (_player.currentIndex != null) {
                              _player.play();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          margin:
                              const EdgeInsets.only(right: 20.0, left: 20.0),
                          decoration: getDecoration(
                              BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                          child: StreamBuilder<bool>(
                            stream: _player.playingStream,
                            builder: (context, snapshot) {
                              bool? playingState = snapshot.data;
                              if (playingState != null && playingState) {
                                return const Icon(
                                  Icons.pause,
                                  size: 30,
                                  color: Colors.white70,
                                );
                              }
                              return const Icon(
                                Icons.play_arrow,
                                size: 30,
                                color: Colors.white70,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    //skip to next
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (_player.hasNext) {
                            _player.seekToNext();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: getDecoration(
                              BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                          child: const Icon(
                            Icons.skip_next,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //-------------------------------------------------------------
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //go to playlist btn
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _changePlayerViewVsibility();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: getDecoration(
                              BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                          child: const Icon(
                            Icons.list_alt,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    //favourites
                    Flexible(
                        child: InkWell(
                            onTap: () {
                              if (checkFavour(index, BuildContext)) {
                                addfavour(index);
                              } else if (!checkFavour(index, BuildContext)) {
                                // removefavour(index);
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              margin: const EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              decoration: getDecoration(BoxShape.circle,
                                  const Offset(2, 2), 2.0, 0.0),
                              // child:  Icon(
                              //   Icons.favorite,
                              //   color: Colors.white70,
                              // ),
                              child: checkFavour(index, BuildContext)
                                  ? Icon(
                                      Icons.add,
                                      color: Colors.white70,
                                    )
                                  : Icon(
                                      Icons.add,
                                      color: Colors.white70,
                                    ),
                            ))),
                    //shuffle playlist

                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _player.setShuffleModeEnabled(true);
                          // toast(context, "Shuffling enabled");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          // margin:
                          //     const EdgeInsets.only(right: 30.0, left: 30.0),
                          decoration: getDecoration(
                              BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                          child: const Icon(
                            Icons.shuffle,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
        color: Color.fromARGB(255, 9, 9, 9),
        shape: shape,
        boxShadow: [
          BoxShadow(
              offset: offset,
              color: Colors.white,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius),
          BoxShadow(
            offset: offset,
            color: Colors.white,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        ]);
  }

  void _updatecurrentplayingsongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentsongtitle = songs[index].title;
        currentIndex = index;
      }
    });
  }

  getRectDecoration(BorderRadius borderRadius, Offset offset, double blurRadius,
      double spreadRadius) {
    return BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: -offset,
            color: Colors.white,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        ]);
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
