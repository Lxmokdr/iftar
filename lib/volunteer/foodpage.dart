import 'package:flutter/material.dart';
import '../classes/colors.dart';
import '../common/button.dart';
import 'help.dart'; // Ensure this file contains your color definitions

class Foodpage extends StatefulWidget {
  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  TextEditingController foodController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController needController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                        SizedBox(height: 16),
                        buildInputField('Food..',foodController),
                        buildInputField('Quantity..', quantityController),
                        buildInputField('Arrival time..',timeController),
                        buildInputField('Need Transportation? Y/N',needController),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: color.goldGradient,
                            borderRadius: BorderRadius.circular(12), // Matches button shape
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen()));
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
                        ),
                        Spacer(),

                        /// 🔹 FOOTER TEXT
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('If you need transportation call the center'),
                            Text('0557334515'),
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
}
