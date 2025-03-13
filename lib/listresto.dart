import 'package:flutter/material.dart';

import 'bottomnavbar.dart';
import 'colors.dart';
import 'help.dart';

class IftarScreen extends StatefulWidget {
  @override
  State<IftarScreen> createState() => _IftarScreenState();
}

class _IftarScreenState extends State<IftarScreen> {
  int _selectedIndex = 0; // Track selected navbar item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Iftar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color.darkcolor),),
                IconButton(
                  icon: Icon(Icons.language, color: color.darkcolor),
                  onPressed: () {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'full name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: color.darkcolor),
                    Text('Savar, Dhaka', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for restaurants',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: color.darkcolor),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Available Restaurants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return RestaurantCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/food.png', width: 80, height: 80, fit: BoxFit.cover),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ain Taya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('15 min', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color.darkcolor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IftarHelpScreen()),
                      );
                    },
                    child: Text('Help', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.location_pin, color: color.darkcolor, size: 35,),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: color.darkcolor),
                  onPressed: () {},
                  child: Text('Book Iftar', style: TextStyle(color: Colors.white)),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
