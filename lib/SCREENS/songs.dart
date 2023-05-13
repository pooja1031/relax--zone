import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/songfilemodel.dart';

class songs extends StatefulWidget {
  const songs({super.key});

  @override
  State<songs> createState() => _songsState();
}

final OnAudioQuery audioQuery = OnAudioQuery();
final AssetsAudioPlayer player = AssetsAudioPlayer();

class _songsState extends State<songs> {
  final box = SongBox.getInstance();
  List<Audio> Converted_songs = [];
  bool isadded = true;
  @override
  void initState() {
    List<Songs> song_database = box.values.toList();

    for (var i in song_database) {
      Converted_songs.add(
        Audio.file(
          i.songurl!,
          metas: Metas(
            title: i.songname,
            id: i.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
