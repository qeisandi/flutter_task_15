import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/endpoint.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/model/model_sc_get.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class DetailLapanganPage extends StatefulWidget {
  final GetL lapangan;

  const DetailLapanganPage({super.key, required this.lapangan});

  @override
  State<DetailLapanganPage> createState() => _DetailLapanganPageState();
}

class _DetailLapanganPageState extends State<DetailLapanganPage> {
  List<Schedule> schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    try {
      final token = await SharedPref.getToken();

      final response = await http.get(
        Uri.parse(Endpoint.schedulesByField(widget.lapangan.id!)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> scheduleList = data['data'];
        setState(() {
          schedules = scheduleList.map((e) => Schedule.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil jadwal");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> bookNow(int scheduleId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final token = await SharedPref.getToken();

      final response = await http.post(
        Uri.parse(Endpoint.bookSchedule),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'schedule_id': scheduleId.toString()},
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Booking berhasil')),
        );
        fetchSchedules(); // Refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal booking: ${response.body}')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lapangan = widget.lapangan;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lapangan.name ?? "Detail Lapangan",
          style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
        ),
        backgroundColor: Color(0xff039EFD),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchSchedules,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    lapangan.imageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            lapangan.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.image, size: 80),
                        ),
                    SizedBox(height: 16),
                    Text(
                      lapangan.name ?? "Tanpa Nama",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Harga: Rp ${lapangan.pricePerHour ?? "-"} / jam',
                      style: TextStyle(fontSize: 16, fontFamily: 'Gilroy'),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Jadwal Tersedia:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    schedules.isEmpty
                        ? Text("Belum ada jadwal tersedia.")
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final sc = schedules[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(sc.date),
                                subtitle: Text(
                                  '${sc.startTime} - ${sc.endTime}',
                                ),
                                trailing:
                                    sc.isBooked == 1
                                        ? Text(
                                          'Terbooking',
                                          style: TextStyle(color: Colors.red),
                                        )
                                        : ElevatedButton(
                                          onPressed: () => bookNow(sc.id),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff039EFD),
                                          ),
                                          child: Text(
                                            'Booking',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
    );
  }
}
