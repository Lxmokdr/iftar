import 'package:flutter/material.dart';

import 'bottomnavbar.dart';
import 'listresto.dart';

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
      body: IftarScreen(),
      bottomNavigationBar: CustomNavBarWidget(role: "patient"), // Pass role dynamically
    );
  }
}
