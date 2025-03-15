import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iftar/classes/colors.dart';
import 'package:iftar/common/signup.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String notificationSetting = "السماح";
  String selectedLanguage = "العربية";
  final List<String> languages = ["الإنجليزية", "الفرنسية", "العربية", "الإسبانية"];

  String name = "";
  String email = "";
  String phone = "";
  String location = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        print("Fetched User Data: ${userDoc.data()}"); // Debugging
        setState(() {
          name = userDoc["name"] ?? "اسم غير متوفر";
          email = userDoc["email"] ?? "بريد غير متوفر";
          phone = userDoc["phone"] ?? "رقم غير متوفر";
          location = userDoc["location"] ?? "موقع غير متوفر";
        });
      } else {
        print("User document does not exist in Firestore.");
      }
    } else {
      print("No user is logged in.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color.darkcolor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إفطار',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: color.darkcolor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/img_1.png')),
            SizedBox(height: 10),
            Text(name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(email, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey.shade300),
            _buildProfileOption(Icons.person_outline, 'ملفي الشخصي', () => _showProfilePopup(context)),
            _buildProfileOption(Icons.settings, 'الإعدادات', () => _showSettingsBottomSheet(context)),
            _buildNotificationOption(),
            _buildProfileOption(Icons.logout, 'تسجيل الخروج', () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 10),
            Expanded(child: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500))),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Icons.notifications_outlined, color: Colors.black),
          SizedBox(width: 10),
          Expanded(child: Text('الإشعارات', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color.darkcolor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(20),
                dropdownColor: color.darkcolor,
                value: notificationSetting,
                style: TextStyle(color: Colors.white),
                items: ['السماح', 'كتم الصوت'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => notificationSetting = newValue!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfilePopup(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController locationController = TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color.lightbg, // Set background to app theme
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'تحديث الملف الشخصي',
            textAlign: TextAlign.center,
            style: TextStyle(color: color.darkcolor, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfileTextField('الاسم الكامل', nameController),
              _buildProfileTextField('رقم الهاتف', phoneController),
              _buildProfileTextField('الموقع', locationController),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.darkcolor, // App primary color
                  foregroundColor: color.lightbg, // Text color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                      "name": nameController.text,
                      "phone": phoneController.text,
                      "location": locationController.text,
                    });
                    _fetchUserData();
                    Navigator.pop(context);
                  }
                },
                child: Text('حفظ التغييرات'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: color.darkcolor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.darkcolor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.darkcolor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }


  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الإعدادات', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('اللغة', style: GoogleFonts.poppins(fontSize: 16)),
                  DropdownButton<String>(
                    value: selectedLanguage,
                    items: languages.map((String lang) {
                      return DropdownMenuItem<String>(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (newValue) => setState(() => selectedLanguage = newValue!),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
