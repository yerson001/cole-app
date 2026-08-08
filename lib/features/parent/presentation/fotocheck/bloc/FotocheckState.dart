import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

enum PhotocheckTemplate { photocheck, sticker }

class FotocheckState extends Equatable {
  final StudentModel? selectedStudent;
  final int? tenantId;
  final int? branchId;
  final String? prefix;
  final String? qrData;
  final PhotocheckTemplate template;
  final bool isLoading;
  final String? error;

  const FotocheckState({
    this.selectedStudent,
    this.tenantId,
    this.branchId,
    this.prefix,
    this.qrData,
    this.template = PhotocheckTemplate.photocheck,
    this.isLoading = false,
    this.error,
  });

  FotocheckState copyWith({
    StudentModel? selectedStudent,
    int? tenantId,
    int? branchId,
    String? prefix,
    String? qrData,
    PhotocheckTemplate? template,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FotocheckState(
      selectedStudent: selectedStudent ?? this.selectedStudent,
      tenantId: tenantId ?? this.tenantId,
      branchId: branchId ?? this.branchId,
      prefix: prefix ?? this.prefix,
      qrData: qrData ?? this.qrData,
      template: template ?? this.template,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [selectedStudent, tenantId, branchId, prefix, qrData, template, isLoading, error];
}
