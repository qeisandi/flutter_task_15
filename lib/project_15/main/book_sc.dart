import 'package:flutter/material.dart';

class BookSc extends StatefulWidget {
  const BookSc({super.key});

  @override
  State<BookSc> createState() => _BookScState();
}

class _BookScState extends State<BookSc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff039EFD),
        centerTitle: true,
        title: Text(
          'Booking Schedule',
          style: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
