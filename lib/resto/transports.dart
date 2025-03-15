import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iftar/classes/colors.dart';

class TransportWeekScreen extends StatelessWidget {
  // Example data for the weekly schedule
  final List<List<String>> scheduleData = [
    ["Lundi: 15h-16h", "Mardi: 16h-17h"],
    ["Mercredi: 15h-16h", "Mardi: 16h-17h"],
    ["Lundi: 15h-16h"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White background
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 203, 140, 52),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Statisticss of Today:',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          // Profile image on the right
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/pfp.jpg'), // Replace with your asset
            ),
          ),
        ],
      ),


      // Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subheading
            Text(
              'List of Transports for this week',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Cards for each schedule
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: scheduleData.map((days) {
                    return _buildScheduleCard(days);
                  }).toList(),
                ),
              ),
            ),

            // "Done" button near bottom
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Builds a card for each group of day/time strings
  Widget _buildScheduleCard(List<String> days) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: days.map((day) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              day,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
