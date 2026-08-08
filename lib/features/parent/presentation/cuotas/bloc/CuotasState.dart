import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

class CuotasState extends Equatable {
  final StudentModel? selectedStudent;
  final List<FeeModel> fees;
  final bool isLoading;
  final String? error;
  final String tenantId;

  const CuotasState({
    this.selectedStudent,
    this.fees = const [],
    this.isLoading = false,
    this.error,
    this.tenantId = '',
  });

  CuotasState copyWith({
    StudentModel? selectedStudent,
    List<FeeModel>? fees,
    bool? isLoading,
    String? error,
    String? tenantId,
    bool clearError = false,
  }) {
    return CuotasState(
      selectedStudent: selectedStudent ?? this.selectedStudent,
      fees: fees ?? this.fees,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
    );
  }

  @override
  List<Object?> get props => [selectedStudent, fees, isLoading, error, tenantId];
}
