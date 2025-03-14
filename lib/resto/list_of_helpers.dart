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
              // Top App Bar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Iftar",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color.darkcolor,
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/img_1.png'), // Change to your image asset
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Comparison to last day
              Text(
                "COMPARISON TO LAST DAY",
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

              // Bar Chart
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

              // Unaccomplished deliveries & Unsatisfied Needs
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
                      "Unaccomplished deliveries: 2",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Unsatisfied needs: 3",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Stats Grid (Cards made bigger)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // **Increased for bigger cards**
                  children: [
                    _buildStatCard("TOTAL COMPLETED TRANSPORTATIONS", "4", Colors.pink),
                    _buildStatCard("TOTAL VOLUNTEERS", "20", Colors.orange),
                    _buildStatCard("TOTAL CLIENTS", "50", Colors.green),
                    _buildStatCard("TOTAL FOOD RECEIVED", "50 MEALS", Colors.purple),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Function to build a stat card (Made padding bigger)
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(20), // **Increased padding for better spacing**
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // **Increased spacing**
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class HelpersTableScreen extends StatelessWidget {
  final List<String> columns = ["Name", "Phone", "Help Type", "Status"];
  final List<Map<String, String>> data = [
    {"Name": "Issam Menas", "Phone": "123456", "Help Type": "Food", "Status": "Available"},
    {"Name": "John Doe", "Phone": "789012", "Help Type": "Transport", "Status": "Busy"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Helpers")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Allows horizontal scrolling
          child: DataTable(
            columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
            rows: data.map((row) {
              return DataRow(cells: [
                DataCell(Text(row["Name"]!)),
                DataCell(Text(row["Phone"]!)),
                DataCell(DropdownButton<String>(
                  value: row["Help Type"],
                  items: ["Food", "Transport", "Tools"].map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (value) {},
                )),
                DataCell(DropdownButton<String>(
                  value: row["Status"],
                  items: ["Available", "Busy"].map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (value) {},
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}


class ClientsTableScreen extends StatelessWidget {
  final List<String> columns = ["Name", "Phone"];
  final List<Map<String, String>> clients = [
    {"Name": "Alice Johnson", "Phone": "111222"},
    {"Name": "Bob Smith", "Phone": "333444"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clients")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: DataTable(
          columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
          rows: clients.map((row) {
            return DataRow(cells: [
              DataCell(Text(row["Name"]!)),
              DataCell(Text(row["Phone"]!)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
