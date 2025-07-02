import 'dart:convert';
import 'dart:io';

import 'package:futsal_56/project_15/Helper/endpoint.dart';
import 'package:futsal_56/project_15/Helper/model/model_add.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/model/model_update.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class UserServis {
  Future<Map<String, dynamic>> regisUser({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.register),
        headers: {"Accept": "application/json"},
        body: {"name": name, "email": email, "password": password},
      );

      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } catch (e) {
      throw Exception("Gagal register: $e");
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.login),
        headers: {"Accept": "application/json"},
        body: {"email": email, "password": password},
      );

      if (response.statusCode != 200) {
        throw Exception('Login gagal. Status code: ${response.statusCode}');
      }

      final jsonBody = jsonDecode(response.body);

      final token = jsonBody["data"]?["token"];
      if (token != null) {
        await SharedPref.saveToken(token);
      }

      return jsonBody;
    } catch (e) {
      throw Exception("Gagal login: $e");
    }
  }

  Future<AddLapangan> tambahLapangan({
    required String name,
    required int pricePerHour,
    File? imageFile,
  }) async {
    try {
      final token = await SharedPref.getToken();
      final uri = Uri.parse(Endpoint.add);

      String? base64Image;
      String? imageName;

      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        base64Image = base64Encode(bytes);
        imageName = imageFile.path.split("/").last;
      }

      final body = {
        "name": name,
        "price_per_hour": pricePerHour,
        if (base64Image != null && imageName != null) ...{
          "image_base64": base64Image,
          "image_name": imageName,
        },
      };

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal tambah lapangan. Status: ${response.statusCode}',
        );
      }

      final json = jsonDecode(response.body);
      return AddLapangan.fromJson(json);
    } catch (e) {
      throw Exception("Tambah lapangan gagal: $e");
    }
  }

  Future<List<GetL>> getLapangan() async {
    try {
      final token = await SharedPref.getToken();
      final response = await http.get(
        Uri.parse(Endpoint.fields),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil lapangan. Status: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);
      return GetLapangan.fromJson(data).data ?? [];
    } catch (e) {
      throw Exception("Get lapangan gagal: $e");
    }
  }

  Future<Update> updateLapangan({
    required int id,
    required String name,
    required int price,
  }) async {
    try {
      final token = await SharedPref.getToken();

      final response = await http.put(
        Uri.parse(Endpoint.update(id)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'price': price}),
      );

      if (response.statusCode != 200) {
        throw Exception("Gagal update: ${response.statusCode}");
      }

      return UpdateLapangan.fromJson(jsonDecode(response.body)).data!;
    } catch (e) {
      throw Exception("Update lapangan gagal: $e");
    }
  }

  Future<bool> deleteLapangan(int id) async {
    try {
      final token = await SharedPref.getToken();

      final response = await http.delete(
        Uri.parse(Endpoint.update(id)),
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

  Future<Map<String, dynamic>> bookSchedule(int scheduleId) async {
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
          'Gagal booking: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat booking: $e');
    }
  }
}
