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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Function for Signing Up
  Future<void> _signUp() async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      // Request Location Permission
      PermissionStatus status = await Permission.locationWhenInUse.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission is required for signup!")),
        );
        return;
      }

      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location permission is permanently denied. Please enable it from settings."),
            action: SnackBarAction(
              label: "Open Settings",
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }

      // Ensure location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location services are disabled. Please enable them.")),
        );
        return;
      }

      // Get Current Location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save User to Firestore
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

      // Navigate to the appropriate role-based screen
      _navigateToRoleScreen(isVolunteer ? "volunteer" : "restaurant");

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Failed: ${e.toString()}")),
      );
    }
  }


  // Function for Logging In
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: ${e.toString()}")),
      );
    }
  }

  // Navigate to the Correct Role-Based Screen
  void _navigateToRoleScreen(String role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => role == "volunteer" ? IftarScreen() : NeedsScreen(),
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("User location: ${position.latitude}, ${position.longitude}");
    } else {
      print("Location permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: Stack(
        children: [
          // Background Decorations
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
                Image.asset("assets/fanous.png", height: 100),
                Image.asset("assets/moon.png", height: 200),
                Image.asset("assets/star.png", height: 150),
              ],
            ),
          ),

          // Toggle for Volunteer / Restaurant
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roleToggleButton("Volunteer", true),
                SizedBox(width: 10),
                _roleToggleButton("Restaurant", false),
              ],
            ),
          ),

          // Auth Form
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
                  Text(isLogin ? 'Login' : 'Signup', style: TextStyle(color: color.darkcolor, fontSize: 32)),
                  SizedBox(height: 10),

                  if (!isLogin) _customTextField(Icons.business, isVolunteer ? "Full Name.." : "Restaurant Name..", nameController),
                  if (!isLogin) _customTextField(Icons.phone, "Phone Number..", phoneController),
                  _customTextField(Icons.email, "Email address..", emailController),
                  _customTextField(Icons.lock, "Password..", passwordController, isPassword: true),
                  if (!isLogin) _customTextField(Icons.lock, "Verify password..", confirmPasswordController, isPassword: true),

                  SizedBox(height: 20),

                  // Auth Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: isLogin ? _login : _signUp,
                    child: Text(isLogin ? 'Login' : 'Signup', style: TextStyle(color: color.darkcolor, fontSize: 16)),
                  ),

                  // Toggle Between Signup & Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isLogin ? "Don't have an account? " : "Already have an account? "),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(isLogin ? "Signup" : "Login", style: TextStyle(color: color.bgColor)),
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

  // Role Toggle Button
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

  // Custom Text Field
  Widget _customTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        ),
      ),
    );
  }
}
