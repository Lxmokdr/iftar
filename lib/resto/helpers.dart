import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsTodayScreen extends StatefulWidget {
  @override
  _StatisticsTodayScreenState createState() => _StatisticsTodayScreenState();
}

class _StatisticsTodayScreenState extends State<StatisticsTodayScreen> {
  // All possible categories to filter by.
  final List<String> allCategories = ["Food", "Utensils", "Money", "Organizing"];

  // Current search term in the bottom sheet.
  String _searchTerm = "";

  // Currently selected category filter (null = no filter).
  String? selectedCategory;

  // Sample data structure: each helper has name, type, quantity, unit, phone.
  final List<Map<String, String>> helpersList = [
    {
      'name': 'Menas Mohammed',
      'type': 'Money',
      'quantity': '250',
      'unit': 'da',
      'phone': '0557334515',
    },
    {
      'name': 'Alice Johnson',
      'type': 'Utensils',
      'quantity': '2',
      'unit': 'marmite',
      'phone': '0557331234',
    },
    {
      'name': 'Bob Smith',
      'type': 'Food',
      'quantity': '5',
      'unit': 'sandwiches',
      'phone': '0557339876',
    },
    {
      'name': 'Charlie Brown',
      'type': 'Organizing',
      'quantity': '1',
      'unit': 'event',
      'phone': '0557334567',
    },
    {
      'name': 'Dana White',
      'type': 'Money',
      'quantity': '300',
      'unit': 'da',
      'phone': '0551234567',
    },
  ];

  // Returns a filtered list if a category is selected,
  // otherwise returns the full list.
  List<Map<String, String>> get filteredHelpers {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      return helpersList;
    } else {
      return helpersList
          .where((helper) =>
              (helper['type'] ?? '').toLowerCase() ==
              selectedCategory!.toLowerCase())
          .toList();
    }
  }

  // Opens the bottom sheet to select a category (drop list).
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // Allows the sheet to go fullscreen if needed.
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateModal) {
            // Filter categories based on _searchTerm
            final List<String> visibleCategories = allCategories
                .where((cat) =>
                    cat.toLowerCase().contains(_searchTerm.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                // Extra padding to accommodate the keyboard
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Select a category',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Search Bar
                  TextField(
                    onChanged: (value) {
                      setStateModal(() {
                        _searchTerm = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Find an item',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List of filtered categories
                  Expanded(
                    child: ListView.builder(
                      itemCount: visibleCategories.length,
                      itemBuilder: (ctx, index) {
                        final category = visibleCategories[index];
                        return ListTile(
                          title: Text(category),
                          onTap: () {
                            // Set selectedCategory and close bottom sheet
                            setState(() {
                              selectedCategory = category;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Screen background is white.
      backgroundColor: Colors.white,

      // AppBar (fixed)
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
          'Statistics of Today:',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          // Profile image in the AppBar.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/pfp.jpg'),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with margin, brown background, and rounded corners.
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.brown,
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline), label: 'POST'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
            ],
          ),
        ),
      ),

      // Body with fixed header row and scrollable list below.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with "List of helpers" + filter icon
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'List of helpers',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Only a filter icon to drop a list
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.black),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
              ],
            ),
          ),

          // Display the selected filter (if any)
          if (selectedCategory != null && selectedCategory!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Filter: $selectedCategory',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            ),

          // Scrollable list of helper cards (filtered)
          Expanded(
            child: ListView.builder(
              itemCount: filteredHelpers.length,
              itemBuilder: (context, index) {
                return _buildHelperCard(filteredHelpers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Builds a card for each helper, e.g. "Menas Mohammed" with "Money: 250 da"
  // and phone number below that, then Confirm/Reject buttons at the bottom.
  Widget _buildHelperCard(Map<String, String> helper) {
    final name = helper['name'] ?? '';
    final type = helper['type'] ?? '';
    final quantity = helper['quantity'] ?? '';
    final unit = helper['unit'] ?? '';
    final phone = helper['phone'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Color.fromARGB(100, 255, 197, 54),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title: Name
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Subtitle: "type: quantity unit"
            Text(
              "$type: $quantity $unit",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Phone number on its own line
            Text(
              phone,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const Divider(),
            // Confirm/Reject buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Confirm action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Reject action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
