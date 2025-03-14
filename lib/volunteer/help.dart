import 'package:flutter/material.dart';
import 'package:iftar/volunteer/organazing.dart';
import 'package:iftar/volunteer/payerment.dart';
import 'package:iftar/volunteer/transportation.dart';
import 'package:iftar/volunteer/utensils.dart';
import 'package:iftar/volunteer/utesilist.dart';
import '../classes/colors.dart';
import 'foodpage.dart';

class IftarHelpScreen extends StatefulWidget {
  @override
  _IftarHelpScreenState createState() => _IftarHelpScreenState();
}

class _IftarHelpScreenState extends State<IftarHelpScreen> {
  // Track completion status of each category
  Map<String, bool> helpStatus = {
    'Food': false,
    'Money': false,
    'Transportation': true,
    'Utensils': false,
    'Organizing': false,
  };

  void markHelped(String category) {
    setState(() {
      helpStatus[category] = true;
    });
  }

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
                      'assets/img.png',
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
                        _helpButton('Food', Foodpage(), helpStatus['Food']!),
                        _helpButton('Money', PaymentScreen(), helpStatus['Money']!),
                        _helpButton('Transportation', TransportSelectionScreen(), helpStatus['Transportation']!),
                        _helpButton(
                          'Utensils',
                          Utensilist(utensils: [
                            {"name": "Assiette", "needed": 20, "available": 15},
                            {"name": "Fourchette", "needed": 20, "available": 10},
                            {"name": "Marmite", "needed": 2, "available": 1},
                            {"name": "Bol", "needed": 10, "available": 5},
                            {"name": "Cuillère", "needed": 5, "available": 2},
                          ]),
                          helpStatus['Utensils']!,
                        ),
                        _helpButton('Organizing', Organization(), helpStatus['Organizing']!),
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
  Widget _helpButton(String title, Widget page, bool isHelped) {
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
          trailing: isHelped
              ? Icon(Icons.check_circle, color: Colors.green, size: 50)
              : ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              ).then((_) => markHelped(title));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color.darkcolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              'Help',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}