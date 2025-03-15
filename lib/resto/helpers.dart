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
  final List<String> allCategories = ["Food", "Utensils", "Money", "Organizing"];
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
          'name': userData['name'] ?? 'Unknown',
          'phone': userData['phone'] ?? 'N/A',
          'type': requestData['type'] ?? 'Unknown',
          'quantity': requestData['quantity']?.toString() ?? 'Unknown',
          'unit': requestData['unit'] ?? '',
          'item': requestData['item'] ?? 'Unknown',
          'method': requestData['method'] ?? 'Unknown',
        });
      }

      setState(() {
        helpersList = tempHelpers;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching helpers: $e");
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
                    'Select a category',
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
                      labelText: 'Find an item',
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
          'Statistics of Today:',
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
                  'List of helpers',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.black),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
              ],
            ),
          ),
          if (selectedCategory != null && selectedCategory!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Filter: $selectedCategory',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHelpers.length,
              itemBuilder: (context, index) {
                return _buildHelperCard(filteredHelpers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperCard(Map<String, String> helper) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.bgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(helper['name'] ?? 'Unknown',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: color.darkcolor)),
            Text(helper['phone'] ?? 'N/A',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 8),
            Text("Type: ${helper['type']}", style: GoogleFonts.poppins(fontSize: 14)),
            if (helper['type'] == 'money')
              Text("Method: ${helper['method']}", style: GoogleFonts.poppins(fontSize: 14)),
            if (helper['type'] != 'money')
              Text("Item: ${helper['item']}", style: GoogleFonts.poppins(fontSize: 14)),
            Text("Quantity: ${helper['quantity']} ${helper['unit']}",
                style: GoogleFonts.poppins(fontSize: 14)),

            const SizedBox(height: 12),

            // Buttons for confirmation and rejection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _confirmHelper(helper),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Confirm button color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Confirm", style: GoogleFonts.poppins(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _rejectHelper(helper),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Reject button color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Reject", style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmHelper(Map<String, dynamic> helper) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      if (helper['type'] == 'money') {
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        DocumentSnapshot userSnapshot = await userDoc.get();
        int currentMoney = (userSnapshot['money'] ?? 0) as int;
        int addedMoney = int.tryParse(helper['quantity'].toString()) ?? 0;

        if (addedMoney > 0) {
          await userDoc.update({'money': currentMoney + addedMoney});
          print("✅ Confirmed: ${helper['name']}, added $addedMoney to money field");
        } else {
          print("⚠️ Invalid money amount: ${helper['quantity']}");
        }
      } else {
        final utensilsRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('utensils');

        QuerySnapshot utensilSnapshot = await utensilsRef
            .where('name', isEqualTo: helper['item'])
            .limit(1)
            .get();

        if (utensilSnapshot.docs.isNotEmpty) {
          DocumentSnapshot utensilDoc = utensilSnapshot.docs.first;
          int currentAvailable = (utensilDoc['available'] ?? 0) as int;
          int addedQuantity = int.tryParse(helper['quantity'].toString()) ?? 0;

          if (addedQuantity > 0) {
            await utensilDoc.reference.update({'available': currentAvailable + addedQuantity});
            print("✅ Confirmed: ${helper['name']}, added $addedQuantity ${helper['unit']} to ${helper['item']}");
          } else {
            print("⚠️ Invalid quantity: ${helper['quantity']}");
          }
        } else {
          print("⚠️ No matching utensil found for ${helper['item']}");
        }
      }
    } catch (e) {
      print("❌ Error confirming helper: $e");
    }
  }


  void _rejectHelper(Map<String, dynamic> helper) {
    print("Rejected: ${helper['name']}");
    // Add logic to remove request if needed
  }

}
