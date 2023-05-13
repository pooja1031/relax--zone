// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/SCREENS/main_player/now_playing_screen.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../db/songfilemodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
final TextEditingController searchcontroller = TextEditingController();
TextEditingController _searchController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  late List<Songs> dbsongs = [];
  List<Audio> allsongs = [];

  late List<Songs> searchlist = List.from(dbsongs);

  bool istaped = true;
  final box = SongBox.getInstance();
  @override
  void initState() {
    dbsongs = box.values.toList();
    log(dbsongs.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          // ignore: prefer_const_constructors
          backgroundColor: Color.fromARGB(255, 106, 94, 134),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    //autofocus: true,
                    controller: _searchController,
                    cursorColor: Color.fromARGB(255, 14, 13, 13),
                    decoration: InputDecoration(
                      filled: true,
                      // ignore: prefer_const_constructors
                      fillColor: Color.fromARGB(255, 235, 223, 223),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search your favourite song here !!!",
                      // ignore: prefer_const_constructors
                      hintStyle: TextStyle(
                        // ignore: prefer_const_constructors
                        color: Color.fromARGB(255, 94, 70, 157),
                      ),
                      // ignore: prefer_const_constructors
                      prefixIcon: Icon(
                        Icons.search,
                        // ignore: prefer_const_constructors
                        color: Color.fromARGB(255, 94, 70, 157),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color.fromARGB(255, 94, 70, 157),
                        ),
                        onPressed: () => _searchController.clear(),
                        //Navigator.of(context).pop(),
                      ),
                      // ignore: prefer_const_constructors
                      prefixIconColor: Color.fromARGB(255, 94, 70, 157),
                    ),
                    onChanged: (value) {
                      updatesearch(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                searchlist.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchlist.length,
                          itemBuilder: ((context, index) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8.0, left: 5),
                                child: ListTile(
                                  onTap: () {
                                    nowplayingscreen.nowPlayingList.value =
                                        searchlist;
                                    nowplayingscreen.nowPlayingIndex.value =
                                        index;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              nowplayingscreen()),
                                    );

                                    player.open(
                                      Audio.file(searchlist[index].songurl!,
                                          metas: Metas(
                                              title: searchlist[index].songname,
                                              artist: searchlist[index].artist,
                                              id: searchlist[index]
                                                  .id
                                                  .toString())),
                                      loopMode: LoopMode.playlist,
                                      showNotification: true,
                                    );
                                  },
                                  leading: QueryArtworkWidget(
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assests/images/homemusics.png',
                                        height: 90,
                                        width: 50,
                                      ),
                                    ),
                                    keepOldArtwork: true,
                                    artworkBorder: BorderRadius.circular(10),
                                    id: searchlist[index].id!,
                                    type: ArtworkType.AUDIO,
                                  ),
                                  title: Text(searchlist[index].songname!,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                              )),
                        ),
                      )
                    : const Center(
                        child: Text('No such songs found'),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updatesearch(String value) {
    setState(() {
      searchlist = dbsongs
          .where((element) =>
              element.songname!.toLowerCase().contains(value.toLowerCase()))
          .toList();

      allsongs.clear();
      for (var item in searchlist) {
        allsongs.add(Audio.file(item.songurl.toString(),
            metas: Metas(title: item.songname, id: item.id.toString())));
      }
    });
  }
}

Widget searchTextField({required BuildContext context}) {
  return TextField(
    // autofocus: true,
    controller: searchcontroller,
    cursorColor: Color.fromARGB(255, 14, 13, 13),
    decoration: InputDecoration(
      filled: true,
      // ignore: prefer_const_constructors
      fillColor: Color.fromARGB(255, 235, 223, 223),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      hintText: "Search your favourite song here !!!",
      // ignore: prefer_const_constructors
      hintStyle: TextStyle(
        // ignore: prefer_const_constructors
        color: Color.fromARGB(255, 94, 70, 157),
      ),
      // ignore: prefer_const_constructors
      prefixIcon: Icon(
        Icons.search,
        // ignore: prefer_const_constructors
        color: Color.fromARGB(255, 94, 70, 157),
      ),
      suffixIcon: IconButton(
        icon: const Icon(
          Icons.clear,
          color: Color.fromARGB(255, 94, 70, 157),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // ignore: prefer_const_constructors
      prefixIconColor: Color.fromARGB(255, 94, 70, 157),
    ),
  );
}
