import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoriqueScreen extends StatefulWidget {
  @override
  _HistoriqueScreenState createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  DateTime? _selectedDate;

  // بيانات تجريبية لعناصر السجل.
  final List<Map<String, String>> historyItems = [
    {
      'name': 'منص محمد',
      'phone': '0557334515',
      'item': '2 قدور',
      'date': '27/03/2024',
    },
    {
      'name': 'منص محمد',
      'phone': '0557334515',
      'item': '250 دج',
      'date': '29/03/2024',
    },
    {
      'name': 'منص محمد',
      'phone': '0557334515',
      'item': '20 بوراك',
      'date': '01/04/2024',
    },
  ];

  // وظيفة لاختيار تاريخ.
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // شريط العنوان
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 203, 140, 52),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'السجل',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: _pickDate,
          ),
        ],
      ),

      // شريط التنقل السفلي
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 203, 140, 52),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: 'الرسائل'),
              BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'إضافة'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
            ],
          ),
        ),
      ),

      // محتوى الشاشة
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedDate != null)
              Text(
                'التاريخ المحدد: ${_selectedDate.toString()}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            const SizedBox(height: 16),

            Text(
              'سجل المساعدات',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            Column(
              children: historyItems.map((item) {
                return _buildHistoryItem(item);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // بناء عنصر السجل
  Widget _buildHistoryItem(Map<String, String> item) {
    final name = item['name'] ?? '';
    final phone = item['phone'] ?? '';
    final itemName = item['item'] ?? '';
    final date = item['date'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromARGB(100, 255, 197, 54),
          border: Border.all(color: Color.fromARGB(100, 255, 197, 54), width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phone,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              itemName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
