import 'dart:convert';
import 'dart:io';
import 'package:flutter_task_15/project_15/Helper/endpoint.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_add.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_get.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_update.dart';
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

  Future<AddLapangan> tambahLapangan({
  required String name,
  required int pricePerHour,
  File? imageFile,
}) async {
  final token = await SharedPref.getToken();
  final uri = Uri.parse(Endpoint.add);

  var request = http.MultipartRequest('POST', uri);
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  request.fields['name'] = name;
  request.fields['price_per_hour'] = pricePerHour.toString();

  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );
  }

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Gagal tambah lapangan. Status: ${response.statusCode}');
  }

  try {
    final json = jsonDecode(response.body);
    return AddLapangan.fromJson(json);
  } catch (e) {
    print('Error parsing JSON: $e');
    throw Exception('Gagal mengurai data dari server');
  }
}


  Future<List<GetL>> getLapangan() async {
    final token = await SharedPref.getToken();
    final response = await http.get(Uri.parse(Endpoint.fields), headers: {'Accept': 'application/json','Authorization':'Bearer $token'});
    return GetLapangan.fromJson(jsonDecode(response.body)).data ?? [];
  }

  Future<Update> updateProfile({required String name, required int price}) async {
  final token = await SharedPref.getToken();

  final response = await http.put(
    Uri.parse(Endpoint.update),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: {
      'name': name,
      'price': price.toString(), 
    },
  );

  if (response.statusCode == 200) {
    return UpdateLapangan.fromJson(jsonDecode(response.body)).data!;
  } else {
    throw Exception("Gagal update: ${response.statusCode}");
  }
}

}
