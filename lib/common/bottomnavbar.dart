import 'package:flutter/material.dart';
import 'package:iftar/profile.dart';
import 'package:iftar/volunteer/show_post.dart';
import 'package:iftar/common/signup.dart';
import 'package:iftar/volunteer/listresto.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../classes/colors.dart';
import '../main.dart';
import '../resto/dashboard.dart';
import '../resto/dashboardnav.dart';
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
      return [NeedsScreen(), dashboardNAv(), PostScreen(), ProfileScreen()];
    }
  }

  /// 📌 Defines navbar items with custom colors
  List<PersistentBottomNavBarItem> _navBarItems() {
    if (widget.role == "volunteer") {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home, color: color.darkcolor),
          title: "Home",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.inbox, color: color.darkcolor),
          title: "Inbox",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person, color: color.darkcolor),
          title: "Profile",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home, color: color.darkcolor),
          title: "Home",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.dashboard, color: color.darkcolor),
          title: "Dashboard",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.inbox, color: color.darkcolor),
          title: "Inbox",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person, color: color.darkcolor),
          title: "Profile",
          activeColorPrimary: color.bgColor,
          inactiveColorPrimary: color.darkcolor,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0), // Space at bottom
      child: ClipRRect(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Slightly wider navbar
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarItems(),
            confineToSafeArea: true,
            backgroundColor: Colors.transparent, // Transparent so the gradient shows
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(50), // Match container radius
              colorBehindNavBar: Colors.transparent,
            ),
            navBarStyle: NavBarStyle.style3, // Custom navbar style
          ),
        ),
      ),
    );
  }
}
