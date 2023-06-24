import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/Modal/Comic.dart';
import 'package:comic/Provider/ComicProvider.dart';
import 'package:comic/Screen/ComicDetail.dart';
import 'package:comic/Widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryComic extends StatefulWidget {
  const CategoryComic({Key? key}) : super(key: key);

  @override
  _CategoryComicState createState() => _CategoryComicState();
}

class _CategoryComicState extends State<CategoryComic> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<ComicProvider>(context, listen: false)
            .loadMoreComicByCategory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text("Search By Category"),
      ),
      backgroundColor: MyTheme.backgroundColor,
      body: FetchComicFuture(context, id, _scrollController),
    );
  }
}

class MyTheme {
  static Color get backgroundColor => const Color(0xFFF7F7F7);
  static Color get grey => const Color(0xFF999999);
  static Color get catalogueCardColor =>
      const Color(0xFFBAE5D4).withOpacity(0.5);
  static Color get catalogueButtonColor => const Color(0xFF29335C);
  static Color get courseCardColor => const Color(0xFFEDF1F1);
  static Color get progressColor => const Color(0xFF36F1CD);

  static Padding get largeVerticalPadding =>
      const Padding(padding: EdgeInsets.only(top: 32.0));

  static Padding get mediumVerticalPadding =>
      const Padding(padding: EdgeInsets.only(top: 16.0));

  static Padding get smallVerticalPadding =>
      const Padding(padding: EdgeInsets.only(top: 8.0));

  static ThemeData get theme => ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        cardTheme: const CardTheme(
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                catalogueButtonColor), // Button color
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white), // Text and icon color
          ),
        ),
      );
}

FutureBuilder<void> FetchComicFuture(
    BuildContext context, int id, ScrollController _scrollController) {
  return FutureBuilder(
    future: Provider.of<ComicProvider>(context, listen: false)
        .fetchComics(isLoadMore: false, category_id: id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Loading('Fetching Data', double.infinity, 100, 18),
        );
      }
      if (snapshot.connectionState == ConnectionState.done) {
        final comics = Provider.of<ComicProvider>(context);
        return comics.comicsCategory.isEmpty
            ? const Center(
                child: Loading('No Comics Found', double.infinity, 100, 20),
              )
            : GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.65,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: comics.comicsCategory.length + 1,
                itemBuilder: (context, index) {
                  if (index == comics.comicsCategory.length) {
                    return comics.noMoreDataComicCategory
                        ? const Center(
                            child: Loading(
                                'No More Data!', double.infinity, 100, 15),
                          )
                        : const Center(
                            child: Loading(
                                'Fetching Data', double.infinity, 100, 15),
                          );
                  }
                  final comic = comics.comicsCategory[index];
                  return ComicItem(comic, context);
                },
              );
      }
      return const Center(
        child: Loading('Fetching Data', double.infinity, 100, 18),
      );
    },
  );
}

Container ComicItem(Comic comic, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: comic.cover,
            fit: BoxFit.contain,
            height: 150,
            width: 150,
            placeholder: (context, url) => const Center(
              child: Loading('Getting ', double.infinity, 200, 10),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
          child: Column(
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
                "${comic.categoryName}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.normal, fontSize: 13),
              ),
              Text(
                "${comic.authorName}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.normal, fontSize: 13),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiaryContainer),
                  focusColor: Theme.of(context).colorScheme.tertiaryContainer,
                  splashColor: Theme.of(context).colorScheme.secondaryContainer,
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ComicDetail(),
                          settings: RouteSettings(arguments: comic)),
                    )
                  },
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
      ],
    ),
  );
}
