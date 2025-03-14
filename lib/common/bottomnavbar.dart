import 'package:flutter/material.dart';
import 'package:iftar/profile.dart';
import 'package:iftar/volunteer/show_post.dart';
import 'package:iftar/common/signup.dart';
import 'package:iftar/volunteer/listresto.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../classes/colors.dart';
import '../main.dart';
import '../resto/list_of_helpers.dart';
import '../resto/needs.dart';
import '../resto/post_screen_mat3am.dart';
import '../volunteer/profile_screen.dart';

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
    if (widget.role == "volunteer") {
      return [IftarScreen(), ShowScreen(), ProfileScreen()];
    } else {
      return [NeedsScreen(), DASH(), PostScreen(), ProfileScreen()];
    }
  }

  /// 📌 Defines navbar items with custom colors
  List<PersistentBottomNavBarItem> _navBarItems() {
    if (widget.role == "volunteer") {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          title: "Home",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.inbox, color: Colors.white),
          title: "Inbox",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          title: "Profile",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          title: "Home",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.dashboard, color: Colors.white),
          title: "Dashboard",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.inbox, color: Colors.white),
          title: "Inbox",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          title: "Profile",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: Colors.white,
        ),
      ];
    }
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
