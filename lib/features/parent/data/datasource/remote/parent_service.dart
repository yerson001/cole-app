import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

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

  Future<List<StudentModel>> getStudentsByParent(int parentId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/parents/get-students-by-parent/$parentId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => StudentModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener estudiantes: ${response.statusCode}');
  }

  Future<List<DayReportModel>> getDayReport({
    required String date,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  }) async {
    final reports = <DayReportModel>[];
    for (final studentId in studentIds) {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/attendance/day-report?date=$date&branchId=$branchId&studentId=$studentId',
      );
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'tenant-id': tenantId,
        },
      );
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        reports.addAll(list.map((e) => DayReportModel.fromJson(e as Map<String, dynamic>)));
      }
    }
    if (reports.isEmpty) {
      throw Exception('Error al obtener reporte diario');
    }
    return reports;
  }
}
