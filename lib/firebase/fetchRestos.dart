import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

Future<List<Map<String, dynamic>>> getRestaurants() async {
  List<Map<String, dynamic>> restaurants = [];

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'restaurant')
        .get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String uid = doc.id; // 🔹 Get UID from document ID

      print("📍 Restaurant found: ${data['name']} (UID: $uid)");

      // Ensure location exists
      if (data['location'] == null || data['location'] is! Map) {
        print("⚠️ No location data for ${data['name']}");
        restaurants.add({
          'uid': uid,
          'name': data['name'] ?? 'Unknown Restaurant',
          'address': 'Unknown Location',
        });
        continue; // Skip this restaurant
      }

      // Extract latitude & longitude safely
      Map<String, dynamic> locationData = data['location'];
      double latitude = (locationData['latitude'] as num?)?.toDouble() ?? 0.0;
      double longitude = (locationData['longitude'] as num?)?.toDouble() ?? 0.0;

      if (latitude == 0.0 && longitude == 0.0) {
        print("⚠️ Invalid coordinates for ${data['name']}");
        restaurants.add({
          'uid': uid,
          'name': data['name'] ?? 'Unknown Restaurant',
          'address': 'Unknown Location',
        });
        continue; // Skip this restaurant
      }

      print("📌 Coordinates: $latitude, $longitude");

      // Get address from coordinates
      String address = await getAddressFromCoordinates(latitude, longitude);
      print("🏠 Resolved Address: $address");

      // Add to list
      restaurants.add({
        'uid': uid,
        'name': data['name'] ?? 'Unknown Restaurant',
        'address': address,
      });
    }
  } catch (e) {
    print("❌ Error fetching restaurants: $e");
  }

  return restaurants;
}

Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  try {
    print("🌍 Fetching address for: $latitude, $longitude");

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    print("📜 Raw Placemark Response: $placemarks");

    if (placemarks.isEmpty) {
      print("⚠️ No address found for coordinates: $latitude, $longitude");
      return "Unknown Location";
    }

    Placemark place = placemarks.first;

    String street = place.street ?? "";
    String city = place.locality ?? "";
    String state = place.administrativeArea ?? "";
    String country = place.country ?? "";
    String postalCode = place.postalCode ?? "";

    if (street.isEmpty && city.isEmpty && state.isEmpty && country.isEmpty) {
      print("⚠️ Placemark returned empty fields");
      return "Unknown Location";
    }

    String fullAddress = "$street, $city, $state, $country, $postalCode".trim();
    print("🏠 Resolved Address: $fullAddress");

    return fullAddress;
  } catch (e) {
    print("❌ Error getting address: $e");
    return "Unknown Location";
  }
}
