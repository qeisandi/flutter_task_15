import 'dart:convert';
import 'dart:io';

import 'package:flutter_task_15/project_15/Helper/endpoint.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_add.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_eror.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_get.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_regis.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class UserServis {
  Future<Map<String, dynamic>> regisUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Maaf Tidak Bisa Register User: ${response.statusCode}");
      throw Exception("Gagal Untuk register User: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Maaf Tidak Bisa Register User: ${response.statusCode}");
      throw Exception("Gagal Untuk register User: ${response.statusCode}");
    }
  }

  Future<AddLapangan> tambahLapangan({
    required String name,
    required int pricePerHour,
    File? imageFile,
  }) async {
    final token = await SharedPref.getToken();
    final uri = Uri.parse(Endpoint.add);

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['price_per_hour'] = pricePerHour.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddLapangan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Terjadi kesalahan: ${response.body}');
    }
  }

  Future<List<GetL>> getLapangan() async {
    final token = await SharedPref.getToken();

    if (token == null) {
      throw Exception('Token tidak di temukan. Login terlebih dahulu');
    }

    final response = await http.get(
      Uri.parse('https://appfutsal.mobileprojp.com/api/fields'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final getprofile = GetLapangan.fromJson(jsonResponse);
      return getprofile.data!;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
