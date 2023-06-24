import 'dart:convert';

import 'package:comic/Modal/Category.dart' as Modal;
import 'package:comic/Modal/Comic.dart';
import 'package:comic/Provider/Http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComicProvider with ChangeNotifier {
  String? token;

  ComicProvider(this.token);
  List<Comic> _comics = [];

  List<Comic> get comics {
    return [..._comics];
  }

  List<Comic> _comicsCategory = [];

  List<Comic> get comicsCategory {
    return [..._comicsCategory];
  }

  List<Modal.Category> _categories = [];

  List<Modal.Category> get categories {
    return [..._categories];
  }

  int page = 1;
  int CategoryComicPage = 2;
  bool noMoreData = false;
  bool noMoreDataComicCategory = false;

  final coreUrl = 'https://comic.nathanmyanmar.com/public/api';

  int? categoryId;

  Future<void> fetchComics({bool isLoadMore = false, int? category_id}) async {
    if (isLoadMore && category_id == null) {
      page = 2;
    } else {
      page = 1;
      if (category_id == null) {
        _comics = [];
      } else {
        categoryId = category_id;
        CategoryComicPage = 1;
        _comicsCategory = [];
      }
    }
    final url = Uri.parse(
        coreUrl + '/comics?category_id=${categoryId ?? ' '}&page=$page');

    final customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      customHeaders['Authorization'] = 'Bearer $token';
    }

    print(customHeaders);

    try {
      final res = await http.get(
        url,
        headers: customHeaders,
      );

      final json = jsonDecode(res.body);
      if (res.statusCode == 200 && json['status']) {
        final data = json['data'] as List;

        if (category_id != null) {
          data.map((e) => _comicsCategory.add(Comic.fromJson(e))).toList();
          notifyListeners();
          return;
        } else {
          if (data.isEmpty) {
            noMoreData = true;
          } else {
            page++;
            data.map((e) => _comics.add(Comic.fromJson(e))).toList();
          }
        }
      }
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> loadMoreComicByCategory() async {
    noMoreDataComicCategory = false;
    final data = await Http.getDate(
        '/comics?category_id=${categoryId ?? ' '}&page=$CategoryComicPage',
        bearerToken: token);

    if (data['status']) {
      final json = data['data'] as List;
      if (json.isEmpty) {
        noMoreDataComicCategory = true;
      }
      CategoryComicPage++;
      json.map((e) => _comicsCategory.add(Comic.fromJson(e))).toList();
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    final data = await Http.getDate('/categories', bearerToken: token);

    if (data['status']) {
      final json = data['data'] as List;
      json.map((e) => _categories.add(Modal.Category.fromJson(e))).toList();
      notifyListeners();
    }
  }

  Future<void> save(int id) async {
    final url = Uri.parse(coreUrl + '/save/$id');

    final customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      customHeaders['Authorization'] = 'Bearer $token';
    }

    try {
      final res = await http.get(
        url,
        headers: customHeaders,
      );
      print(token);

      final json = jsonDecode(res.body);
      print(json);
      if (res.statusCode == 200 && json['status']) {}
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  bool isLoadingProducts = false;
  List<Comic> _searchComics = [];

  List<Comic> get searchComics {
    return [..._searchComics];
  }

  int searchPage = 1;
  Future<void> fetchSearchComics(
    String keyword, {
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      searchPage = 1;
      _searchComics = [];
    }

    isLoadingProducts = true;
    final data = await Http.getDate('/comics?keyword=$keyword&page=$searchPage',
        bearerToken: token);
    if (data['status']) {
      final json = data['data'] as List;
      print('/comics?keyword=$keyword&page=$searchPage');
      if (json.isEmpty) {
        noMoreDataComicCategory = true;
      } else {
        searchPage++;
      }
      json.map((e) => _searchComics.add(Comic.fromJson(e))).toList();
      isLoadingProducts = false;
      notifyListeners();
    }
  }
}
