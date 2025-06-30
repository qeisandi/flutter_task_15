import 'package:flutter/material.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_get.dart';

class DetailLapanganPageDua extends StatelessWidget {
  final GetL lapangan;

  const DetailLapanganPageDua({super.key, required this.lapangan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          lapangan.name ?? 'Detail Lapangan',
          style: const TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        ),
        backgroundColor: const Color(0xff039EFD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            lapangan.imageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    lapangan.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 120),
                  ),
                )
                : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image, size: 80),
                ),
            const SizedBox(height: 20),
            Text(
              lapangan.name ?? "Tanpa Nama",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Harga: Rp ${lapangan.pricePerHour ?? "-"} / jam',
              style: const TextStyle(fontSize: 16, fontFamily: 'Gilroy'),
            ),
          ],
        ),
      ),
    );
  }
}
