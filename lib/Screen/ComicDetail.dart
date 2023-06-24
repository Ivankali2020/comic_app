import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/Modal/Comic.dart';
import 'package:comic/Modal/Episode.dart';
import 'package:comic/Screen/ComicBook.dart';
import 'package:comic/Widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ComicDetail extends StatefulWidget {
  const ComicDetail({super.key});

  @override
  State<ComicDetail> createState() => _ComicDetailState();
}

class _ComicDetailState extends State<ComicDetail> {
  void _goComicBook(Episodes episode) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ComicBook(),
        settings: RouteSettings(arguments:episode)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Comic comic = ModalRoute.of(context)!.settings.arguments as Comic;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: comic.cover,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) => const Center(
                    child: Loading('Getting ', double.infinity, 200, 10),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Story Telling',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                comic.review,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Episodes'),
              const SizedBox(
                height: 20,
              ),
              ...comic.episodes
                  .map((e) => Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: e.isRead ? Theme.of(context).colorScheme.primary : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: e.photos[0],
                            fit: BoxFit.contain,
                            height: 80,
                            width: 40,
                            placeholder: (context, url) => const Center(
                              child:
                                  Loading('Getting ', double.infinity, 80, 10),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          title: Text(e.episodeTitle),
                          subtitle: Text(e.isRead.toString()),
                          trailing: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            overlayColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.tertiaryContainer,
                            ),
                            focusColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            splashColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            onTap: () => _goComicBook(e),
                            child: Container(
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(e.episode),
                            ),
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
