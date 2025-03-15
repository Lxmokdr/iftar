import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iftar/volunteer/transportation.dart';
import '../classes/colors.dart';
import '../firebase/fetchRestos.dart';
import 'help.dart';

class IftarScreen extends StatefulWidget {
  @override
  State<IftarScreen> createState() => _IftarScreenState();
}

class _IftarScreenState extends State<IftarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إفطار',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color.darkcolor),
                ),
                IconButton(
                  icon: Icon(Icons.language, color: color.darkcolor),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن مطاعم',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: color.darkcolor),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'المطاعم المتاحة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ أثناء تحميل المطاعم.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('لا توجد مطاعم متاحة.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var restaurant = snapshot.data![index];
                      return RestaurantCard(
                        name: restaurant['name'] ?? 'غير معروف',
                        address: restaurant['address'] ?? 'موقع غير معروف',
                        uid: restaurant['uid'] ?? '',
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: color.goldGradient,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.directions_car, color: Colors.white, size: 30),
                  onPressed: () {
                    showTransportSelectionPopup(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String address;
  final String uid;

  const RestaurantCard({required this.name, required this.address, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/food.png', width: 80, height: 80, fit: BoxFit.cover),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(address, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IftarHelpScreen(uid: uid)),
                      );
                    },
                    child: Text('المساعدة', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Icon(Icons.location_pin, color: color.darkcolor, size: 45),
          ],
        ),
      ),
    );
  }
}
