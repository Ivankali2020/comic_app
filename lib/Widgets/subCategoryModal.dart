import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/Provider/ComicProvider.dart';
import 'package:comic/Screen/CategoryComic.dart';
import 'package:comic/Screen/Search.dart';
import 'package:comic/Widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<dynamic> subCategoryModalBottomSheet(
    BuildContext context, String categoryName, List brands) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        height: 400,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                categoryName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            brands.isEmpty
                ? const Center(child: Text('No Brands Found'))
                : Expanded(
                    child: GridView.builder(
                      itemCount: brands.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 60,
                              mainAxisSpacing: 8),
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            // Provider.of<ComicProvider>(context, listen: false)
                            //     .addBrandId(brands[i].id);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryComic(),
                                settings: RouteSettings(arguments: brands[i].id)
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            width: 70,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(brands[i].name),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      );
    },
  );
}
