import 'package:flutter/material.dart';
import 'package:iftar/common/signup.dart';
import 'package:iftar/resto/needs.dart';

import 'common/bottomnavbar.dart';
import 'volunteer/listresto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeedsScreen(),
      bottomNavigationBar: CustomNavBarWidget(role: "restaurant"), // Pass role dynamically
    );
  }
}
