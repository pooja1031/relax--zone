import 'package:hive_flutter/hive_flutter.dart';

import '../../../db/recentlyplayedmodel.dart';

// late Box<RecentlyPlayedModel> recentplaybox;
// addRecentPlay(RecentlyPlayedModel value) {
//   List<RecentlyPlayedModel> recentList = recentplaybox.values.toList();
//   bool isAdded =
//       recentList.where((element) => element.songname == value.songname).isEmpty;
//   if (isAdded == true) {
//     recentplaybox.add(value);
//   } else {
//     int position =
//         recentList.indexWhere((element) => element.songname == value.songname);
//     recentplaybox.deleteAt(position);
//     recentplaybox.add(value);
//   }
// }
