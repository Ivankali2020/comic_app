import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/Modal/Comic.dart';
import 'package:comic/Provider/ComicProvider.dart';
import 'package:comic/Widgets/Loading.dart';
import 'package:comic/Widgets/SnackBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class ComicBook extends StatefulWidget {
  const ComicBook({super.key});

  @override
  State<ComicBook> createState() => _ComicBookState();
}

class _ComicBookState extends State<ComicBook> {
  @override
  Widget build(BuildContext context) {
    final Episodes episode =
        ModalRoute.of(context)!.settings.arguments as Episodes;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          episode.episodeTitle,
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                episode.readDone();
                print(episode.isRead);
                final response =
                    await Provider.of<ComicProvider>(context, listen: false)
                        .save(episode.id);

                if (response) {
                  snackBarWidget(context, 'Saved');
                }else{
                   snackBarWidget(context, 'Login Required!');
                }
              },
              icon: const Icon(Icons.bookmark_add_outlined))
        ],
      ),
      body: ListView.builder(
          itemCount: episode.photos.length,
          itemBuilder: (context, i) {
            return Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: episode.photos[i],
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) => const Center(
                    child: Loading('Getting ', double.infinity, 200, 10),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          }),
    );
  }
}
