import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'helper/default_scroll_behavior.dart';
import 'screen/history_screen.dart';
import 'screen/details_screen.dart';
import 'provider/dogs.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Dogs(),
      child: Consumer<Dogs>(
        builder: (context, value, child) => MaterialApp(
          themeMode: value.darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          debugShowCheckedModeBanner: false,
          scrollBehavior: DefaultScrollBehaviour(),
          title: 'Nymble Task',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              actions: [
                const Icon(Icons.search),
                IconButton(
                  onPressed: () => Provider.of<Dogs>(context, listen: false)
                      .toggleDarkMode(),
                  icon: Consumer<Dogs>(
                    builder: (context, value, child) => value.darkMode
                        ? const Icon(Icons.sunny)
                        : const Icon(Icons.dark_mode),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_edu),
                  label: 'History',
                ),
              ],
              currentIndex: _activeIndex,
              onTap: (value) {
                setState(() {
                  _activeIndex = value;
                });
              },
            ),
            body: SafeArea(
              child: IndexedStack(
                index: _activeIndex,
                children: const [
                  HomeScreen(),
                  HistoryScreen(),
                ],
              ),
            ),
          ),
          routes: {
            DetailsScreen.routeName: (context) => const DetailsScreen(),
          },
        ),
      ),
    );
  }
}
