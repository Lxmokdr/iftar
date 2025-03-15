import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../classes/colors.dart';

class TransportSelectionPopup extends StatefulWidget {
  @override
  _TransportSelectionPopupState createState() => _TransportSelectionPopupState();
}

class _TransportSelectionPopupState extends State<TransportSelectionPopup> {
  DateTime? fromDate;
  TimeOfDay? fromTime;
  DateTime? toDate;
  TimeOfDay? toTime;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color.darkcolor,
            colorScheme: ColorScheme.light(
              primary: color.darkcolor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color.darkcolor,
            colorScheme: ColorScheme.light(
              primary: color.darkcolor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isFromTime) {
          fromTime = pickedTime;
        } else {
          toTime = pickedTime;
        }
      });
    }
  }

  Future<void> _saveAvailability() async {
    if (fromDate == null || fromTime == null || toDate == null || toTime == null) return;

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      // Formatting full date and time
      String fromFormattedDate = DateFormat('yyyy-MM-dd').format(fromDate!);
      String fromFormattedTime = "${fromTime!.hour.toString().padLeft(2, '0')}:${fromTime!.minute.toString().padLeft(2, '0')}";

      String toFormattedDate = DateFormat('yyyy-MM-dd').format(toDate!);
      String toFormattedTime = "${toTime!.hour.toString().padLeft(2, '0')}:${toTime!.minute.toString().padLeft(2, '0')}";

      Map<String, dynamic> availabilityEntry = {
        "from": {
          "date": fromFormattedDate,  // Saving the full date
          "time": fromFormattedTime
        },
        "to": {
          "date": toFormattedDate,  // Saving the full date
          "time": toFormattedTime
        }
      };

      await userDoc.update({
        "availability": FieldValue.arrayUnion([availabilityEntry]),
      });

      print("Availability saved successfully!");
      Navigator.pop(context);
    } catch (e) {
      print("Error saving availability: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("Select Availability"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            readOnly: true,
            onTap: () => _selectDate(context, true),
            decoration: InputDecoration(
              labelText: "From Date",
              suffixIcon: Icon(Icons.calendar_today, color: color.darkcolor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            controller: TextEditingController(
              text: fromDate != null ? DateFormat('EEEE').format(fromDate!) : "",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            onTap: () => _selectTime(context, true),
            decoration: InputDecoration(
              labelText: "From Time",
              suffixIcon: Icon(Icons.access_time, color: color.darkcolor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            controller: TextEditingController(
              text: fromTime != null ? fromTime!.format(context) : "",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            onTap: () => _selectDate(context, false),
            decoration: InputDecoration(
              labelText: "To Date",
              suffixIcon: Icon(Icons.calendar_today, color: color.darkcolor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            controller: TextEditingController(
              text: toDate != null ? DateFormat('EEEE').format(toDate!) : "",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            onTap: () => _selectTime(context, false),
            decoration: InputDecoration(
              labelText: "To Time",
              suffixIcon: Icon(Icons.access_time, color: color.darkcolor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            controller: TextEditingController(
              text: toTime != null ? toTime!.format(context) : "",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: color.darkcolor)),
        ),
        ElevatedButton(
          onPressed: (fromDate != null && fromTime != null && toDate != null && toTime != null) ? _saveAvailability : null,
          child: Text("Done", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: color.darkcolor),
        ),
      ],
    );
  }
}

void showTransportSelectionPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => TransportSelectionPopup(),
  );
}
