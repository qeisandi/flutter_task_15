import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/model/model_sc_get.dart';
import 'package:futsal_56/project_15/Helper/servis/get_sc.dart';

class DetailLapanganPageDua extends StatefulWidget {
  final GetL lapangan;

  const DetailLapanganPageDua({super.key, required this.lapangan});

  @override
  State<DetailLapanganPageDua> createState() => _DetailLapanganPageDuaState();
}

class _DetailLapanganPageDuaState extends State<DetailLapanganPageDua> {
  late Future<List<Schedule>> _futureSchedules;
  final GetScServis getScServis = GetScServis();
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _futureSchedules = getScServis.getSchedulesByField(widget.lapangan.id!);
    _futureSchedules.then((data) {
      setState(() {
        _schedules = data;
      });
    });
  }

  void toggleBookingStatus(int index) {
    setState(() {
      final current = _schedules[index];
      _schedules[index] = Schedule(
        id: current.id,
        fieldId: current.fieldId,
        date: current.date,
        startTime: current.startTime,
        endTime: current.endTime,
        isBooked: current.isBooked == 1 ? 0 : 1,
        createdAt: current.createdAt,
        updatedAt: current.updatedAt,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          widget.lapangan.name ?? 'Detail Lapangan',
          style: const TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        ),
        backgroundColor: const Color(0xff039EFD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            widget.lapangan.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.lapangan.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
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
              widget.lapangan.name ?? "Tanpa Nama",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Harga: Rp ${widget.lapangan.pricePerHour ?? "-"} / jam',
              style: const TextStyle(fontSize: 16, fontFamily: 'Gilroy'),
            ),
            const SizedBox(height: 24),
            const Text(
              "Jadwal Tersedia",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),
            const SizedBox(height: 12),
            _schedules.isEmpty
                ? FutureBuilder<List<Schedule>>(
                    future: _futureSchedules,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Gagal memuat jadwal: ${snapshot.error}");
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return const Text("Belum ada jadwal tersedia.");
                      }

                      _schedules = snapshot.data!;
                      return buildScheduleList();
                    },
                  )
                : buildScheduleList(),
          ],
        ),
      ),
    );
  }

  Widget buildScheduleList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _schedules.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final sch = _schedules[index];
        final isBooked = sch.isBooked == 1;

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SwitchListTile(
            value: !isBooked,
            onChanged: (_) => toggleBookingStatus(index),
            title: Text(
              '${sch.date} | ${sch.startTime} - ${sch.endTime}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Gilroy',
              ),
            ),
            subtitle: Text(
              isBooked ? 'Sudah dibooking' : 'Tersedia',
              style: TextStyle(
                color: isBooked ? Colors.red : Colors.green,
                fontSize: 13,
              ),
            ),
            secondary: Icon(
              isBooked ? Icons.close : Icons.check_circle,
              color: isBooked ? Colors.red : Colors.green,
            ),
          ),
        );
      },
    );
  }
}
