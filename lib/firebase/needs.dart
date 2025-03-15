import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> fetchUtensils(String uid, Function(List<String>) updateNeeds) async {
  if (uid.isNotEmpty) {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('utensils')
          .get();

      List<String> fetchedNeeds = snapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data();
        String name = data?['name'] ?? 'Unknown';
        int quantity = (data?['quantity'] ?? 0) as int;
        return "$quantity x $name";
      }).toList();

      updateNeeds(fetchedNeeds); // Pass data to the callback function
    } catch (e) {
      print("Error fetching utensils: $e");
    }
  }
}
Future<List<Map<String, dynamic>>> getUtensils(String uid) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot utensilSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('utensils')
        .get();

    return utensilSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};

      return {
        'name': data['name'] ?? 'Unknown',
        'quantity': (data['quantity'] as num?)?.toInt() ?? 0, // ✅ Ensure integer
        'available': (data['available'] as num?)?.toInt() ?? 0, // ✅ Ensure integer
      };
    }).toList();

  } catch (e, stacktrace) {
    debugPrint("Error fetching utensils: $e\n$stacktrace");
    return [];
  }
}
