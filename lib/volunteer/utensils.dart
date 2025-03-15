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
  final String uid;

  UtensilLoanScreen({required this.uid});
  @override
  _UtensilLoanScreenState createState() => _UtensilLoanScreenState();
}

class _UtensilLoanScreenState extends State<UtensilLoanScreen> {
  String? selectedUtensil;
  TextEditingController quantityController = TextEditingController();
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

  final List<String> utensils = [
    "طبق",
    "أكواب",
    "ملاعق",
    "شوَك",
    "سكاكين",
    "قدور",
    "صواني تقديم",
  ];

  Future<void> submitRequest() async {
    if (selectedUtensil == null || selectedUtensil!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى اختيار أداة.")),
      );
      return;
    }

    int quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى إدخال كمية صالحة.")),
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
      DocumentReference requestRef = FirebaseFirestore.instance
          .collection("requests")
          .doc(restoUid)
          .collection("requests")
          .doc(requestId);

      await requestRef.set({
        'volunteer_uid': volunteerUid,
        'type': 'utensil',
        'item': selectedUtensil,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم إرسال الطلب بنجاح!")),
      );

      quantityController.clear();
      setState(() {
        selectedUtensil = null;
      });
    } catch (e) {
      print("خطأ في إرسال الطلب: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في إرسال الطلب!")),
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
            child: Column(
              children: [
                Text(
                  "بماذا تريد المساعدة؟",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: DropdownButtonFormField<String>(
                          value: selectedUtensil,
                          hint: Text("اختر أداة"),
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
                      buildInputField("الكمية..", quantityController),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildActionButton("تم", () async {
                            await submitRequest();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => IftarHelpScreen(uid: widget.uid)),
                            );
                          }),
                          SizedBox(width: 16),
                          buildActionButton("عرض القائمة", () async {
                            if (widget.uid.isEmpty) {
                              print("خطأ: معرف المستخدم فارغ!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("خطأ: معرف المستخدم فارغ!")),
                              );
                              return;
                            }

                            print("جلب الأدوات لمعرفة المستخدم: ${widget.uid}");

                            try {
                              List<Map<String, dynamic>> utensils = await getUtensils(widget.uid);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Utensilist(utensils: utensils, uid: widget.uid),
                                ),
                              );
                            } catch (e) {
                              print("خطأ في جلب الأدوات: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("فشل تحميل الأدوات!")),
                              );
                            }
                          }),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('إذا كنت بحاجة إلى نقل، اتصل بالمركز'),
                          Text('0557334515'),
                        ],
                      ),
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
}