import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';

import 'main_drawer.dart';

class Starred extends StatefulWidget {
  @override
  _StarredState createState() => _StarredState();
}

class _StarredState extends State<Starred> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text(
          'Starred Docs',
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {},
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: WatchBoxBuilder(
        box: Hive.box('starred'),
        builder: (context, starredBox) {
          if (starredBox.getAt(0).length == 0) {
            return const Center(
              child: Text("No PDFs Starred Yet !! "),
            );
          }
          return ListView.builder(
            itemCount: starredBox.getAt(0).length as int,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('tapped');
                  OpenFile.open(starredBox.getAt(0)[index][0] as String);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: FileImage(
                                    starredBox.getAt(0)[index][2] as File),
                                width: MediaQuery.of(context).size.width / 4,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (starredBox.getAt(0)[index][0] as String)
                                    .split('/')
                                    .last,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: SizedBox(
                                  child:
                                      Text('${starredBox.getAt(0)[index][1]}')),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                ),
                                IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () async {
                                      final File file = File(await starredBox
                                          .getAt(0)[index][0] as String);

                                      final path = file.path;

                                      print(path);

                                      Share.shareFiles([path],
                                          text: 'Your PDF!');
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.star),
                                    onPressed: () async {
                                      setState(() {
                                        Hive.box('starred')
                                            .getAt(0)
                                            .removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Removed from starred documents'),
                                        ),
                                      );
                                    })
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
