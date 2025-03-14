import 'package:flutter/material.dart';
import 'package:iftar/classes/colors.dart';

class Utensilist extends StatefulWidget {
  @override
  _UtensilistState createState() => _UtensilistState();
}

class _UtensilistState extends State<Utensilist> {
  List<String> utensils = [
    "20 Assiétte", "20 Fourchette", "2 Marmites", "2 Marmites",
    "2 Marmites", "2 Marmites", "20 Bolle", "2 cuilleres",
    "2 Fourchettes", "2 Marmites", "2 bols", "2 Marmites"
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

          /// 🔹 GRID LIST DISPLAY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: utensils.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      utensils[index],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
