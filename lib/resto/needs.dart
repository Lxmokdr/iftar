import 'package:flutter/material.dart';
import 'package:iftar/volunteer/utensils.dart';
import '../classes/colors.dart';
import 'addneed.dart';

class NeedsScreen extends StatefulWidget {
  @override
  _NeedsScreenState createState() => _NeedsScreenState();
}

class _NeedsScreenState extends State<NeedsScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.lightbg,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: currentPage == 0 ? _buildNeedsPage(context) : _buildSecondPage(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeedsPage(BuildContext context) {
    final List<String> needs = [
      "20 Assiette", "2 Marmites", "20 Bolle", "20 Fourchette", "2 cuilleres",
    ];

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(height: 30),

          // Title & Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Needs:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              _buildArrowButton(Icons.arrow_forward, () {
                setState(() {
                  currentPage = 1;
                });
              }),
            ],
          ),
          SizedBox(height: 10),

          Expanded(
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

          SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: color.goldGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AddNeed()));
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("ADD", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        /// 🔹 Full Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: color.goldGradient,
          ),
        ),

        /// 🔹 Top Title
        Padding(
            padding: EdgeInsets.only(top: 75),
            child: Column(
              children: [
                Text(
                  "Needs of the restaurant",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
        ),

        Column(
          children: [
            SizedBox(
              height: 200,
            ),
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
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                        // Title & Navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildArrowButton(Icons.arrow_back, () {
                                    setState(() {
                                      currentPage = 0;
                                    });
                                  }),
                                  SizedBox(width: 10),
                                  Text("Set Needs", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          _buildInputField("Set max needed money", ".......DZD"),
                          SizedBox(height: 10),
                          _buildInputField("Set max needed Organizers", "......."),
                          SizedBox(height: 30),
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 150,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/img.png'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: color.goldGradient,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
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
