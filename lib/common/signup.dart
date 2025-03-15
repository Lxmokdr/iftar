import 'package:flutter/material.dart';
import '../classes/colors.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false; // Toggle between Login & Signup
  bool isVolunteer = true; // Toggle between Volunteer & Restaurant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: Stack(
        children: [
          // Top Decorative Images
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/fanous.png", height: 100),
                Image.asset("assets/moon.png", height: 200),
                Image.asset("assets/star.png", height: 150),
                Image.asset("assets/fanous.png", height: 200),
                Image.asset("assets/star.png", height: 150),
              ],
            ),
          ),

          // Position the Toggle on Top of the Decorations
          Positioned(
            top: 40, // Adjusted height to overlay near the moon & stars
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isVolunteer = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isVolunteer ? color.goldGradient : null, // Apply gradient when selected
                      color: !isVolunteer ? color.lightbg : null, // Default background when not selected
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Volunteer",
                      style: TextStyle(
                        color: isVolunteer ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isVolunteer = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: !isVolunteer ? color.goldGradient : null, // Apply gradient when selected
                      color: isVolunteer ? color.lightbg : null, // Default background when not selected
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Restaurant",
                      style: TextStyle(
                        color: !isVolunteer ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Animated Bottom Card (Login/Signup)
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: isLogin ? 400 : MediaQuery.of(context).size.height * 0.69,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: color.goldGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? 'Login' : 'Signup',
                    style: TextStyle(color: color.darkcolor, fontSize: 32),
                  ),
                  SizedBox(height: 10),

                  // Social Login (Only for Signup)
                  if (!isLogin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton("assets/google.png", 20),
                        SizedBox(width: 20),
                        SocialButton("assets/facebook.png", 40),
                      ],
                    ),

                  SizedBox(height: isLogin ? 10 : 20),

                  // Text Fields
                  Column(
                    children: [
                      if (!isLogin)
                        CustomTextField(
                          Icons.business,
                          isVolunteer ? "Full Name.." : "Restaurant Name..",
                        ),
                      if (!isLogin) CustomTextField(Icons.phone, "Phone Number.."),
                      CustomTextField(Icons.email, "Email address.."),
                      CustomTextField(Icons.lock, "Password..", isPassword: true),
                      if (!isLogin) CustomTextField(Icons.lock, "Verify password..", isPassword: true),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Animated Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      elevation: 8,
                      shadowColor: color.darkcolor.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Login' : 'Signup',
                      style: TextStyle(color: color.darkcolor, fontSize: 16),
                    ),
                  ),

                  // Switch between Signup/Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isLogin ? "Don't have an account? " : "Already have an account? "),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin ? "Signup" : "Login",
                          style: TextStyle(color: color.bgColor),
                        ),
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

}

// Social Media Button
class SocialButton extends StatelessWidget {
  final String imagePath;
  final double height;
  SocialButton(this.imagePath, this.height);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: Colors.white,
      child: Image.asset(imagePath, height: height),
    );
  }
}

// Custom Text Field
class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  CustomTextField(this.icon, this.hintText, {this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }
}
