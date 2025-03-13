import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD2A679),
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
              color: Color(0xFFD2A679),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                        color: Color(0xFFF3E2C7),
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
                  color: Color(0xFFEDEDED),
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
            child: ElevatedButton(
              onPressed: selectedMethod != null ? () => print("Paid via $selectedMethod") : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD2A679),
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
