import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransportWeekScreen extends StatefulWidget {
  @override
  _TransportWeekScreenState createState() => _TransportWeekScreenState();
}

class _TransportWeekScreenState extends State<TransportWeekScreen> {
  List<Map<String, dynamic>> usersWithAvailability = [];
  List<Map<String, dynamic>> usersAvailableNow = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
        List<Map<String, dynamic>> allUsers = [];
        List<Map<String, dynamic>> availableNow = [];

        String currentDay = DateFormat('EEEE', 'ar').format(DateTime.now());
        String currentTime = DateFormat('HH:mm').format(DateTime.now());

        for (var doc in querySnapshot.docs) {
          var userData = doc.data();

          if (userData.containsKey('availability') && userData['availability'] is List) {
            List<dynamic> availabilities = userData['availability'];

            for (var slot in availabilities) {
              if (slot is Map<String, dynamic> && slot.containsKey('from') && slot.containsKey('to')) {
                bool isAvailable = isUserAvailableNow(currentDay, currentTime, slot);

                if (isAvailable) {
                  availableNow.add(userData);
                }

                allUsers.add(userData);
              }
            }
          }
        }

        setState(() {
          usersWithAvailability = allUsers;
          usersAvailableNow = availableNow;
        });
      });
    } catch (e) {
      print("خطأ في جلب المستخدمين: $e");
    }
  }

  bool isUserAvailableNow(String currentDate, String currentTime, Map<String, dynamic> slot) {
    DateTime fromDateTime = DateTime.parse("${slot['from']['date']}T${slot['from']['time']}");
    DateTime toDateTime = DateTime.parse("${slot['to']['date']}T${slot['to']['time']}");
    DateTime now = DateTime.now();

    return now.isAfter(fromDateTime) && now.isBefore(toDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'المستخدمون المتاحون',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المستخدمون المتاحون الآن:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: usersAvailableNow.isEmpty
                  ? Center(child: Text("لا يوجد مستخدمون متاحون في هذا الوقت."))
                  : ListView.builder(
                itemCount: usersAvailableNow.length,
                itemBuilder: (context, index) {
                  var user = usersAvailableNow[index];
                  return _buildUserCard(user, true);
                },
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'المستخدمون الذين لديهم توفر:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: usersWithAvailability.isEmpty
                  ? Center(child: Text("لا يوجد مستخدمون لديهم توفر."))
                  : ListView.builder(
                itemCount: usersWithAvailability.length,
                itemBuilder: (context, index) {
                  var user = usersWithAvailability[index];
                  return _buildUserCard(user, false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, bool isAvailableNow) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailableNow ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user['name'] ?? "مستخدم غير معروف",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "التوفر:",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (user['availability'] as List<dynamic>).map((slot) {
              return Text(
                "من: ${slot['from']['date']} في ${slot['from']['time']} \n"
                    "إلى: ${slot['to']['date']} في ${slot['to']['time']}",
                style: GoogleFonts.poppins(fontSize: 14),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
