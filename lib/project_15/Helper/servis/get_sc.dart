import 'dart:convert';

import 'package:flutter_task_15/project_15/Helper/endpoint.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_sc_get.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class GetScServis {
  Future<List<Schedule>> getSchedulesByField(int fieldId) async {
    final token = await SharedPref.getToken();

    final response = await http.get(
      Uri.parse(Endpoint.schedulesByField(fieldId)),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> scheduleList = jsonData['data'];
      return scheduleList.map((json) => Schedule.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil jadwal lapangan: ${response.body}");
    }
  }
}
