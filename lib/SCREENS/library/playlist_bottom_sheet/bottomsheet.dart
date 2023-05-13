// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Future<void> showbottomsheet(BuildContext ctx) async {
  showModalBottomSheet(
      context: ctx,
      builder: (ctx1) {
        return Container(
          height: 300,
          color: Color.fromARGB(255, 94, 70, 157),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_left,
                          size: 40,
                          color: Color.fromARGB(255, 11, 11, 11),
                        )),
                    const Text(
                      'Play Previous',
                      style: TextStyle(
                          color: Color.fromARGB(255, 10, 10, 10), fontSize: 20),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_right,
                          size: 40,
                          color: Color.fromARGB(255, 11, 11, 11),
                        )),
                    const Text(
                      'Play Next',
                      style: TextStyle(
                          color: Color.fromARGB(255, 12, 12, 12), fontSize: 20),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.library_add,
                          color: Color.fromARGB(255, 11, 11, 11),
                        )),
                    const Text(
                      'Add to playlist',
                      style: TextStyle(
                          color: Color.fromARGB(255, 15, 15, 15), fontSize: 20),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 9, 9, 9),
                        )),
                    const Text(
                      'Add to Favourties',
                      style: TextStyle(
                          color: Color.fromARGB(255, 16, 16, 16), fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
