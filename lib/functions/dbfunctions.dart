import 'package:hive/hive.dart';

import '../db/likedsongs.dart';
import '../db/mostlyplayed.dart';
import '../db/recentlyplayedmodel.dart';

late Box<favourites> favouritedb;
openfavourite() async {
  favouritedb = await Hive.openBox<favourites>(favourbox);
}

late Box<RecentlyPlayedModel> recentlyPlayedBox;
openrecentlyplayeddb() async {
  recentlyPlayedBox = await Hive.openBox("recentlyplayed");
}

addRecently(RecentlyPlayedModel value) {
  List<RecentlyPlayedModel> list = recentlyPlayedBox.values.toList();
  bool isAlready =
      list.where((element) => element.songname == value.songname).isEmpty;
  if (isAlready == true) {
    recentlyPlayedBox.add(value);
  } else {
    int index =
        list.indexWhere((element) => element.songname == value.songname);
    recentlyPlayedBox.deleteAt(index);
    recentlyPlayedBox.delete(value);
    recentlyPlayedBox.add(value);
  }
}

late Box<MostPlayed> mostplayedsongs;
openmostplayeddb() async {
  mostplayedsongs = await Hive.openBox("Mostplayed");
}

addMostplayed(MostPlayed value) {
  final box = MostplayedBox.getInstance();
  List<MostPlayed> list = box.values.toList();
  bool isNotAdded = list.where((element) => element.id == value.id).isEmpty;
  if (isNotAdded == true) {
    box.add(value);
  } else {
    int listindex = list.indexWhere((element) => element.id == value.id);
    int count = list[listindex].count;
    list[listindex].count = count + 1;
  }
}
