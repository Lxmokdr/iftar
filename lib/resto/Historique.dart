import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoriqueScreen extends StatefulWidget {
  @override
  _HistoriqueScreenState createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  DateTime? _selectedDate;

  // Sample data for the history items.
  final List<Map<String, String>> historyItems = [
    {
      'name': 'Menas Mohammed',
      'phone': '0557334515',
      'item': '2 Marmites',
      'date': '27/03/2024',
    },
    {
      'name': 'Menas Mohammed',
      'phone': '0557334515',
      'item': '250 da',
      'date': '29/03/2024',
    },
    {
      'name': 'Menas Mohammed',
      'phone': '0557334515',
      'item': '20 Bourak',
      'date': '01/04/2024',
    },
  ];

  // Function to pick a date.
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Screen background white.
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
          'Historique',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          // Calendar icon to pick a date.
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: _pickDate,
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 203, 140, 52),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: 'INBOX'),
              BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'POST'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
            ],
          ),
        ),
      ),

      // Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display selected date if available.
            if (_selectedDate != null)
              Text(
                'Selected Date: ${_selectedDate.toString()}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            const SizedBox(height: 16),

            // Heading
            Text(
              'Historique des aides',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // List of history items.
            Column(
              children: historyItems.map((item) {
                return _buildHistoryItem(item);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a history item with a gold frame and shadow.
  Widget _buildHistoryItem(Map<String, String> item) {
    final name = item['name'] ?? '';
    final phone = item['phone'] ?? '';
    final itemName = item['item'] ?? '';
    final date = item['date'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity, // Takes full horizontal space
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromARGB(100, 255, 197, 54),
          border: Border.all(color: Color.fromARGB(100, 255, 197, 54), width: 1), // Gold border
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            // Phone
            Text(
              phone,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            // Item info ("2 Marmites" or "250 da")
            Text(
              itemName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            // Date
            Text(
              date,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
