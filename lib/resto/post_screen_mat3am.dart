import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_post_screen.dart';

class PostScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PostScreen> {
  bool isLiked = false;
  bool isSaved = false;
  int likes = 10;
  int comments = 6;
  String location = "عين طاية";
  String restaurantName = "الرحمة";
  String timeAgo = "منذ 6 دقائق";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 25,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'إفطار',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 203, 140, 52),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/img_1.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/img_1.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(restaurantName, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(location, style: TextStyle(color: Colors.grey)),
                          Text(timeAgo, style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/img.png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Color.fromARGB(255, 203, 140, 52),
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                            likes += isLiked ? 1 : -1;
                          });
                        },
                      ),
                      Text('$likes'),
                      SizedBox(width: 20),
                      Icon(Icons.chat_bubble_outline, color: Color.fromARGB(255, 203, 140, 52)),
                      SizedBox(width: 5),
                      Text('$comments تعليقات', style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? Colors.black : Color.fromARGB(255, 203, 140, 52),
                        ),
                        onPressed: () {
                          setState(() {
                            isSaved = !isSaved;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 203, 140, 52),
        child: Icon(Icons.add, size: 32, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
      ),
    );
  }
}
