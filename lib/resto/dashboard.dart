import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../classes/colors.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalVolunteers = 0;
  double moneyReceived = 0.0;
  int totalOrganizers = 0;
  int totalFood = 0;
  int totalUtensils = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final userId = currentUser.uid;

      // Get all requests
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .doc(userId)
          .collection('requests')
          .get();

      int volunteersCount = requestSnapshot.docs.length;
      int foodQuantity = 0;
      int utensilQuantity = 0;

      for (var doc in requestSnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        String type = requestData['type'] ?? '';
        int quantity = (requestData['quantity'] ?? 0).toInt();

        if (type.toLowerCase() == 'food') {
          foodQuantity += quantity;
        } else if (type.toLowerCase() == 'utensil') {
          utensilQuantity += quantity;
        }
      }

      // Get money received & total organizers from users collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        double money = (userData['money'] ?? 0).toDouble();
        int organizers = (userData['volunteers'] ?? 0);

        setState(() {
          totalVolunteers = volunteersCount;
          moneyReceived = money;
          totalOrganizers = organizers;
          totalFood = foodQuantity;
          totalUtensils = utensilQuantity;
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error fetching statistics: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
        _buildStatCard("TOTAL VOLUNTEERS", "$totalVolunteers", color.bgColor),
        _buildStatCard("MONEY RECEIVED", "$moneyReceived DZD", color.bgColor),
        _buildStatCard("TOTAL ORGANIZERS", "$totalOrganizers", color.bgColor),
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
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardFoodUte(String title, String value, String unit, Color cardColor) {
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
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
        child: Image.asset("assets/img_2.png"),
      ),
    );
  }

  Widget _buildFoodStatistics() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: [
        _buildStatCardFoodUte("FOOD", "$totalFood", "TOTAL MEALS", color.bgColor),
        _buildStatCardFoodUte("UTENSILS", "$totalUtensils", "", color.bgColor),
      ],
    );
  }
}