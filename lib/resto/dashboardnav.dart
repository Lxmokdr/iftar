import 'package:flutter/material.dart';
import 'package:iftar/resto/transports.dart';

import 'Historique.dart';
import 'dashboard.dart';
import 'helpers.dart';


class dashboardNAv extends StatefulWidget {
  @override
  _dashboardNAvState createState() => _dashboardNAvState();
}

class _dashboardNAvState extends State<dashboardNAv> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              StatisticsTodayScreen(),
              HistoriqueScreen(),
              TransportWeekScreen(),
              DashboardScreen(),

            ],
          ),

          // Left Arrow
          Positioned(
            left: 10,
            child: _currentPage > 0
                ? IconButton(
              icon: Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: _prevPage,
            )
                : SizedBox(),
          ),

          // Right Arrow
          Positioned(
            right: 10,
            child: _currentPage < 2
                ? IconButton(
              icon: Icon(Icons.arrow_forward, size: 30, color: Colors.black),
              onPressed: _nextPage,
            )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
