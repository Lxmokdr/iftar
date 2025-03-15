import 'package:flutter/material.dart';

class color {
  static const Color bgColor =  Color(0xFFFFEFDB);
  static const Color lightbg = Color(0xFFFAF9F6);
  static const Color darkcolor = Color(0xFFDAA520);
  static const Gradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFFFE234), // Bright Gold (highlight)
      Color(0xFFFFD700), // True Gold
      Color(0xFFFFC107), // Rich Metallic Gold
      Color(0xFFDAA520), // Deeper Gold (without turning bronze)
      Color(0xFFC9A227), // Dark Gold for depth
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.25, 0.5, 0.75, 1.0], // Smooth metallic transition
  );

}
