// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import '../../db/likedsongs.dart';
import '../../db/songfilemodel.dart';
import '../../functions/dbfunctions.dart';

addfavour(int index) async {
  final box = SongBox.getInstance();
  List<Songs> allsongs = box.values.toList();
  List<favourites> likedsongs = [];
  likedsongs = favouritedb.values.toList();

  bool isalready = likedsongs
      .where((element) => element.songname == allsongs[index].songname)
      .isEmpty;
  if (isalready) {
    favouritedb.add(
      favourites(
          id: allsongs[index].id,
          songname: allsongs[index].songname,
          artist: allsongs[index].artist,
          duration: allsongs[index].duration,
          songurl: allsongs[index].songurl),
    );
  } else {
    likedsongs
        .where((element) => element.songname == allsongs[index].songname)
        .isEmpty;
    int currentidx =
        likedsongs.indexWhere((element) => element.id == allsongs[index].id);
    await favouritedb.deleteAt(currentidx);
    await favouritedb.deleteAt(index);
  }
  log('added favorites....');
  log(likedsongs[index].songname!);
}

// ignore: non_constant_identifier_names

bool checkFavour(int index, BuildContext) {
  final box = SongBox.getInstance();
  List<Songs> allsongs = box.values.toList();
  List<favourites> favouritesongs = [];
  favourites value = favourites(
      id: allsongs[index].id,
      songname: allsongs[index].songname,
      artist: allsongs[index].artist,
      duration: allsongs[index].duration,
      songurl: allsongs[index].songurl);
  favouritesongs = favouritedb.values.toList();
  bool isAlready = favouritesongs
      .where((element) => element.songname == value.songname)
      .isEmpty;
  return isAlready ? true : false;
}
