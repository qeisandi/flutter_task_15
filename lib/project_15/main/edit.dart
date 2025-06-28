import 'package:flutter/material.dart';

class EditFieldPage extends StatelessWidget {
  const EditFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sementara field dummy
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Lapangan'),
        backgroundColor: Color(0xff039EFD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              items: [
                DropdownMenuItem(value: '1', child: Text('Lapangan 1')),
                DropdownMenuItem(value: '2', child: Text('Lapangan 2')),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: 'Pilih Lapangan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Harga Baru',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Nanti implementasi update
              },
              icon: Icon(Icons.update),
              label: Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff039EFD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
