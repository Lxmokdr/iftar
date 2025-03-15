import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../classes/colors.dart';

class DASH extends StatefulWidget {
  @override
  _DASHState createState() => _DASHState();
}

class _DASHState extends State<DASH> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    IftarDashboard(),
    HelpersTableScreen(),
    ClientsTableScreen(),
  ];

  void _navigate(bool isNext) {
    setState(() {
      if (isNext) {
        _selectedIndex = (_selectedIndex + 1) % _screens.length;
      } else {
        _selectedIndex = (_selectedIndex - 1 + _screens.length) % _screens.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 30),
              onPressed: () => _navigate(false),
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 30),
              onPressed: () => _navigate(true),
            ),
          ),
        ],
      ),
    );
  }
}

class IftarDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "إفطار",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color.darkcolor,
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/img_1.png'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "مقارنة مع اليوم السابق",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Row(
                children: [
                  Text(
                    "\$9 905,00",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "\$440 ↑",
                    style: TextStyle(fontSize: 20, color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 150,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: Colors.red)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 9, color: Colors.purple)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: Colors.yellow)]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 8, color: Colors.blue)]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "التوصيلات غير المكتملة: 2",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "الاحتياجات غير الملباة: 3",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpersTableScreen extends StatelessWidget {
  final List<String> columns = ["الاسم", "رقم الهاتف", "نوع المساعدة", "الحالة"];
  final List<Map<String, String>> data = [
    {"الاسم": "عصام مناس", "رقم الهاتف": "123456", "نوع المساعدة": "طعام", "الحالة": "متاح"},
    {"الاسم": "جون دو", "رقم الهاتف": "789012", "نوع المساعدة": "نقل", "الحالة": "مشغول"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المساعدون")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: DataTable(
          columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
          rows: data.map((row) {
            return DataRow(cells: [
              DataCell(Text(row["الاسم"]!)),
              DataCell(Text(row["رقم الهاتف"]!)),
              DataCell(Text(row["نوع المساعدة"]!)),
              DataCell(Text(row["الحالة"]!)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class ClientsTableScreen extends StatelessWidget {
  final List<String> columns = ["الاسم", "رقم الهاتف"];
  final List<Map<String, String>> clients = [
    {"الاسم": "أليس جونسون", "رقم الهاتف": "111222"},
    {"الاسم": "بوب سميث", "رقم الهاتف": "333444"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("العملاء")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: DataTable(
          columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
          rows: clients.map((row) {
            return DataRow(cells: [
              DataCell(Text(row["الاسم"]!)),
              DataCell(Text(row["رقم الهاتف"]!)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}