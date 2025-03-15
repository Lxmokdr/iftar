import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../classes/colors.dart';
import '../common/button.dart';
import 'help.dart'; // تأكد من أن هذا الملف يحتوي على تعريفات الألوان

class Foodpage extends StatefulWidget {
  final String uid;

  const Foodpage({super.key, required this.uid});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  TextEditingController foodController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String? volunteerUid; // معرّف المستخدم الحالي

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
    if (foodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال نوع الطعام.")),
      );
      return;
    }

    int quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال كمية صحيحة.")),
      );
      return;
    }

    if (volunteerUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("المستخدم غير مصادق عليه!")),
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
        'type': 'food',
        'item': foodController.text,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إرسال الطلب بنجاح!")),
      );

      // مسح الحقول بعد الإرسال
      foodController.clear();
      quantityController.clear();

    } catch (e) {
      print("خطأ في إرسال الطلب: $e");
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
          /// 🔹 الخلفية بتدرج لوني
          Container(
            decoration: BoxDecoration(
              gradient: color.goldGradient,
            ),
          ),

          /// 🔹 العنوان العلوي
          const Padding(
            padding: EdgeInsets.only(top: 75),
            child: Column(
              children: [
                Text(
                  "بماذا ترغب في المساعدة؟",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 200),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        buildInputField('نوع الطعام..', foodController),
                        buildInputField('الكمية..', quantityController),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: color.goldGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await submitRequest();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => IftarHelpScreen(uid: widget.uid)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text(
                              'تم',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        const Spacer(),

                        /// 🔹 نص التذييل
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('إذا كنت بحاجة إلى وسيلة نقل، اتصل بالمركز'),
                            Text('0557334515'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 150),
              const CircleAvatar(
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
