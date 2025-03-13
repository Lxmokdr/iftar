import 'package:flutter/material.dart';
import 'colors.dart';
import 'help.dart'; // Ensure this file contains your color definitions

class Foodpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color.darkcolor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/img.png', // Replace with your actual image asset
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            _buildInputField('Food..'),
            _buildInputField('Quantity..'),
            _buildInputField('Arrival time..'),
            _buildInputField('Need Transportation? Y/N'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color.darkcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color.bgColor, // Adjust to match your UI
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.darkcolor),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
