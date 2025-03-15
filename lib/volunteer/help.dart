import 'package:flutter/material.dart';
import 'package:iftar/volunteer/organazing.dart';
import 'package:iftar/volunteer/payerment.dart';
import 'package:iftar/volunteer/transportation.dart';
import 'package:iftar/volunteer/utensils.dart';
import '../classes/colors.dart';
import 'foodpage.dart';

class IftarHelpScreen extends StatefulWidget {
  @override
  _IftarHelpScreenState createState() => _IftarHelpScreenState();
}

class _IftarHelpScreenState extends State<IftarHelpScreen> {

  bool isOrganizingConfirmed = false;


  void toggleOrganizing() {
    if (!isOrganizingConfirmed) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Help with Organizing?"),
          content: Text("Do you want to confirm your help with organizing?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No", style: TextStyle(color: color.darkcolor),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isOrganizingConfirmed = true;
                });
                Navigator.pop(context);
              },
              child: Text("Yes", style: TextStyle(color: color.darkcolor)),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Cancel Organizing?"),
          content: Text("Are you sure you want to cancel?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No", style: TextStyle(color: color.darkcolor)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isOrganizingConfirmed = false;
                });
                Navigator.pop(context);
              },
              child: Text("Yes", style: TextStyle(color: color.darkcolor)),
            ),
          ],
        ),
      );
    }
  }

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
            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Ain taya  15 min',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color.darkcolor,
                        ),
                      ),
                      SizedBox(height: 30),

                      /// 🔹 Help Buttons
                      _helpButton('Food', Foodpage()),
                      _helpButton('Money', PaymentScreen()),
                      _helpButton('Transportation', null, isPopup: true),
                      _helpButton('Utensils', UtensilLoanScreen()),
                      _organizingButton(),
                    ],
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

  /// 🔹 Custom Help Button Widget
  Widget _helpButton(String title, Widget? page, {bool isPopup = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          trailing: ElevatedButton(
            onPressed: () {
              if (isPopup) {
                showTransportSelectionPopup(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page!),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            child: Text(
              'Donate',
              style: TextStyle(
                color: color.darkcolor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Organizing Button
  Widget _organizingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: ListTile(
          title: Text(
            'Organizing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          trailing: ElevatedButton(
            onPressed: toggleOrganizing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            child: Text(
              isOrganizingConfirmed ? '✔' : 'Confirm',
              style: TextStyle(
                color: color.darkcolor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
