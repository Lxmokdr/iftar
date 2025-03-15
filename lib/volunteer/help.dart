import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iftar/volunteer/organazing.dart';
import 'package:iftar/volunteer/payerment.dart';
import 'package:iftar/volunteer/transportation.dart';
import 'package:iftar/volunteer/utensils.dart';
import '../classes/colors.dart';
import 'foodpage.dart';

class IftarHelpScreen extends StatefulWidget {
  final String uid; // 🔹 تمرير معرف المستخدم كمعامل

  IftarHelpScreen({required this.uid});

  @override
  _IftarHelpScreenState createState() => _IftarHelpScreenState();
}

class _IftarHelpScreenState extends State<IftarHelpScreen> {
  bool isOrganizingConfirmed = false;

  void toggleOrganizing() {
    if (!isOrganizingConfirmed) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("المساعدة في التنظيم؟"),
          content: Text("هل ترغب في تأكيد مساعدتك في التنظيم؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("لا", style: TextStyle(color: color.darkcolor)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isOrganizingConfirmed = true;
                });
                _updateVolunteerCount(1); // 🔹 زيادة عدد المتطوعين في Firestore
                Navigator.pop(context);
              },
              child: Text("نعم", style: TextStyle(color: color.darkcolor)),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("إلغاء التنظيم؟"),
          content: Text("هل أنت متأكد من الإلغاء؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("لا", style: TextStyle(color: color.darkcolor)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isOrganizingConfirmed = false;
                });
                _updateVolunteerCount(-1); // 🔹 تقليل عدد المتطوعين في Firestore
                Navigator.pop(context);
              },
              child: Text("نعم", style: TextStyle(color: color.darkcolor)),
            ),
          ],
        ),
      );
    }
  }

  /// 🔹 تحديث عدد المتطوعين في Firestore
  void _updateVolunteerCount(int increment) async {
    try {
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(widget.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          int currentCount = (snapshot['volunteers'] ?? 0);
          transaction.update(userRef, {'volunteers': currentCount + increment});
        }
      });

      print("تم تحديث عدد المتطوعين بنجاح!");
    } catch (e) {
      print("خطأ في تحديث عدد المتطوعين: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// 🔹 خلفية بتدرج لوني
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
                  "بِمَ تُرِيدُ المُسَاعَدَة؟",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'عين طاية - 15 دقيقة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color.darkcolor,
                        ),
                      ),
                      SizedBox(height: 30),

                      /// 🔹 أزرار المساعدة
                      _helpButton('الطعام', Foodpage(uid: widget.uid)),
                      _helpButton('المال', PaymentScreen(uid: widget.uid)),
                      _helpButton('النقل', null, isPopup: true),
                      _helpButton('الأواني', UtensilLoanScreen(uid: widget.uid)),
                      _organizingButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  /// 🔹 زر المساعدة المخصص
  Widget _helpButton(String title, Widget? page, {bool isPopup = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          trailing: ElevatedButton(
            onPressed: () {
              if (isPopup) {
                showTransportSelectionPopup(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page!), // 🔹 تمرير UID للصفحة
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            child: Text(
              'تبرع',
              style: TextStyle(
                color: color.darkcolor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 زر التنظيم
  Widget _organizingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: ListTile(
          title: Text(
            'التنظيم',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          trailing: ElevatedButton(
            onPressed: toggleOrganizing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            child: Text(
              isOrganizingConfirmed ? '✔' : 'تأكيد',
              style: TextStyle(
                color: color.darkcolor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
