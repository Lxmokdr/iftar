import 'package:flutter/material.dart';
import 'package:iftar/profile.dart';
import 'package:iftar/signup.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'colors.dart';
import 'listresto.dart';

class CustomNavBarWidget extends StatefulWidget {
  final String role;

  const CustomNavBarWidget({Key? key, required this.role}) : super(key: key);

  @override
  _CustomNavBarWidgetState createState() => _CustomNavBarWidgetState();
}

class _CustomNavBarWidgetState extends State<CustomNavBarWidget> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  /// 📌 Defines screens based on role
  List<Widget> _buildScreens() {
    return [IftarScreen(), AuthScreen(), profile()];
  }

  /// 📌 Defines navbar items with custom colors
  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home, color: Colors.white),
        title: "Home",
        activeColorPrimary: color.darkcolor,
        inactiveColorPrimary: Colors.white,
        inactiveColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.inbox, color: Colors.white),
        title: "Inbox",
        activeColorPrimary: color.darkcolor,
        inactiveColorPrimary: Colors.white,
        inactiveColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person, color: Colors.white),
        title: "Profile",
        activeColorPrimary: color.darkcolor,
        inactiveColorPrimary: Colors.white,
        inactiveColorSecondary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // Space at bottom
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Rounded edges
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Slightly wider navbar
          decoration: BoxDecoration(
            color: color.darkcolor, // Custom background color
            borderRadius: BorderRadius.circular(30),
          ),
          child: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarItems(),
            confineToSafeArea: true,
            backgroundColor: color.darkcolor, // Custom background color
            navBarStyle: NavBarStyle.style3, // Custom navbar style
          ),
        ),
      ),
    );
  }
}
