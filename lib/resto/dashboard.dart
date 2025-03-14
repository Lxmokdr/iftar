import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iftar/classes/colors.dart';

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
