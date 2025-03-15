import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../classes/colors.dart';

class StatisticsTodayScreen extends StatefulWidget {
  @override
  _StatisticsTodayScreenState createState() => _StatisticsTodayScreenState();
}

class _StatisticsTodayScreenState extends State<StatisticsTodayScreen> {
  final List<String> allCategories = ["طعام", "أواني", "مال", "تنظيم"];
  String _searchTerm = "";
  String? selectedCategory;

  List<Map<String, String>> helpersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHelpers();
  }

  Future<void> fetchHelpers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final requestsRef = FirebaseFirestore.instance
        .collection('requests')
        .doc(currentUser.uid)
        .collection('requests');

    try {
      QuerySnapshot requestsSnapshot = await requestsRef.get();
      List<Map<String, String>> tempHelpers = [];

      for (var requestDoc in requestsSnapshot.docs) {
        Map<String, dynamic> requestData = requestDoc.data() as Map<String, dynamic>;

        String? volunteerId = requestData['volunteer_uid'];
        if (volunteerId == null) continue;

        DocumentSnapshot volunteerDoc = await FirebaseFirestore.instance.collection('users').doc(volunteerId).get();
        if (!volunteerDoc.exists) continue;

        Map<String, dynamic> userData = volunteerDoc.data() as Map<String, dynamic>;

        tempHelpers.add({
          'name': userData['name'] ?? 'غير معروف',
          'phone': userData['phone'] ?? 'غير متاح',
          'type': requestData['type'] ?? 'غير معروف',
          'quantity': requestData['quantity']?.toString() ?? 'غير معروف',
          'unit': requestData['unit'] ?? '',
          'item': requestData['item'] ?? 'غير معروف',
          'method': requestData['method'] ?? 'غير معروف',
        });
      }

      setState(() {
        helpersList = tempHelpers;
        isLoading = false;
      });
    } catch (e) {
      print("خطأ في جلب البيانات: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, String>> get filteredHelpers {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      return helpersList;
    } else {
      return helpersList.where((helper) =>
      (helper['type'] ?? '').toLowerCase() == selectedCategory!.toLowerCase()).toList();
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateModal) {
            final List<String> visibleCategories = allCategories
                .where((cat) => cat.toLowerCase().contains(_searchTerm.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اختر فئة',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) {
                      setStateModal(() {
                        _searchTerm = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'ابحث عن عنصر',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: visibleCategories.length,
                      itemBuilder: (ctx, index) {
                        final category = visibleCategories[index];
                        return ListTile(
                          title: Text(category),
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 203, 140, 52)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إحصائيات اليوم:',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة المتطوعين',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.black),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}