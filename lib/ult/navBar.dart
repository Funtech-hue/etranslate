import 'package:flutter/material.dart';

import '../screen/dashboard_screen.dart';
import '../screen/favourite_screen.dart';
import '../screen/history_screen.dart';

class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  int _currentPage = 1;
  final _pages = [HistoryScreen(), Dashboard(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        elevation: 2,
        unselectedFontSize: 12,
        selectedFontSize: 14,
        backgroundColor: Colors.white,
        iconSize: 30,
        onTap:
            (value) => setState(() {
              _currentPage = value;
            }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
        ],
      ),
    );
  }
}
