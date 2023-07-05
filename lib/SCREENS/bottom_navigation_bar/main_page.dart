import 'package:flutter/material.dart';

import 'package:music_app/SCREENS/search/search_screen.dart';
import 'package:music_app/SCREENS/settings/user_screen.dart';

import '../home/home_page.dart';
import '../library/library_main/library.dart';
import '../mini_player/miniplayer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    const HomePage(),
    const SearchScreen(),
    const LibraryScreen(),
    const UserScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ignore: prefer_const_constructors
          MiniPlayer(),
          BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => setState(
              () => currentIndex = index,
            ),
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: const Color.fromARGB(255, 172, 143, 244),
            selectedItemColor: Colors.white,
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.library_add),
                label: 'Library',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
