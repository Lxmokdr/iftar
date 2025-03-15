import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../classes/colors.dart';
import '../resto/needs.dart';
import '../volunteer/listresto.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;
  bool isVolunteer = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // تسجيل مستخدم جديد
  Future<void> _signUp() async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        _showSnackbar("كلمتا المرور غير متطابقتين!");
        return;
      }

      // طلب إذن الموقع
      PermissionStatus status = await Permission.locationWhenInUse.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        _showSnackbar("إذن الموقع مطلوب للتسجيل!");
        return;
      }

      // التأكد من تمكين خدمات الموقع
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showSnackbar("خدمات الموقع معطلة. يرجى تمكينها.");
        return;
      }

      // الحصول على الموقع
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // تسجيل المستخدم في Firebase
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // حفظ بيانات المستخدم في Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": emailController.text.trim(),
        "role": isVolunteer ? "volunteer" : "restaurant",
        "volunteers": 0,
        "money": 0,
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "location": {
          "latitude": position.latitude,
          "longitude": position.longitude,
        },
      });

      _navigateToRoleScreen(isVolunteer ? "volunteer" : "restaurant");
    } catch (e) {
      _showSnackbar("فشل التسجيل: ${e.toString()}");
    }
  }

  // تسجيل الدخول
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
      String role = userDoc["role"];

      _navigateToRoleScreen(role);
    } catch (e) {
      _showSnackbar("فشل تسجيل الدخول: ${e.toString()}");
    }
  }

  // الانتقال إلى الشاشة المناسبة
  void _navigateToRoleScreen(String role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => role == "volunteer" ? IftarScreen() : NeedsScreen(),
      ),
    );
  }

  // رسالة خطأ
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: Stack(
        children: [
          // عناصر الديكور
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/fanous.png", height: 100),
                Image.asset("assets/moon.png", height: 200),
                Image.asset("assets/star.png", height: 150),
              ],
            ),
          ),

          // اختيار الدور (متطوع / مطعم)
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roleToggleButton("متطوع", true),
                SizedBox(width: 10),
                _roleToggleButton("مطعم", false),
              ],
            ),
          ),

          // نموذج المصادقة
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            bottom: 0,
            left: 0,
            right: 0,
            height: isLogin ? 400 : MediaQuery.of(context).size.height * 0.7,
            child: Container(
              decoration: BoxDecoration(
                gradient: color.goldGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(isLogin ? 'تسجيل الدخول' : 'إنشاء حساب', style: TextStyle(color: color.darkcolor, fontSize: 32)),
                  SizedBox(height: 10),

                  if (!isLogin) _customTextField(Icons.business, isVolunteer ? "الاسم الكامل.." : "اسم المطعم..", nameController),
                  if (!isLogin) _customTextField(Icons.phone, "رقم الهاتف..", phoneController),
                  _customTextField(Icons.email, "البريد الإلكتروني..", emailController),
                  _customTextField(Icons.lock, "كلمة المرور..", passwordController, isPassword: true),
                  if (!isLogin) _customTextField(Icons.lock, "تأكيد كلمة المرور..", confirmPasswordController, isPassword: true),

                  SizedBox(height: 20),

                  // زر المصادقة
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: isLogin ? _login : _signUp,
                    child: Text(isLogin ? 'تسجيل الدخول' : 'إنشاء حساب', style: TextStyle(color: color.darkcolor, fontSize: 16)),
                  ),

                  // التبديل بين التسجيل وتسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isLogin ? "ليس لديك حساب؟ " : "لديك حساب بالفعل؟ "),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(isLogin ? "إنشاء حساب" : "تسجيل الدخول", style: TextStyle(color: color.bgColor)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // زر اختيار الدور
  Widget _roleToggleButton(String text, bool isVolunteerOption) {
    return GestureDetector(
      onTap: () => setState(() => isVolunteer = isVolunteerOption),
      child: Container(
        decoration: BoxDecoration(
          gradient: isVolunteer == isVolunteerOption ? color.goldGradient : null,
          color: isVolunteer != isVolunteerOption ? color.lightbg : null,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            color: isVolunteer == isVolunteerOption ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // حقل إدخال مخصص
  Widget _customTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
        ),
      ),
    );
  }
}
