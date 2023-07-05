// ignore_for_file: prefer_const_constructors, duplicate_ignore, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/SCREENS/library/playlist/playlistcurrent.dart';
import 'package:music_app/bloc/playlist_bloc/playlist_bloc.dart';
import '../../../db/playlist.dart';

import '../../../db/songfilemodel.dart';
import '../../../functions/addplaylist.dart';

class Playlist extends StatelessWidget {
  Playlist({super.key});

  final playlistbox = PlaylistSongsbox.getInstance();
  late List<PlaylistSongs> playlistsongs = playlistbox.values.toList();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            // ignore: prefer_const_constructors
            backgroundColor: Color.fromARGB(255, 131, 116, 167),
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 102),
              child: appbar(),
            ),
            floatingActionButton: FloatingActionButton(
              // ignore: prefer_const_constructors
              backgroundColor: Color.fromARGB(255, 73, 71, 71),

              child: const Icon(
                Icons.add,
                size: 30,
                color: Color.fromARGB(255, 236, 225, 225),
              ),
              onPressed: () {
                showPlaylistOptionsadd(context);
              },
            ),
            body: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: BlocBuilder<PlaylistBloc, PlaylistState>(
                        builder: (context, state) {
                      if (state is PlaylistInitial) {
                        context.read<PlaylistBloc>().add(GetPlayListSongs());
                      }
                      if (state is DisplayPlaylist) {
                        return GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                            state.Playlist.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: SizedBox(
                                height: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    CurrentPlaylist(
                                                      index: index,
                                                      playlistname: state
                                                          .Playlist[index]
                                                          .playlistname,
                                                    ))));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(48),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            child: Image.asset(
                                                'assests/images/homemusics.png',
                                                height: 124,
                                                width: 124,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            state.Playlist[index].playlistname!,
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<int>(
                                          itemBuilder: (context) => [
                                            // PopupMenuItem 1
                                            PopupMenuItem(
                                              onTap: () {
                                                // deleteplaylist(index);
                                                context
                                                    .read<PlaylistBloc>()
                                                    .add(DeletePlaylist(index));
                                              },
                                              value: 1,
                                              // row with 2 children
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.delete),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Delete")
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        // : const Center(
                        //     child: Text(
                        //       'Playlist is empty',
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   );
                      }
                      return const Center(
                        child: Text(
                          'Playlist is empty',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
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
              GoogleFonts.orbitron(fontSize: 26, fontWeight: FontWeight.bold)),
    ),
  );
}

//show dialogue
showOptions(BuildContext context, int index) {
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // ignore: prefer_const_constructors
          backgroundColor: Color.fromARGB(255, 131, 116, 167),
          alignment: Alignment.bottomCenter,
          // ignore: sized_box_for_whitespace
          content: Container(
            height: 50,
            width: vwidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        showPlaylistOptions(context, index);
                      },
                      icon: const Icon(
                        Icons.playlist_add_sharp,
                        color: Colors.white,
                      ),
                      // ignore: prefer_const_constructors
                      label: Text(
                        'Add to Playlist',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

showPlaylistOptions(BuildContext context, int songindex) {
  final box = PlaylistSongsbox.getInstance();
  final songbox = SongBox.getInstance();
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Color.fromARGB(255, 131, 116, 167),
          alignment: Alignment.bottomCenter,
          content: Container(
            //height: 200,
            width: vwidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<Box<PlaylistSongs>>(
                      valueListenable: box.listenable(),
                      builder:
                          (context, Box<PlaylistSongs> playlistsongs, child) {
                        List<PlaylistSongs> playlistsong =
                            playlistsongs.values.toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlistsong.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              onTap: () {
                                PlaylistSongs? playsongs =
                                    playlistsongs.getAt(index);
                                List<Songs> playsongdb =
                                    playsongs!.playlistssongs!;
                                List<Songs> songdb = songbox.values.toList();
                                bool isAlreadyAdded = playsongdb.any(
                                    (element) =>
                                        element.id == songdb[songindex].id);
                                if (!isAlreadyAdded) {
                                  playsongdb.add(
                                    Songs(
                                      songname: songdb[songindex].songname,
                                      artist: songdb[songindex].artist,
                                      duration: songdb[songindex].duration,
                                      songurl: songdb[songindex].songurl,
                                      id: songdb[songindex].id,
                                    ),
                                  );
                                }
                                playlistsongs.putAt(
                                    index,
                                    PlaylistSongs(
                                        playlistname:
                                            playlistsong[index].playlistname,
                                        playlistssongs: playsongdb));
                                // ignore: avoid_print
                                print(
                                    'song added to${playlistsong[index].playlistname}');
                                Navigator.pop(context);
                              },
                              title: Text(
                                playlistsong[index].playlistname!,
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

//add playlist naming
showPlaylistOptionsadd(BuildContext context) {
  final myController = TextEditingController();
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Color.fromARGB(255, 131, 116, 167),
      alignment: Alignment.bottomCenter,
      content: Container(
        height: 250,
        width: vwidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'New Playlist',
                    style: GoogleFonts.orbitron(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: vwidth * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: myController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Give Your Playlist a Name",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 94, 70, 157),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.33,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color.fromARGB(255, 8, 219, 117),
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.33,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color.fromARGB(255, 8, 219, 117),
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.done,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          newplaylist(myController.text);
                          Navigator.pop(context);
                        },
                        label: Text(
                          'Done',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
