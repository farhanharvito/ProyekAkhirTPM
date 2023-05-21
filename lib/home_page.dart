import 'package:flutter/material.dart';
import 'package:pexels/converter.dart';
import 'package:pexels/home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'search_photos.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    HomeScreen(),
    SearchScreen(),
    ConverterScreen(),
    ProfilePage(), // Add the ProfilePage widget as a tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? _buildHomePageAppBar()
          : _currentIndex == 1
              ? _buildAppBarWithTitle('Search')
              : _currentIndex == 2
                ? _buildAppBarWithTitle('Converter')
                : _buildAppBarWithTitle('Profile'),
      body: _tabs[_currentIndex],
      backgroundColor: Color(0xFF1A120B),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xFF1A120B),
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption:
                    TextStyle(fontSize: 10), // Adjust the font size as desired
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Color(0xff1A120B), // Set the background color of the bottom navigation bar
          selectedItemColor: Colors.white, // Set the color of the selected item
          unselectedItemColor:
              Colors.grey, // Set the color of the unselected items
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows, size: 30),
              label: 'Converter',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildHomePageAppBar() {
    return AppBar(
      backgroundColor: Color(0xff1A120B),
      title: Text('Simple Gallery'),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_sharp),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  AppBar _buildAppBarWithTitle(String title) {
    return AppBar(
      backgroundColor: Color(0xff1A120B),
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_sharp),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
