import 'package:flutter/material.dart';

import '../classes/colors.dart';
import 'help.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
  TextEditingController amountController = TextEditingController();
  final List<String> paymentMethods = ["CCP", "Espèces"];
  bool isAmountEntered = false;

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
                    "PAYEMENT DETAILS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              )
          ),

          Column(
            children: [
              SizedBox(
                height: 200,
              ),
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
                      SizedBox(
                        height: 50,
                      ),
                      /// 🔹 ENTER AMOUNT FIRST
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
                              borderSide: BorderSide(color: Colors.grey, width: 1.5), // Default border color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey, width: 1.5), // Normal state
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: color.darkcolor, width: 2), // When clicked
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red, width: 1.5), // On error
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

                      /// 🔹 SELECT PAYMENT METHOD (After entering amount)
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

                      /// 🔹 DISPLAY INFO BASED ON PAYMENT METHOD
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

                      /// 🔹 DONE BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: selectedMethod != null
                                ? color.goldGradient
                                : null, // No gradient when disabled
                            color: selectedMethod == null ? Colors.grey : null, // Solid grey when disabled
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: selectedMethod != null
                                ? () {
                              print("Paid via $selectedMethod");
                              Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen()));
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Transparent to show the gradient
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
          Column(
            children: [
              SizedBox(
                height: 150,
              ),
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

