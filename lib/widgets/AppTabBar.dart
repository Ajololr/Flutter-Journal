import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/models/locale.modal.dart';

import 'package:flutter_group_journal/widgets/GroupScreen.dart';
import 'package:flutter_group_journal/widgets/MapScreen.dart';
import 'package:flutter_group_journal/widgets/SettingsScreen.dart';

class AppTabBar extends StatefulWidget {
  AppTabBar({Key key}) : super(key: key);

  @override
  _AppTabBarState createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> myTabs = <BottomNavigationBarItem>[];

  static List<Widget> _widgetOptions = <Widget>[
    GroupScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    myTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.group), label: context.read<LocaleModel>().getString("group")),
      BottomNavigationBarItem(icon: Icon(Icons.map), label: context.read<LocaleModel>().getString("map")),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: context.read<LocaleModel>().getString("settings")),
    ];

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: myTabs,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ));
  }
}
