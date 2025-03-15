import 'package:flutter/material.dart';
import 'package:iftar/classes/colors.dart';
import 'package:iftar/volunteer/utensils.dart';

import 'help.dart';

class Utensilist extends StatefulWidget {
  final String uid; // 🔹 معرف المستخدم كمعامل
  final List<Map<String, dynamic>> utensils;
  Utensilist({super.key, required this.utensils, required this.uid});

  @override
  _UtensilistState createState() => _UtensilistState();
}

class _UtensilistState extends State<Utensilist> {
  late List<Map<String, dynamic>> utensils;

  @override
  void initState() {
    super.initState();
    utensils = widget.utensils;  // ✅ تعيين قائمة الأدوات المستلمة
  }

  /// 🔹 وظيفة لتحديد لون الخلفية بناءً على التوفر
  Color getBackgroundColor(int needed, int available) {
    double ratio = available / needed;
    if (ratio >= 1) {
      return Colors.green.shade400; // متوفر بالكامل
    } else if (ratio >= 0.5) {
      return Colors.yellow.shade400; // متوفر جزئياً
    } else {
      return Colors.red.shade400; // منخفض للغاية
    }
  }

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
          /// 🔹 صورة العنوان
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
                'assets/img.png', // استبدلها بالصورة الفعلية
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),

          /// 🔹 عرض القائمة الشبكية
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: utensils.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12, // زيادة التباعد
                  mainAxisSpacing: 12, // زيادة التباعد
                  childAspectRatio: 1.5, // ✅ جعل الصناديق أطول
                ),
                itemBuilder: (context, index) {
                  var utensil = utensils[index];
                  Color bgColor = getBackgroundColor(utensil["quantity"], utensil["available"]);

                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16), // زوايا مستديرة أكثر
                    ),
                    padding: EdgeInsets.all(16), // ✅ زيادة التباعد الداخلي
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          utensil["name"],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 6), // إضافة تباعد
                        Text(
                          "الكمية: ${utensil["quantity"]}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          "المتوفر: ${utensil["available"]}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          /// 🔹 زر المساعدة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton("تم", () {
                print("تم");
                Navigator.push(context, MaterialPageRoute(builder: (_) => IftarHelpScreen(uid: widget.uid,)));
              }),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 🔹 وظيفة لإنشاء زر الإجراء
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: color.goldGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // شفاف لعرض التدرج اللوني
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
