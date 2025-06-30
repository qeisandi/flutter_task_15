import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/servis/main_servis.dart';
import 'package:futsal_56/project_15/Helper/servis/schedule_servis.dart';

class AddSc extends StatefulWidget {
  static const String id = "/add_sd";
  const AddSc({super.key});

  @override
  State<AddSc> createState() => _AddScState();
}

class _AddScState extends State<AddSc> {
  ScheduleServis scheduleServis = ScheduleServis();
  UserServis userServis = UserServis();
  List<GetL> lapanganList = [];
  GetL? selectedLapangan;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLapangan();
  }

  Future<void> fetchLapangan() async {
    try {
      final result = await UserServis().getLapangan();
      setState(() {
        lapanganList = result;
      });
    } catch (e) {
      _showDialog("Gagal memuat lapangan: $e");
    }
  }

  Future<void> submitSchedule() async {
    if (selectedLapangan == null ||
        selectedDate == null ||
        startTime == null ||
        endTime == null) {
      _showDialog("Semua field harus diisi.");
      return;
    }

    setState(() => isLoading = true);

    final fieldId = selectedLapangan!.id!;
    final date =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    final start =
        "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}";
    final end =
        "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}";

    try {
      final response = await ScheduleServis().addSchedule(
        fieldId: fieldId,
        date: date,
        startTime: start,
        endTime: end,
      );

      if (response.data != null) {
        _showDialog(
          response.message ?? 'Jadwal berhasil ditambahkan',
          isSuccess: true,
        );
        Future.delayed(
          const Duration(seconds: 1),
          () => Navigator.pop(context),
        );
      } else {
        _showDialog(response.message ?? 'Gagal menambahkan jadwal');
      }
    } catch (e) {
      _showDialog("Terjadi kesalahan: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isSuccess ? 'Berhasil' : 'Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Jadwal",
          style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
        ),
        backgroundColor: const Color(0xff039EFD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<GetL>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Lapangan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: selectedLapangan,
                  onChanged:
                      (value) => setState(() => selectedLapangan = value),
                  items:
                      lapanganList.map((lapangan) {
                        return DropdownMenuItem<GetL>(
                          value: lapangan,
                          child: Text(lapangan.name ?? 'Tanpa Nama'),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      selectedDate != null
                          ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                          : "Pilih Tanggal",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => pickTime(isStart: true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Waktu Mulai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      startTime != null
                          ? startTime!.format(context)
                          : "Pilih Waktu",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => pickTime(isStart: false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Waktu Selesai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      endTime != null
                          ? endTime!.format(context)
                          : "Pilih Waktu",
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : submitSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff039EFD),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "TAMBAH JADWAL",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
