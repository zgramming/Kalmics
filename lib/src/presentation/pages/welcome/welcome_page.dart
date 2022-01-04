import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../favorite/favorite_page.dart';
import '../home/home_page.dart';
import '../setting/setting_page.dart';
import '../statistic/statistic_page.dart';

class WelcomePage extends StatefulWidget {
  static const routeNamed = '/welcome-page';
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _bottomNavBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(FeatherIcons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(FeatherIcons.barChart2),
      label: 'Statistik',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Suka',
    ),
    BottomNavigationBarItem(
      icon: Icon(FeatherIcons.settings),
      label: 'Pengaturan',
    ),
  ];

  final _pages = const <Widget>[
    HomePage(),
    StatisticPage(),
    FavoritePage(),
    SettingPage(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            assetLogoPath,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.search),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: _bottomNavBarItems,
          backgroundColor: primary,
          unselectedItemColor: Colors.white.withOpacity(.5),
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
