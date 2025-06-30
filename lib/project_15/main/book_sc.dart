import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_15/project_15/Helper/servis/main_servis.dart';

class BookSc extends StatefulWidget {
  static const String id = "/book_sc";

  const BookSc({super.key});

  @override
  State<BookSc> createState() => _BookScState();
}

class _BookScState extends State<BookSc> {
  final TextEditingController scheduleIdController = TextEditingController();
  bool isLoading = false;

  Future<void> postBooking() async {
    final scheduleId = int.tryParse(scheduleIdController.text);
    if (scheduleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan Schedule ID yang valid')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await UserServis().bookSchedule(scheduleId);
      final message = result['message'] ?? 'Booking berhasil';

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        scheduleIdController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    scheduleIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Jadwal',
          style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
        ),
        backgroundColor: const Color(0xff039EFD),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: scheduleIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Masukkan Schedule ID',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : postBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff039EFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'BOOK NOW',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
