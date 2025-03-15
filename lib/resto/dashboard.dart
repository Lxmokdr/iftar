import 'package:flutter/material.dart';
import '../classes/colors.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 25),
            _buildStatisticsGrid(),
            SizedBox(height: 25),
            _buildGraphWidget(),
            SizedBox(height: 25),
            _buildFoodStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Summary",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: color.darkcolor,
          ),
        ),
        SizedBox(width: 15),
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/img_1.png'),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: [
        _buildStatCard("TOTAL VOLUNTEERS", "25", color.bgColor),
        _buildStatCard("MONEY RECEIVED", "25 DZD", color.bgColor),
        _buildStatCard("TOTAL ORGANIZERS", "25", color.bgColor),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color cardColor) {
    return Container(
      width: 110,
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardFoodUte(String title, String value,String unit ,Color cardColor) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color.darkcolor),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGraphWidget() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: color.bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset("assets/img_2.png",)),
    );
  }

  Widget _buildFoodStatistics() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: [
        _buildStatCardFoodUte("FOOD", "50", "TOTAL MEALS", color.bgColor),
        _buildStatCardFoodUte("UTENSILS", "40", "",color.bgColor),
      ],
    );
  }
}
