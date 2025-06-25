import 'package:flutter/material.dart';

class AddSc extends StatefulWidget {
  const AddSc({super.key});

  @override
  State<AddSc> createState() => _AddScState();
}

class _AddScState extends State<AddSc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff039EFD),
        centerTitle: true,
        title: Text(
          'Add Schedule',
          style: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
