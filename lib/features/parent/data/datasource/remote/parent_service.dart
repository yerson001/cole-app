import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/parent/data/models/agenda_detail_model.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/data/models/pension_model.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
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

  Future<List<DayReportModel>> getAttendanceInRange({
    required String startDate,
    required String endDate,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  }) async {
    final reports = <DayReportModel>[];
    for (final studentId in studentIds) {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/attendance/in-range?startDate=$startDate&endDate=$endDate&search=&branchId=$branchId&studentId=$studentId',
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
    return reports;
  }

  Future<List<ParentMeetingModel>> getMeetingsByParent(int parentId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/parent-meeting-attendance/get-all-by-parent/$parentId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => ParentMeetingModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener reuniones: ${response.statusCode}');
  }

  Future<void> checkInMeetingByParent({required int parentId, required int meetingId, required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/parent-meeting-attendance/check-in-by-parent');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
      body: jsonEncode({'parentId': parentId, 'meetingId': meetingId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al marcar ingreso: ${response.statusCode}');
    }
  }

  Future<void> checkOutMeetingByParent({required int parentId, required int meetingId, required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/parent-meeting-attendance/check-out-by-parent');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
      body: jsonEncode({'parentId': parentId, 'meetingId': meetingId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al marcar salida: ${response.statusCode}');
    }
  }

  Future<AgendaModel> getAgendaByParent({
    required int parentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/virtual-agenda/parent/$parentId?startDate=$startDate&endDate=$endDate',
    );
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      return AgendaModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Error al obtener agenda: ${response.statusCode}');
  }

  Future<AgendaModel> getAgendaByStudent({
    required int studentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/virtual-agenda/student/$studentId?startDate=$startDate&endDate=$endDate',
    );
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      return AgendaModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Error al obtener agenda: ${response.statusCode}');
  }

  Future<void> markAgendaItemAsRead({required int itemId, required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/virtual-agenda/items/$itemId/read');
    final response = await _client.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
      body: jsonEncode({}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al marcar como leído: ${response.statusCode}');
    }
  }

  Future<HomeworkDetailModel> getHomeworkDetail(int homeworkId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/homework/$homeworkId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      return HomeworkDetailModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Error al obtener tarea: ${response.statusCode}');
  }

  Future<AnnouncementDetailModel> getAnnouncementDetail(int announcementId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/announcements/$announcementId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      return AnnouncementDetailModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Error al obtener aviso: ${response.statusCode}');
  }

  Future<ObservationDetailModel> getObservationDetail(int observationId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/student-observations/$observationId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      return ObservationDetailModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Error al obtener observación: ${response.statusCode}');
  }

  Future<List<ScheduleModel>> getScheduleBySectionId(int sectionId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/schedule/section/$sectionId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener horario: ${response.statusCode}');
  }

  Future<List<StudentGradeModel>> getStudentGradesByStudent(int studentId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/student-assessment/by-student/$studentId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => StudentGradeModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener calificaciones: ${response.statusCode}');
  }

  Future<List<StudentFeeModel>> getStudentFeesByStudent(int studentId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/student-fees/student/$studentId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => StudentFeeModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener pensiones: ${response.statusCode}');
  }

  Future<List<MonthlyPaymentModel>> getMonthlyPaymentsByStudent(int studentId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/monthly-payments/student/$studentId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => MonthlyPaymentModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener pagos de pensiones: ${response.statusCode}');
  }

  Future<List<FeeModel>> getFeesByStudent(int studentId, {required String tenantId}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/payments/student/$studentId');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantId,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => FeeModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener cuotas: ${response.statusCode}');
  }

  Future<int?> getTenantIdByKey(String tenantKey) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/tenants');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenantKey,
      },
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        if (map['tenantKey'] == tenantKey) {
          return int.tryParse(map['id'].toString());
        }
      }
      return null;
    }
    throw Exception('Error al obtener tenants: ${response.statusCode}');
  }
}
