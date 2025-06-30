import 'dart:convert';

import 'package:flutter_task_15/project_15/Helper/endpoint.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_sc.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class ScheduleServis {
  Future<AddScheduleResponse> addSchedule({
    required int fieldId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final token = await SharedPref.getToken();

    final response = await http.post(
      Uri.parse(Endpoint.addSchedule),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'field_id': fieldId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );

    final json = jsonDecode(response.body);
    return AddScheduleResponse.fromJson(json);
  }
}
