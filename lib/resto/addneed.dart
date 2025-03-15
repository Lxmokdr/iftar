import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iftar/resto/needs.dart';
import '../classes/colors.dart';

class AddNeed extends StatefulWidget {
  @override
  _AddNeedState createState() => _AddNeedState();
}

class _AddNeedState extends State<AddNeed> {
  String? selectedUtensil;
  TextEditingController quantityController = TextEditingController();

  /// قائمة الأدوات المسبقة للاختيار
  final List<String> utensilsList = [
    "ملعقة",
    "شوكة",
    "سكين",
    "طبق",
    "وعاء",
    "كوب",
    "منديل",
    "قدر طبخ",
    "مقلاة"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// 🔹 خلفية متدرجة كاملة
          Container(
            decoration: BoxDecoration(
              gradient: color.goldGradient,
            ),
          ),

          /// 🔹 العنوان العلوي
          Padding(
            padding: EdgeInsets.only(top: 75),
            child: Column(
              children: [
                Text(
                  "بِمَاذَا تُرِيدُ المُسَاعَدَة؟",
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
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// 🔹 قائمة اختيار الأداة
                        _buildDropdownField(),

                        /// 🔹 إدخال الكمية
                        _buildInputField("الكمية..", quantityController),

                        /// 🔹 زر الإجراء
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton("تم", () async {
                              await _addUtensil();
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 صورة الملف الشخصي
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

  /// 🔹 وظيفة إضافة الأداة إلى Firestore
  Future<void> _addUtensil() async {
    int? quantity = int.tryParse(quantityController.text.trim());

    if (selectedUtensil == null || quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار أداة وإدخال كمية صالحة.')),
      );
      return;
    }

    try {
      // الحصول على معرف المستخدم المسجل
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("المستخدم غير مسجل الدخول.");
      }

      // مرجع لمجموعة الأدوات الخاصة بالمستخدم
      CollectionReference utensilsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('utensils');

      // إضافة الأداة إلى Firestore
      await utensilsRef.add({
        'name': selectedUtensil,
        'quantity': quantity,
        'available': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // مسح الحقول بعد الإضافة
      setState(() {
        selectedUtensil = null;
        quantityController.clear();
      });

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إضافة الأداة بنجاح!')),
      );

      // الانتقال إلى شاشة الاحتياجات
      Navigator.push(context, MaterialPageRoute(builder: (_) => NeedsScreen()));
    } catch (e) {
      print("خطأ في إضافة الأداة: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة الأداة. حاول مرة أخرى.')),
      );
    }
  }

  /// 🔹 بناء قائمة الاختيار
  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF3E2C7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedUtensil,
            hint: Text("اختر أداة", style: TextStyle(color: Colors.black54)),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            onChanged: (String? newValue) {
              setState(() {
                selectedUtensil = newValue;
              });
            },
            items: utensilsList.map<DropdownMenuItem<String>>((String utensil) {
              return DropdownMenuItem<String>(
                value: utensil,
                child: Text(utensil, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// 🔹 Function to build input field
  Widget _buildInputField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Color(0xFFF3E2C7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// 🔹 Function to build action button
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: color.goldGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
