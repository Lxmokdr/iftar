import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء منشور'),
        backgroundColor: Color.fromARGB(255, 203, 140, 52),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'اكتب شيئًا...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // تنفيذ إضافة الصورة لاحقًا
              },
              icon: Icon(Icons.image),
              label: Text('إضافة صورة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 203, 140, 52),
                foregroundColor: Colors.white,
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // تنفيذ منطق النشر
                  Navigator.pop(context);
                },
                child: Text('نشر'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 203, 140, 52),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
