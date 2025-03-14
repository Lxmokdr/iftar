import 'package:flutter/material.dart';
import '../classes/colors.dart';
import 'help.dart';

class IftarScreen extends StatefulWidget {
  @override
  State<IftarScreen> createState() => _IftarScreenState();
}

class _IftarScreenState extends State<IftarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Iftar',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: color.darkcolor),
                ),
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
                  'Full Name',
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

class RestaurantCard extends StatefulWidget {
  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  double progressLevel = 0.6; // Example level, can be changed dynamically

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
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: progressLevel, // This controls the level
                    strokeWidth: 5,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan), // Change color as needed
                  ),
                ),
                Text(
                  '${(progressLevel * 100).toInt()}%', // Show percentage inside
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Icon(Icons.location_pin, color: color.darkcolor, size: 35),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: color.darkcolor),
                  onPressed: () {
                    _showBookingConfirmation(context);
                  },
                  child: Text('Book Iftar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Booking"),
          content: Text("Are you sure you want to book this Iftar?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: color.darkcolor),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: color.darkcolor),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
