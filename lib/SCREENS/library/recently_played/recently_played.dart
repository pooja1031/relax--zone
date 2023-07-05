import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/SCREENS/favourites/liked_songs.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:music_app/functions/dbfunctions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../bloc/recentyplayed_bloc/recentlyplayed_bloc.dart';
import '../../../db/mostlyplayed.dart';
import '../../../db/recentlyplayedmodel.dart';
import '../../home/home_page.dart';

class RecentlyPlayed extends StatelessWidget {
  RecentlyPlayed({super.key});

  var orientation, size, height, width;
  final player = AssetsAudioPlayer.withId('0');

  final List<RecentlyPlayedModel> recentsongs = [];
  final box = RecentlyPlayedBox.getInstance();
  late List<RecentlyPlayedModel> recent = box.values.toList();
  List<Audio> recsongs = [];
  @override
  Widget build(BuildContext context) {
    final List<RecentlyPlayedModel> recentsong =
        box.values.toList().reversed.toList();
    for (var i in recentsong) {
      recsongs.add(Audio.file(i.songurl.toString(),
          metas: Metas(
            artist: i.artist,
            title: i.songname,
            id: i.id.toString(),
          )));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RecentlyplayedBloc>(context).add(GetRecentlyPlayed());
    });
    orientation = MediaQuery.of(context).orientation;
    //size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 131, 116, 167),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 131, 116, 167),
          title: Text('Recently Played'),
        ),
        body: SafeArea(
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  width: width / 1,
                  height: height / 15.5,
                ),
                BlocBuilder<RecentlyplayedBloc, RecentlyplayedState>(
                    builder: (context, state) {
                  if (state is RecentlyplayedInitial) {
                    context.read<RecentlyplayedBloc>().add(GetRecentlyPlayed());
                  }
                  if (state is DisplayRecently) {
                    return state.recentPlay.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.5),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      children: List.generate(
                                        recentsongs.length,
                                        (index) => favoritedummy(
                                            index: index,
                                            context: context,
                                            recentsongs: recsongs,
                                            audioplayer: player,
                                            song: recentsongs[index].songname!,
                                            image: recentsongs[index].id!,
                                            time: recentsongs[index].duration!),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Your Recently played songs",
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                          );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ],
            ),
          ]),
        ),
      ),
    );
  }

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
              //  Navigator.of(context).pushNamed('current');
              List recentList = RecentlyPlayedBox.getInstance()
                  .values
                  .toList()
                  .reversed
                  .toList();
              addRecently(recentList[index]);
              final mostValue = MostPlayed(
                id: recentList[index].id,
                count: 1,
                songname: recentList[index].songname,
                artist: recentList[index].artist,
                songurl: recentList[index].songurl,
                duration: recentList[index].duration,
              );
              addMostplayed(mostValue);

              nowplayingscreen.nowPlayingList.value = recentList;
              nowplayingscreen.nowPlayingIndex.value = index;

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
}
