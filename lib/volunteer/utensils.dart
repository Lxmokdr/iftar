import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iftar/volunteer/utesilist.dart';
import '../classes/colors.dart';
import '../common/button.dart';
import '../firebase/needs.dart';
import 'help.dart';
import 'package:uuid/uuid.dart';

class UtensilLoanScreen extends StatefulWidget {
  final String uid; // 🔹 Take UID as a parameter

  UtensilLoanScreen({required this.uid});
  @override
  _UtensilLoanScreenState createState() => _UtensilLoanScreenState();
}

class _UtensilLoanScreenState extends State<UtensilLoanScreen> {
  String? selectedUtensil;
  TextEditingController quantityController = TextEditingController();
  String? volunteerUid; // Current User UID


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      volunteerUid = user?.uid;
    });
  }

  final List<String> utensils = [
    "Plate",
    "Cups",
    "Spoons",
    "Forks",
    "Knives",
    "Pots",
    "Serving Trays",
  ];

  Future<void> submitRequest() async {
    if (selectedUtensil == null || selectedUtensil!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a utensil.")),
      );
      return;
    }

    int quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid quantity.")),
      );
      return;
    }

    if (volunteerUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated!")),
      );
      return;
    }

    String restoUid = widget.uid; // 🔹 Resto UID passed from screen
    String requestId = Uuid().v4(); // 🔹 Generate a unique ID for the request

    try {
      // Reference to the requests collection inside the restaurant UID
      DocumentReference requestRef = FirebaseFirestore.instance
          .collection("requests")
          .doc(restoUid)
          .collection("requests")
          .doc(requestId);

      // Create a new request document
      await requestRef.set({
        'volunteer_uid': volunteerUid,
        'type': 'utensil',
        'item': selectedUtensil,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(), // 🔹 Add timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request submitted successfully!")),
      );

      // Clear input fields after submission
      quantityController.clear();
      setState(() {
        selectedUtensil = null;
      });

    } catch (e) {
      print("Error submitting request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit request!")),
      );
    }
  }

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

                      SizedBox(height: 20),

                      /// 🔹 ACTION BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildActionButton("Done", () async {
                            await submitRequest(); // ✅ Call function before navigating
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => IftarHelpScreen(uid: widget.uid)),
                            );
                          }),

                          SizedBox(width: 16),
                          buildActionButton("See List", () async {
                            if (widget.uid.isEmpty) {
                              print("Error: UID is empty!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: UID is empty!")),
                              );
                              return;
                            }

                            print("Fetching utensils for UID: ${widget.uid}");

                            try {
                              List<Map<String, dynamic>> utensils = await getUtensils(widget.uid); // 🔹 Ensure correct type

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Utensilist(utensils: utensils, uid: widget.uid), // ✅ No type mismatch
                                ),
                              );
                            } catch (e) {
                              print("Error fetching utensils: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to load utensils!")),
                              );
                            }
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
