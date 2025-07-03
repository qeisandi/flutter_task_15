import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/model/model_get_book.dart';
import 'package:futsal_56/project_15/Helper/servis/get_book_servis.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  BookingService bookingService = BookingService();
  late Future<List<Booking>> _futureBookings;
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    _futureBookings = BookingService.getMyBookings();
    _futureBookings.then((value) {
      setState(() {
        bookings = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xff2F5249),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: bookings.isEmpty
          ? FutureBuilder<List<Booking>>(
              future: _futureBookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      style: const TextStyle(fontFamily: 'Gilroy'),
                    ),
                  );
                }

                final fetched = snapshot.data ?? [];
                if (fetched.isEmpty) {
                  return _buildEmpty();
                }

                bookings = fetched;
                return _buildListView();
              },
            )
          : _buildListView(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_soccer, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Belum ada booking',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final field = booking.schedule.field;
        final imageUrl = field.imagePath != null && field.imagePath!.isNotEmpty
            ? 'https://appfutsal.mobileprojp.com/storage/${field.imagePath}'
            : null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _imageFallback(),
                              )
                            : _imageFallback(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('📅 ${booking.schedule.date}'),
                            Text('🕒 ${booking.schedule.startTime} - ${booking.schedule.endTime}'),
                            Text('💰 Rp ${field.pricePerHour}'),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Aktif",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleCancel(booking.id, index),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      label: const Text(
                        'Cancel Booking',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _imageFallback() => Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );

  Future<void> _handleCancel(int id, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Batalkan Booking'),
        content: const Text('Yakin ingin membatalkan booking ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Tidak')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await bookingService.cancelBooking(id);
      if (success) {
        setState(() => bookings.removeAt(index));
        _showSnackbar("Booking berhasil dibatalkan", success: true);
      } else {
        _showSnackbar("Gagal membatalkan booking", success: false);
      }
    }
  }

  void _showSnackbar(String message, {bool success = true}) {
    final color = success ? Colors.green : Colors.red;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
