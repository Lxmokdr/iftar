import 'package:flutter/material.dart';
import 'package:iftar/volunteer/utesilist.dart';

import '../classes/colors.dart';
import 'help.dart';

class UtensilLoanScreen extends StatefulWidget {
  @override
  _UtensilLoanScreenState createState() => _UtensilLoanScreenState();
}

class _UtensilLoanScreenState extends State<UtensilLoanScreen> {
  TextEditingController utensilController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController loanTermController = TextEditingController();
  TextEditingController transportationController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();

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
                'assets/img.png', // Replace with your actual image
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),

          /// 🔹 INPUT FIELDS
          _buildInputField("Utensil name..", utensilController),
          _buildInputField("Quantity..", quantityController),
          _buildInputField("Loan Term..", loanTermController),
          _buildInputField("Need Transportation? Y/N", transportationController),
          _buildInputField("Arrival time..", arrivalTimeController),

          /// 🔹 ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton("Done", () {print("Done");
              Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen()));
              }),
              SizedBox(width: 16),
              _buildActionButton("See List", () {
                print("See List");
                Navigator.push(context, MaterialPageRoute(builder: (_) => Utensilist()));

              }),
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
