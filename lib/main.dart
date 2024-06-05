import 'package:faiedapplauncher/portfolioapp.dart';
import 'package:faiedapplauncher/calculatorapp.dart';
import 'package:faiedapplauncher/quizapp.dart';
import 'package:faiedapplauncher/weatherapp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  @override
  _PortfolioAppState createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faied AppLauncher',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(
        isDarkMode: isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  HomePage({required this.isDarkMode, required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ProfilePage(onThemeChanged: (value) {}, isDarkMode: false),
    CalculatorPage(),
    QuizPage(),
    WeatherPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Dark'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 209, 128),
                    Color.fromARGB(255, 255, 209, 128)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Faied AppLauncher',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('PortfolioApp'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('CalculatorApp'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('QuizApp'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('WeatherApp'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            // Add more ListTiles for additional pages if needed
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
