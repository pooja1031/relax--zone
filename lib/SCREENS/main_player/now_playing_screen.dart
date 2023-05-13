// ignore_for_file: annotate_overrides, prefer_const_constructors
import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:music_app/SCREENS/favourites/addtofavourites.dart';
import 'package:music_app/db/songfilemodel.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../library/playlist/playlist_screen.dart';

// ignore: camel_case_types
class nowplayingscreen extends StatefulWidget {
  nowplayingscreen({super.key});
  static List listNotifier = SongBox.getInstance().values.toList();
  static ValueNotifier<List> nowPlayingList = ValueNotifier<List>(listNotifier);
  static ValueNotifier<int> nowPlayingIndex = ValueNotifier<int>(0);

  @override
  State<nowplayingscreen> createState() => _nowplayingscreenState();
}

AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
int index = 0;
List<Audio> convertAudios = [];

// ignore: camel_case_types
class _nowplayingscreenState extends State<nowplayingscreen>
    with SingleTickerProviderStateMixin {
  @override
  // ignore: override_on_non_overriding_member
  late AnimationController iconController;
  bool isAnimated = true;
  bool willlPlay = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    // if (!player.isPlaying.value) {
    player.open(
      Audio.file(nowplayingscreen.nowPlayingList
          .value[nowplayingscreen.nowPlayingIndex.value].songurl),
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
      loopMode: LoopMode.playlist,
    );

    // }

    iconController.forward();
  }

  Widget build(BuildContext context) {
    //log('yeeeeeeeeeeeey');
    log(nowplayingscreen.nowPlayingIndex.value.toString());

    return ValueListenableBuilder(
        valueListenable: nowplayingscreen.nowPlayingIndex,
        builder: (context, songindex, child) {
          return ValueListenableBuilder(
              valueListenable: nowplayingscreen.nowPlayingList,
              builder: (context, songList, child) {
                return Container(
                  color: Colors.white,
                  child: SafeArea(
                    child: Scaffold(
                      backgroundColor: Color.fromARGB(255, 131, 116, 167),
                      body: Column(
                        children: [
                          ListTile(
                            leading: IconButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                )),
                            trailing: IconButton(
                                onPressed: () {
                                  showOptions(context, index);
                                },
                                // ignore: prefer_const_constructors
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                )),
                          ),

                          SizedBox(
                            height: 50,
                          ),
                          //song image-----------------------------
                          Container(
                            child: QueryArtworkWidget(
                              id: songList[songindex].id,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget:
                                  Image.asset('assests/images/relaxzone.png'),
                            ),
                            width: 330,
                            height: 320,
                            decoration: getDecoration(
                              BoxShape.rectangle,
                              const Offset(2, 2),
                              2.0,
                              0.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              songList[nowplayingscreen.nowPlayingIndex.value]
                                  .songname,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(songList[songindex].artist),
                          SizedBox(
                            height: 30,
                          ),
                          ShuffleAndFavourite(),

                          ////slider & progressbar---------------------
                          ///
                          SizedBox(
                            height: 10,
                          ),

                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: 30,
                                child: player.builderCurrent(
                                    builder: (context, isPlaying) {
                                  return PlayerBuilder.realtimePlayingInfos(
                                    player: player,
                                    builder: (context, realtimePlayingInfos) {
                                      duration = realtimePlayingInfos
                                          .current!.audio.duration;
                                      position =
                                          realtimePlayingInfos.currentPosition;

                                      return ProgressBar(
                                        baseBarColor: Colors.black38,
                                        progressBarColor:
                                            Color.fromARGB(206, 20, 20, 20),
                                        thumbColor: Colors.black,
                                        thumbRadius: 5,
                                        timeLabelPadding: 5,
                                        progress: position,
                                        timeLabelTextStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        total: duration,
                                        onSeek: (duration) async {
                                          await player.seek(duration);
                                        },
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                          PlayerBuilder.isPlaying(
                            player: player,
                            builder: (context, isPlaying) {
                              return SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          player.seekBy(
                                            const Duration(seconds: -10),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.replay_10_rounded,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        // previous(
                                        //     player, value, allDbdongs);

                                        previous(player, songindex, songList);
                                        iconController.forward();
                                        // setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.skip_previous_outlined,
                                        color: Colors.black,
                                        size: 44,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(35),
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              if (isPlaying) {
                                                await player.pause();
                                              } else {
                                                await player.play();
                                                //playbutton(player,
                                                //  value, allDbdongs);
                                              }
                                              setState(
                                                () {
                                                  isPlaying = !isPlaying;
                                                },
                                              );
                                            },
                                            icon: (isPlaying)
                                                ? const Icon(
                                                    Icons.pause,
                                                    color: Colors.white,
                                                    size: 35,
                                                  )
                                                : const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          // next(player, value,
                                          //   allDbdongs);
                                          // player.next();
                                          next(player, songindex, songList);
                                          iconController.forward();
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.skip_next_outlined,
                                          color: Colors.black,
                                          size: 44,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          player.seekBy(
                                            const Duration(seconds: 10),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.forward_10_sharp,
                                          color: Colors.black,
                                          size: 40,
                                        ))
                                  ],
                                ),
                              );
                            },
                          ),
//play pause-----------------------------------------------
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  void previous(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<dynamic> dbsongs) async {
    //Exception...

    if (index == 0) {
      player.open(
        Audio.file(dbsongs[dbsongs.length - 1].songurl!),
        showNotification: true,
      );
      setState(() {
        nowplayingscreen.nowPlayingIndex.value = dbsongs.length - 1;
      });
      return;
    }

    //.......

    player.open(
      Audio.file(dbsongs[index - 1].songurl!),
      showNotification: true,
    );

    setState(() {
      nowplayingscreen.nowPlayingIndex.value--;
    });
    await player.stop();
  }

  void next(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<dynamic> dbsongs) async {
    //Exception...

    if (index + 1 == dbsongs.length) {
      player.open(
        Audio.file(dbsongs[0].songurl!),
        showNotification: true,
      );
      setState(() {
        nowplayingscreen.nowPlayingIndex.value = 0;
      });
      return;
    }

    //.......

    player.open(
      Audio.file(dbsongs[index + 1].songurl!),
      showNotification: true,
    );

    setState(() {
      nowplayingscreen.nowPlayingIndex.value++;
    });

    await player.stop();
  }
}

class ShuffleAndFavourite extends StatefulWidget {
  ShuffleAndFavourite({
    Key? key,
  }) : super(key: key);

  @override
  State<ShuffleAndFavourite> createState() => _ShuffleAndFavouriteState();
}

class _ShuffleAndFavouriteState extends State<ShuffleAndFavourite> {
  bool isShuffled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          //liked
          Flexible(
            child: InkWell(
              onTap: () {
                nowplayingscreen.nowPlayingList.value.shuffle();
                isShuffled = true;
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.only(right: 90.0),
                child: Icon(
                  Icons.shuffle,
                  color: isShuffled == true ? Colors.black : Colors.white70,
                  size: 30,
                ),
              ),
            ),
          ),
          //play pause
          Flexible(
            child: InkWell(
              onTap: () {
                addfavour(nowplayingscreen.nowPlayingIndex.value);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.only(left: 160.0),
                child: Icon(
                  Icons.favorite,
                  color: checkFavour(
                          nowplayingscreen.nowPlayingIndex.value, context)
                      ? Colors.white70
                      : Colors.green,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
