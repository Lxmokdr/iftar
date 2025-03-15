import 'package:flutter/material.dart';
import '../classes/colors.dart';

class TransportSelectionPopup extends StatefulWidget {
  @override
  _TransportSelectionPopupState createState() => _TransportSelectionPopupState();
}

class _TransportSelectionPopupState extends State<TransportSelectionPopup> {
  DateTime? fromDateTime;
  DateTime? toDateTime;

  Future<void> _selectDateTime(BuildContext context, bool isFrom) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange, // Header background color
            colorScheme: ColorScheme.light(
              primary: color.darkcolor, // Selected date color
              onPrimary: Colors.white, // Text on selected date
              onSurface: Colors.black, // Text on other dates
            ),
            dialogBackgroundColor: Colors.white, // Background color of picker
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.orange, // Header background color
              colorScheme: ColorScheme.light(
                primary: color.darkcolor, // Selected time color
                onPrimary: Colors.white, // Text on selected time
                onSurface: Colors.black, // Text on other times
              ),
              dialogBackgroundColor: Colors.white, // Background color of picker
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isFrom) {
            fromDateTime = finalDateTime;
          } else {
            toDateTime = finalDateTime;
          }
        });
      }
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
            onTap: () => _selectDateTime(context, true),
            decoration: InputDecoration(
              labelText: "From",
              suffixIcon: Icon(Icons.calendar_today, color: color.darkcolor,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

            ),
            controller: TextEditingController(
              text: fromDateTime != null ? "${fromDateTime!.toLocal()}".split(' ')[0] : "",
            ),
          ),
          SizedBox(height: 12),
          TextField(
            readOnly: true,
            onTap: () => _selectDateTime(context, false),
            decoration: InputDecoration(
              labelText: "To",
              suffixIcon: Icon(Icons.calendar_today, color: color.darkcolor,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            controller: TextEditingController(
              text: toDateTime != null ? "${toDateTime!.toLocal()}".split(' ')[0] : "",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: color.darkcolor),),
        ),
        ElevatedButton(
          onPressed: fromDateTime != null && toDateTime != null
              ? () {
            print("From: $fromDateTime, To: $toDateTime");
            Navigator.pop(context);
          }
              : null,
          child: Text("Done", style: TextStyle(color: color.darkcolor),),
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
