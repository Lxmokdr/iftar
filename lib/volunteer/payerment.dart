import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../classes/colors.dart';
import 'help.dart';

class PaymentScreen extends StatefulWidget {
  final String uid;

  PaymentScreen({required this.uid});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
  TextEditingController amountController = TextEditingController();
  final List<String> paymentMethods = ["CCP", "نقداً"];
  bool isAmountEntered = false;
  String? volunteerUid;

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
        const SnackBar(content: Text("يرجى إدخال المبلغ.")),
      );
      return;
    }

    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار طريقة الدفع.")),
      );
      return;
    }

    if (volunteerUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("المستخدم غير مسجل الدخول!")),
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
        const SnackBar(content: Text("تم إرسال الطلب بنجاح!")),
      );

      setState(() {
        amountController.clear();
        selectedMethod = null;
        isAmountEntered = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل في إرسال الطلب!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: color.goldGradient,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 75),
            child: Text(
              "تفاصيل الدفع",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "أدخل المبلغ",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
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
                      if (isAmountEntered)
                        Column(
                          children: paymentMethods.map((method) {
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
                                  border: selectedMethod == method ? Border.all(color: Colors.black, width: 2) : null,
                                ),
                                child: Center(
                                  child: Text(method, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton(
                          onPressed: selectedMethod != null ? submitRequest : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                          ),
                          child: Text(
                            "تم",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}