import 'package:flutter/material.dart';
import 'package:iftar/volunteer/utesilist.dart';
import '../classes/colors.dart';
import '../common/button.dart';
import 'help.dart';

class UtensilLoanScreen extends StatefulWidget {
  @override
  _UtensilLoanScreenState createState() => _UtensilLoanScreenState();
}

class _UtensilLoanScreenState extends State<UtensilLoanScreen> {
  String? selectedUtensil;
  TextEditingController quantityController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();

  final List<String> utensils = [
    "Plates",
    "Cups",
    "Spoons",
    "Forks",
    "Knives",
    "Pots",
    "Serving Trays",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// 🔹 Full Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: color.goldGradient,
            ),
          ),

          /// 🔹 Top Title
          Padding(
            padding: EdgeInsets.only(top: 75),
            child: Column(
              children: [
                Text(
                  "WHAT DO U WANNA HELP",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "WITH?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          /// 🔹 Main Content
          Column(
            children: [
              SizedBox(height: 200),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),

                      /// 🔹 UTENSIL DROPDOWN FIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: DropdownButtonFormField<String>(
                          value: selectedUtensil,
                          hint: Text("Select Utensil"),
                          items: utensils.map((String utensil) {
                            return DropdownMenuItem<String>(
                              value: utensil,
                              child: Text(utensil),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedUtensil = value;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      /// 🔹 OTHER INPUT FIELDS
                      buildInputField("Quantity..", quantityController),
                      buildInputField("Arrival time..", arrivalTimeController),

                      SizedBox(height: 20),

                      /// 🔹 ACTION BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildActionButton("Done", () {
                            print("Done");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => IftarHelpScreen()),
                            );
                          }),
                          SizedBox(width: 16),
                          buildActionButton("See List", () {
                            print("See List");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Utensilist(
                                  utensils: [
                                    {"name": "Assiette", "needed": 20, "available": 20},
                                    {"name": "Fourchette", "needed": 20, "available": 10},
                                    {"name": "Marmite", "needed": 2, "available": 1},
                                    {"name": "Bol", "needed": 10, "available": 5},
                                    {"name": "Cuillère", "needed": 5, "available": 2},
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      Spacer(),

                      /// 🔹 FOOTER TEXT
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('If you need transportation call the center'),
                          Text('0557334515'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 PROFILE IMAGE
          Column(
            children: [
              SizedBox(height: 150),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
