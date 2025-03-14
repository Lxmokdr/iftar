import 'package:flutter/material.dart';
import 'package:iftar/volunteer/organazing.dart';
import 'package:iftar/volunteer/payerment.dart';
import 'package:iftar/volunteer/transportation.dart';
import 'package:iftar/volunteer/utensils.dart';
import '../classes/colors.dart';
import 'foodpage.dart'; // Ensure you have a colors.dart file for custom colors

class IftarHelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color.darkcolor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          /// 🔹 Background Decor
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.bgColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SizedBox(height: 80, width: double.infinity),
          ),

          /// 🔹 Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

                  /// 🔹 IMAGE SECTION
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/img.png', // Replace with actual path
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 30),

                  /// 🔹 LOCATION & TIME
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ain taya',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color.darkcolor,
                            ),
                          ),
                          TextSpan(
                            text: '  15 min',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  /// 🔹 HELP BUTTONS SECTION
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: color.darkcolor, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _helpButton('Food', () {
                          print('Food help requested!');
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Foodpage()));
                        }),
                        _helpButton('Money', () {
                          print('Money help requested!');
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                        }),
                        _helpButton('Transportation', () {
                          print('Transportation help requested!');
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TransportSelectionScreen()));
                        }),
                        _helpButton('Utensils', () {
                          print('Utensils help requested!');
                          Navigator.push(context, MaterialPageRoute(builder: (_) => UtensilLoanScreen()));
                        }),
                        _helpButton('Organizing', () {
                          print('Organizing help requested!');
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Organization()));
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 CUSTOM HELP BUTTON WIDGET
  Widget _helpButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: color.bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: ElevatedButton(
            onPressed: onPressed, // ✅ Action when clicked
            style: ElevatedButton.styleFrom(
              backgroundColor: color.darkcolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              'Help',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

}