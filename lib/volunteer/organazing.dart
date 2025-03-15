import 'package:flutter/material.dart';
import '../classes/colors.dart';

class Organization extends StatefulWidget {
  @override
  _OrganizationState createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  bool beforeIftar = false;
  bool afterIftar = false;
  bool isVolunteeringConfirmed = false;

  /// Show Bottom Sheet for Confirmation / Cancellation
  void _showConfirmationPopup() {
    bool isCancel = isVolunteeringConfirmed;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCancel ? "Cancel Volunteering?" : "Confirm Volunteering?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                isCancel
                    ? "Do you want to cancel your volunteering?"
                    : "Are you sure you want to volunteer?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVolunteeringConfirmed = !isCancel;
                        if (isCancel) {
                          beforeIftar = false;
                          afterIftar = false;
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.darkcolor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Yes"),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

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
                        color: color.lightbg,
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
                    Spacer(),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: color.goldGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _showConfirmationPopup,
                          child: Text(
                            isVolunteeringConfirmed ? 'Cancel' : 'Done',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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
