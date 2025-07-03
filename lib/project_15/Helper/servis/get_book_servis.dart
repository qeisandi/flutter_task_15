import 'dart:convert';

import 'package:futsal_56/project_15/Helper/endpoint.dart';
import 'package:futsal_56/project_15/Helper/model/model_get_book.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static Future<List<Booking>> getMyBookings() async {
    final token = await SharedPref.getToken();

    final response = await http.get(
      Uri.parse(Endpoint.myBookings),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> bookingList = data['data'];

      return bookingList.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data booking saya');
    }
  }

  Future<bool> cancelBooking(int id) async {
    try {
      final token = await SharedPref.getToken();

      final response = await http.delete(
        Uri.parse(Endpoint.delete(id)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Lapangan berhasil dihapus");
        return true;
      } else {
        print(
          "Gagal hapus lapangan: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Exception saat hapus lapangan: $e");
      return false;
    }
  }
}
