import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpersTableScreen extends StatelessWidget {
  final List<String> columns = ["name", "Organizer", "Food", "Tools"];

  final List<Map<String, String>> data = [
    {
      "name": "issam menas with a long text",
      "Organizer": "Yes",
      "Food": "bourak with extra info",
      "Tools": "Table",
    },
    {
      "name": "issam menas",
      "Organizer": "No",
      "Food": "/",
      "Tools": "Marmit",
    },
    {
      "name": "issam menas",
      "Organizer": "Yes",
      "Food": "bourak",
      "Tools": "Table",
    },
    {
      "name": "issam menas",
      "Organizer": "Yes",
      "Food": "bourak",
      "Tools": "Table",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Screen background white

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
          "Statistics of Today",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/pfp.jpg'),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 30),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 203, 140, 52),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            elevation: 0,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: 'INBOX'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
            ],
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "List of helpers",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Scrollable Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: const EdgeInsets.all(16.0), // Margin around the table
                  child: Table(
                    columnWidths: {
                      for (int i = 0; i < columns.length; i++)
                        i: IntrinsicColumnWidth(),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      // Header Row (dynamic)
                      TableRow(
                        children: columns.map((col) => _buildHeaderCell(col)).toList(),
                      ),

                      // Data Rows (dynamic)
                      ...data.map((row) {
                        return TableRow(
                          children: columns.map((col) => _buildCell(row[col] ?? "")).toList(),
                        );
                      }).toList(),

                      // Totals Row
                      TableRow(
                        children: columns.asMap().entries.map((entry) {
                          if (entry.key == 0) {
                            return _buildCell("Total", isHeader: true);
                          } else {
                            return _buildCell("30", isHeader: true);
                          }
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[400],
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 203, 140, 52),
        ),
      ),
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[400] : Colors.grey[200],
      ),
      child: Text(
        text.isNotEmpty ? text : '--',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader
              ? const Color.fromARGB(255, 203, 140, 52)
              : Colors.black,
        ),
      ),
    );
  }
}
