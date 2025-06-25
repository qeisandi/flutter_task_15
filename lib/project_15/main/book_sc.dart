import 'package:flutter/material.dart';

class BookSc extends StatelessWidget {
  static const String id = "/book_sc";
  const BookSc({super.key});

  final List<Map<String, String>> dummySchedule = const [
    {
      'field': 'Lapangan A',
      'date': '25/06/2025',
      'time': '10:00 - 12:00',
      'price': 'Rp 150.000',
      'status': 'Available',
    },
    {
      'field': 'Lapangan B',
      'date': '26/06/2025',
      'time': '14:00 - 16:00',
      'price': 'Rp 200.000',
      'status': 'Available',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff039EFD),
        title: Text('Booking Jadwal', style: TextStyle(fontFamily: 'Gilroy', color: Colors.white)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: dummySchedule.length,
        itemBuilder: (context, index) {
          final item = dummySchedule[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text('${item['field']} - ${item['date']}', style: TextStyle(fontFamily: 'Gilroy')),
              subtitle: Text('${item['time']} • ${item['price']}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xff039EFD)),
                onPressed: () {
                  // TODO: Tampilkan dialog konfirmasi booking
                },
                child: Text('BOOK', style: TextStyle(fontFamily: 'Gilroy')),
              ),
            ),
          );
        },
      ),
    );
  }
}
