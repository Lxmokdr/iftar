import 'package:flutter/material.dart';

import '../classes/colors.dart';
import 'help.dart';

class TransportSelectionScreen extends StatefulWidget {
  @override
  _TransportSelectionScreenState createState() => _TransportSelectionScreenState();
}

class _TransportSelectionScreenState extends State<TransportSelectionScreen> {
  String? selectedRoute;

  final List<Map<String, String>> transportOptions = [
    {"route": "El Marsa ⬌ Ain taya", "duration": "15 min"},
    {"route": "Reghaia ⬌ Ain taya", "duration": "25 min"},
    {"route": "El Harrach ⬌ Ain taya", "duration": "1h"},
    {"route": "Ain taya ⬌ Ain taya", "duration": "15 min"},
  ];

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
          /// 🔹 TOP DECORATION
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

          /// 🔹 TRANSPORT OPTIONS
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: transportOptions.length,
              itemBuilder: (context, index) {
                final route = transportOptions[index]["route"]!;
                final duration = transportOptions[index]["duration"]!;
                bool isSelected = selectedRoute == route;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRoute = route;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: color.darkcolor, width: 2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(route, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text("Duration: $duration", style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔹 DONE BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: selectedRoute != null ? () =>
              {print("Selected: $selectedRoute"),
              Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen()))
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color.darkcolor,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Done", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),

        ],
      ),
    );
  }


}
