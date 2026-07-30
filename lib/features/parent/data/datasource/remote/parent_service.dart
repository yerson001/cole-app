import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';

class ParentService {
  final http.Client _client;

  ParentService({http.Client? client}) : _client = client ?? http.Client();

  Future<BranchModel> getBranch(int id, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/branch/$id');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      return BranchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener branch: ${response.statusCode}');
  }
}
