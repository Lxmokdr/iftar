import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../classes/colors.dart';
import 'help.dart';

class PaymentScreen extends StatefulWidget {
  final String uid; // 🔹 Restaurant UID

  PaymentScreen({required this.uid});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
  TextEditingController amountController = TextEditingController();
  final List<String> paymentMethods = ["CCP", "Espèces"];
  bool isAmountEntered = false;
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

  Future<void> submitRequest() async {  
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount.")),
      );
      return;
    }

    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a payment method.")),
      );
      return;
    }

    if (volunteerUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated!")),
      );
      return;
    }

    String restoUid = widget.uid;
    String requestId = Uuid().v4();

    try {
      await FirebaseFirestore.instance
          .collection("requests")
          .doc(restoUid)
          .collection("requests")
          .doc(requestId)
          .set({
        'volunteer_uid': volunteerUid,
        'type': 'money',
        'quantity': amountController.text,
        'method': selectedMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request submitted successfully!")),
      );

      setState(() {
        amountController.clear();
        selectedMethod = null;
        isAmountEntered = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit request!")),
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
            child: Text(
              "PAYMENT DETAILS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

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

                      /// 🔹 Enter Amount
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Amount",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: color.darkcolor, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isAmountEntered = value.isNotEmpty;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),

                      /// 🔹 Select Payment Method (After entering amount)
                      if (isAmountEntered)
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: paymentMethods.length,
                            itemBuilder: (context, index) {
                              final method = paymentMethods[index];
                              bool isSelected = selectedMethod == method;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMethod = method;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color.bgColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                                  ),
                                  child: Center(
                                    child: Text(method, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      /// 🔹 Display Payment Info
                      if (selectedMethod == "CCP")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.bgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Restaurant CCP Details:", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text("Account Number: 123456789"),
                                Text("Bank: XYZ Bank"),
                              ],
                            ),
                          ),
                        ),

                      if (selectedMethod == "Espèces")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "You will receive a verification call shortly.",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),

                      /// 🔹 Done Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: selectedMethod != null ? color.goldGradient : null,
                            color: selectedMethod == null ? Colors.grey : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: selectedMethod != null
                                ? () async {
                              await submitRequest(); // Submit the request
                              Navigator.pop(context); // Go back to the previous screen
                            }
                                : null,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 Profile Image
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
