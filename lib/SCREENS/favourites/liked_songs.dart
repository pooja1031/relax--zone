// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/SCREENS/favourites/addtofavourites.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
import 'package:music_app/db/likedsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../bloc/favourites_bloc/favourites_bloc.dart';
import '../../db/mostlyplayed.dart';
import '../../db/recentlyplayedmodel.dart';
import '../../functions/dbfunctions.dart';

class LikedSongs extends StatelessWidget {
  LikedSongs({super.key});

  final List<favourites> likedsongs = [];

  final box = FavouriteBox.getInstance();
  final player = AssetsAudioPlayer.withId('0');
  late List<favourites> liked = box.values.toList();
  List<Audio> favsongs = [];
  @override
  @override
  Widget build(BuildContext context) {
    final List<favourites> favsong = box.values.toList().reversed.toList();
    for (var i in favsong) {
      favsongs.add(Audio.file(i.songurl.toString(),
          metas: Metas(
            artist: i.artist,
            title: i.songname,
            id: i.id.toString(),
          )));
    }
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
                  BlocBuilder<FavouritesBloc, FavouritesState>(
                    builder: (context, state) {
                      if (state is FavouritesInitial) {
                        context.read<FavouritesBloc>().add(GetFavSongs());
                      }
                      if (state is DisplayFavSongs) {
                        return state.favorites.isNotEmpty
                            ? Expanded(
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                    state.favorites.length,
                                    (index) => favorite(
                                      favour: favsongs,
                                      audioPlayer: player,
                                      index: index,
                                      song: state.favorites[index].songname!,
                                      image: state.favorites[index].id!,
                                      time: state.favorites[index].duration!,
                                      context: context,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: const Text(
                                  "You haven't liked any songs!",
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
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
