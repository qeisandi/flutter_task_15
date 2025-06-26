import 'package:flutter/material.dart';

class AddSc extends StatefulWidget {
  static const String id = "/add_sd";
  const AddSc({super.key});

  @override
  State<AddSc> createState() => _AddScState();
}

class _AddScState extends State<AddSc> {
  String? selectedField;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final statusList = ['Available', 'Not Available'];
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff039EFD),
        title: Text(
          'Tambah Jadwal',
          style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDropdownField(
                  'Pilih Lapangan',
                  ['Lapangan A', 'Lapangan B'],
                  (val) {
                    setState(() => selectedField = val);
                  },
                  selectedField,
                ),
                SizedBox(height: 16),
                _buildDatePicker(),
                SizedBox(height: 16),
                _buildTimePicker(
                  'Waktu Mulai',
                  (time) => setState(() => startTime = time),
                  startTime,
                ),
                SizedBox(height: 16),
                _buildTimePicker(
                  'Waktu Selesai',
                  (time) => setState(() => endTime = time),
                  endTime,
                ),
                SizedBox(height: 16),
                _buildDropdownField('Status', statusList, (val) {
                  setState(() => selectedStatus = val);
                }, selectedStatus),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff039EFD),
                  ),
                  onPressed: () {},
                  child: Text(
                    'TAMBAH JADWAL',
                    style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    Function(String?) onChanged,
    String? selected,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Gilroy'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selected,
      onChanged: onChanged,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => selectedDate = picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Tanggal',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'Pilih Tanggal',
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    Function(TimeOfDay) onTimePicked,
    TimeOfDay? time,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) onTimePicked(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(time != null ? time.format(context) : 'Pilih Waktu'),
      ),
    );
  }
}
