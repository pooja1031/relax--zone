// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:music_app/SCREENS/splash/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../favourites/addtofavourites.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  static int index = 0;
  static ValueNotifier<int> enteredvalue = ValueNotifier<int>(index);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

  var width, height;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => nowplayingscreen(),
        ));
      },
      child: ValueListenableBuilder(
          valueListenable: nowplayingscreen.nowPlayingIndex,
          builder: (context, songindex, child) {
            return ValueListenableBuilder(
                valueListenable: nowplayingscreen.nowPlayingList,
                builder: (context, songList, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Color.fromARGB(255, 170, 156, 205),
                    width: deviceSize.width,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QueryArtworkWidget(
                          id: songList[songindex].id,
                          type: ArtworkType.AUDIO,
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget:
                              Image.asset('assests/images/relaxzone.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          // ignore: sort_child_properties_last
                          child: Text(
                            songList[nowplayingscreen.nowPlayingIndex.value]
                                .songname,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: IconButton(
                              onPressed: () {
                                addfavour(
                                    nowplayingscreen.nowPlayingIndex.value);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.favorite,
                                size: 40,
                                color: checkFavour(
                                        nowplayingscreen.nowPlayingIndex.value,
                                        context)
                                    ? Colors.white70
                                    : Colors.green,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: PlayerBuilder.isPlaying(
                              player: player,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  onPressed: () async {
                                    if (isPlaying) {
                                      await player.pause();
                                    } else {
                                      await player.play();
                                      //playbutton(player,

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
                                          size: 40,
                                        )
                                      : const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}

Future<void> showbottomsheets(BuildContext ctx) async {
  showModalBottomSheet(
      context: ctx,
      builder: (ctx1) {
        return Container(
          // ignore: prefer_const_literals_to_create_immutables
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Color(0x55212121), blurRadius: 8.0)
          ]),
          child: Column(
            children: [
              Slider.adaptive(
                value: 0.0,
                onChanged: (value) {},
              ),
              Row(
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                  )
                ],
              )
            ],
          ),
        );
      });
}
