import 'package:flutter/material.dart';

import '../classes/colors.dart';


Widget buildInputField(String hint, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.darkcolor, // Set border color
            width: 1.5, // Set border width
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey, // Border color when not focused
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.goldGradient.colors.first, // Border color when focused
            width: 2,
          ),
        ),
      ),
    ),
  );
}


/// 🔹 FUNCTION TO BUILD ACTION BUTTON
Widget buildActionButton(String text, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      gradient: color.goldGradient,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Transparent for gradient
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}