import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'FavoritePage.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0; 
  final List<Widget> _children = [
    HomePage(),
    SearchPage(),
    FavoritesPage(), 
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _children[_currentIndex], 
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex, 
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
