import 'package:flutter/material.dart';
import '../classes/colors.dart';
import 'help.dart';

class Organization extends StatefulWidget {
  @override
  _OrganizationState createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  bool beforeIftar = false;
  bool afterIftar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/img.png',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Choose your option',
                        style: TextStyle(color: color.darkcolor),
                      ),
                    ),
                    SizedBox(height: 12),
                    CheckboxListTile(
                      title: Text('Before iftar'),
                      value: beforeIftar,
                      activeColor: color.darkcolor,
                      onChanged: (bool? value) {
                        setState(() {
                          beforeIftar = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('After iftar'),
                      value: afterIftar,
                      activeColor: color.darkcolor,
                      onChanged: (bool? value) {
                        setState(() {
                          afterIftar = value ?? false;
                        });
                      },
                    ),
                    Spacer(), // Pushes the button to the bottom
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.darkcolor,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen()));

                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
