import 'dart:convert';

import 'package:flutter_task_15/project_15/Helper/endpoint.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_eror.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_get.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_regis.dart';
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

  Future<List<Lapangan>> getLapangan() async {
    final url = Uri.parse('https://appfutsal.mobileprojp.com/api/fields');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final welcome = GetLapangan.fromJson(jsonResponse);
        return welcome.data ?? [];
      } else {
        throw Exception('Failed to load anime: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching lapangan data: $e');
    }
  }
}
