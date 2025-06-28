import 'dart:convert';
import 'dart:io';
import 'package:flutter_task_15/project_15/Helper/endpoint.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_add.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_get.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref_api.dart';
import 'package:http/http.dart' as http;

class UserServis {
  Future<Map<String, dynamic>> regisUser({required String email, required String name, required String password}) async {
    final response = await http.post(Uri.parse(Endpoint.register), headers: {"Accept": "application/json"}, body: {"name": name, "email": email, "password": password});
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> loginUser({required String email, required String password}) async {
    final response = await http.post(Uri.parse(Endpoint.login), headers: {"Accept": "application/json"}, body: {"email": email, "password": password});
    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonBody["data"]?["token"] != null) {
      await SharedPref.saveToken(jsonBody["data"]["token"]);
    }
    return jsonBody;
  }

  Future<AddLapangan> tambahLapangan({required String name, required int pricePerHour, File? imageFile}) async {
    final token = await SharedPref.getToken();
    var request = http.MultipartRequest('POST', Uri.parse(Endpoint.add));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['price_per_hour'] = pricePerHour.toString();

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final response = await http.Response.fromStream(await request.send());
    return AddLapangan.fromJson(jsonDecode(response.body));
  }

  Future<List<GetL>> getLapangan() async {
    final token = await SharedPref.getToken();
    final response = await http.get(Uri.parse(Endpoint.fields), headers: {'Accept': 'application/json','Authorization':'Bearer $token'});
    return GetLapangan.fromJson(jsonDecode(response.body)).data ?? [];
  }
}
