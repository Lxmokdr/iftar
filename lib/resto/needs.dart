import 'package:flutter/material.dart';
import 'package:iftar/volunteer/utensils.dart';
import '../classes/colors.dart';
import 'addneed.dart';

class NeedsScreen extends StatelessWidget {
  final List<String> needs = [
    "20 Assiétte", "2 Marmites", "2 Marmites", "20 Bolle", "2 Marmites",
    "2 Marmites", "20 Fourchette", "2 Marmites", "2 Marmites", "2 cuilleres",
    "2 Marmites", "2 Marmites",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: PageView(
        children: [
          _buildNeedsPage(context),
          _buildSecondPage(context), // Second screen when scrolling right
        ],
      ),
    );
  }

  Widget _buildNeedsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          SizedBox(height: 10),
          Text("Needs:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: color.darkcolor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.builder(
                itemCount: needs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(needs[index], style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddNeed()));
              },
              icon: Icon(Icons.add, color: Colors.white,),
              label: Text("ADD", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: color.darkcolor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            Text("Set Needs", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildInputField("Set max needed money", ".......DZD"),
            SizedBox(height: 10),
            _buildInputField("Set max needed Organizers", "......."),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Block Food", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: color.lightbg,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: color.darkcolor),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/img_1.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: color.bgColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
