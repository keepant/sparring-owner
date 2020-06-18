import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring_owner/pages/home/home.dart';
import 'package:sparring_owner/pages/more/more.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      Home(),
      More(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu),
        title: "More",
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      showElevation: true,
      navBarCurve: NavBarCurve.upperCorners,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: false,
      itemCount: 2,
      navBarStyle: NavBarStyle.style7,
    );
  }
}
