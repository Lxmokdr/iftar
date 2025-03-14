import 'package:flutter/material.dart';
import 'package:iftar/classes/colors.dart';
import 'package:iftar/volunteer/utensils.dart';

class Utensilist extends StatefulWidget {
  final List<Map<String, dynamic>> utensils;
  Utensilist({required this.utensils});

  @override
  _UtensilistState createState() => _UtensilistState();
}

class _UtensilistState extends State<Utensilist> {
  late List<Map<String, dynamic>> utensils;

  @override
  void initState() {
    super.initState();
    utensils = widget.utensils;  // ✅ Assign the passed utensils list
  }

  /// 🔹 Function to determine background color based on availability
  Color getBackgroundColor(int needed, int available) {
    double ratio = available / needed;
    if (ratio >= 1) {
      return Colors.green.shade400; // Fully available
    } else if (ratio >= 0.5) {
      return Colors.yellow.shade400; // Moderately available
    } else {
      return Colors.red.shade400; // Critically low
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          /// 🔹 IMAGE HEADER
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
                'assets/img.png', // Replace with actual image
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),

          /// 🔹 GRID LIST DISPLAY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: utensils.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12, // Increased spacing
                  mainAxisSpacing: 12, // Increased spacing
                  childAspectRatio: 1.5, // ✅ Make boxes taller
                ),
                itemBuilder: (context, index) {
                  var utensil = utensils[index];
                  Color bgColor = getBackgroundColor(utensil["needed"], utensil["available"]);

                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16), // More rounded corners
                    ),
                    padding: EdgeInsets.all(16), // ✅ Increased padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          utensil["name"],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 6), // Added spacing
                        Text(
                          "Needed: ${utensil["needed"]}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          "Available: ${utensil["available"]}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),


          /// 🔹 HELP BUTTON
          _buildActionButton("Help", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => UtensilLoanScreen()));
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 🔹 FUNCTION TO BUILD ACTION BUTTON
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.darkcolor,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
