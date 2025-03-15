import 'package:flutter/material.dart';
import 'package:iftar/resto/needs.dart';
import 'package:iftar/volunteer/utesilist.dart';

import '../classes/colors.dart';

class AddNeed extends StatefulWidget {
  @override
  _AddNeedState createState() => _AddNeedState();
}

class _AddNeedState extends State<AddNeed> {
  TextEditingController utensilController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// 🔹 Full Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: color.goldGradient,
            ),
          ),

          /// 🔹 Top Title
          Padding(
              padding: EdgeInsets.only(top: 75),
              child: Column(
                children: [
                  Text(
                    "WHAT DO U WANNA HELP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "WITH?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
          ),

          Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// 🔹 INPUT FIELDS
                        _buildInputField("Utensil name..", utensilController),
                        _buildInputField("Quantity..", quantityController),


                        /// 🔹 ACTION BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton("Done", () {print("Done");
                            Navigator.push(context, MaterialPageRoute(builder: (_) => NeedsScreen()));
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 150,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 FUNCTION TO BUILD INPUT FIELD
  Widget _buildInputField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Color(0xFFF3E2C7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// 🔹 FUNCTION TO BUILD ACTION BUTTON
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: color.goldGradient,
        borderRadius: BorderRadius.circular(12), // Matches button shape
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NeedsScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          shadowColor: Colors.transparent, // Removes unwanted shadow
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
    );
  }
}

