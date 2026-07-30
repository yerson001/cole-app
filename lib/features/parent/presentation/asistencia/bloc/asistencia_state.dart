import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

class AsistenciaState extends Equatable {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final StudentModel? selectedStudent;
  final List<StudentModel> students;
  final List<DayReportModel> dailyReports;
  final List<DayReportModel> rangeReports;
  final bool isLoadingDaily;
  final bool isLoadingRange;
  final String tenant;
  final int branchId;

  const AsistenciaState({
    required this.selectedDate,
    required this.currentMonth,
    this.selectedStudent,
    this.students = const [],
    this.dailyReports = const [],
    this.rangeReports = const [],
    this.isLoadingDaily = false,
    this.isLoadingRange = false,
    this.tenant = '',
    this.branchId = 1,
  });

  AsistenciaState copyWith({
    DateTime? selectedDate,
    DateTime? currentMonth,
    StudentModel? selectedStudent,
    List<StudentModel>? students,
    List<DayReportModel>? dailyReports,
    List<DayReportModel>? rangeReports,
    bool? isLoadingDaily,
    bool? isLoadingRange,
    String? tenant,
    int? branchId,
  }) {
    return AsistenciaState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      students: students ?? this.students,
      dailyReports: dailyReports ?? this.dailyReports,
      rangeReports: rangeReports ?? this.rangeReports,
      isLoadingDaily: isLoadingDaily ?? this.isLoadingDaily,
      isLoadingRange: isLoadingRange ?? this.isLoadingRange,
      tenant: tenant ?? this.tenant,
      branchId: branchId ?? this.branchId,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    currentMonth,
    selectedStudent,
    students,
    dailyReports,
    rangeReports,
    isLoadingDaily,
    isLoadingRange,
    tenant,
    branchId,
  ];
}
