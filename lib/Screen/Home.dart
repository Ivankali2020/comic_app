import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/Modal/Comic.dart';
import 'package:comic/Provider/ComicProvider.dart';
import 'package:comic/Screen/ComicDetail.dart';
import 'package:comic/Widgets/Loading.dart';
import 'package:comic/Widgets/subCategoryModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    Provider.of<ComicProvider>(context, listen: false).fetchCategories();
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  void loadMore() {
    print('hello');
    Provider.of<ComicProvider>(context, listen: false)
        .fetchComics( isLoadMore: true);
  }

  void detailPage(Comic comic) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ComicDetail(),
          settings: RouteSettings(arguments: comic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MM COMIC',
          style: GoogleFonts.bebasNeue(fontSize: 25, letterSpacing: 3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Card(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            child: Container(
                              width: double.infinity,
                            ),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 16.0, 0, 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Search \nby categories",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () =>
                                              subCategoryModalBottomSheet(
                                                  context,
                                                  'Category',
                                                  Provider.of<ComicProvider>(
                                                          context,
                                                          listen: false)
                                                      .categories),
                                          child: const Text(
                                            "Catalog",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://cdn3d.iconscout.com/3d/premium/thumb/layers-7042469-5740206.png',
                            height: 100,
                            width: 100,
                            placeholder: (context, url) => const Center(
                              child:
                                  Loading('Getting ', double.infinity, 80, 10),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Latest comics',
              style:
                  GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: RefreshIndicator(
              onRefresh: () => Provider.of<ComicProvider>(context, listen: false).fetchComics(),
                child: FetchComicFuture(context)),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> FetchComicFuture(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<ComicProvider>(context, listen: false).fetchComics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Loading('Fetching Data', double.infinity, 100, 18),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final comics = Provider.of<ComicProvider>(context).comics;

          return comics.isEmpty
              ? const Center(
                  child: Loading('No Comics Found', double.infinity, 100, 20),
                )
              : ComicListBuilder(comics);
        }
        return const Center(
          child: Loading('Fetching Data', double.infinity, 100, 18),
        );
      },
    );
  }

  ListView ComicListBuilder(List<Comic> comics) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: comics.length + 1,
      controller: _controller,
      itemBuilder: (context, i) {
        if (i == comics.length) {
          return const Center(
            child: Loading('Fetching Data', double.infinity, 100, 15),
          );
        }
        final comic = comics[i];
        return ComicItem(comic, context);
      },
    );
  }

  Container ComicItem(Comic comic, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: comic.cover,
              fit: BoxFit.contain,
              height: 150,
              width: 140,
              placeholder: (context, url) => const Center(
                child: Loading('Getting ', double.infinity, 200, 10),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      comic.name,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: GoogleFonts.bebasNeue(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Category : ${comic.categoryName}",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  Text(
                    "Author : ${comic.authorName}",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiaryContainer),
                      focusColor: Theme.of(context).colorScheme.tertiaryContainer,
                      splashColor: Theme.of(context).colorScheme.secondaryContainer,
                      onTap: () => detailPage(comic),
                      child: Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('Detail'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
