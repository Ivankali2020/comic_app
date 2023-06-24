import 'package:comic/Screen/Home.dart';
import 'package:comic/Screen/Search.dart';
import 'package:comic/Screen/User.dart';
import 'package:flutter/material.dart';

class NavProvider with ChangeNotifier {
  final List<Map<String, dynamic>> pages = [
    {
      'name': 'Home',
      'page': const Home(),
      'icon': Icons.home_outlined,
      'active_icon': Icons.home_filled
    },
    {
      'name': 'Search',
      'page': SearchScreen(),
      'icon': Icons.search_outlined,
      'active_icon': Icons.search_sharp
    },
    {
      'name': 'User',
      'page': User(),
      'icon': Icons.person_outline,
      'active_icon': Icons.person_sharp
    },
  ];

  late int activeIndex = 0;

  void changeIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }
}