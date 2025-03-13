import 'package:flutter/material.dart';

import 'colors.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false; // Toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: Stack(
        children: [
          Column(
            children: [
              // Top Decorative Images
              Row(
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
              Expanded(child: Container()), // Push the form to the bottom
            ],
          ),

          // Animated Container positioned at the bottom
          AnimatedAlign(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: isLogin ? Alignment.bottomCenter : Alignment.center,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minHeight: isLogin ? 250 : 450, // Small for login, larger for signup
              ),
              decoration: BoxDecoration(
                color: color.bgColor,
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
                  SizedBox(height: 20),

                  // Social Login (Only for Signup)
                  if (!isLogin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton("assets/google.png", 30),
                        SizedBox(width: 20),
                        SocialButton("assets/facebook.png", 50),
                      ],
                    ),

                  SizedBox(height: isLogin ? 10 : 20),

                  // Text Fields
                  Column(
                    children: [
                      CustomTextField(Icons.email, "Email address.."),
                      CustomTextField(Icons.lock, "Password..", isPassword: true),
                      if (!isLogin) CustomTextField(Icons.lock, "Verify password..", isPassword: true),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Animated Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.darkcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      elevation: 8,
                      shadowColor: color.darkcolor.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin; // Toggle state on click
                      });
                    },
                    child: Text(
                      isLogin ? 'Login' : 'Signup',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                            isLogin = !isLogin; // Toggle Login/Signup
                          });
                        },
                        child: Text(
                          isLogin ? "Signup" : "Login",
                          style: TextStyle(color: color.darkcolor),
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
      radius: 25,
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
