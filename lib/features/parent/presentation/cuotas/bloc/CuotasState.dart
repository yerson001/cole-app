import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;

class CuotasState extends Equatable {
  final StudentModel? selectedStudent;
  final List<FeeModel> fees;
  final bool isLoading;
  final String? error;
  final String tenantId;
  final DateTime selectedDate;
  final AgendaView view;

  const CuotasState({
    this.selectedStudent,
    this.fees = const [],
    this.isLoading = false,
    this.error,
    this.tenantId = '',
    required this.selectedDate,
    this.view = AgendaView.daily,
  });

  CuotasState copyWith({
    StudentModel? selectedStudent,
    List<FeeModel>? fees,
    bool? isLoading,
    String? error,
    String? tenantId,
    DateTime? selectedDate,
    AgendaView? view,
    bool clearError = false,
  }) {
    return CuotasState(
      selectedStudent: selectedStudent ?? this.selectedStudent,
      fees: fees ?? this.fees,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
      selectedDate: selectedDate ?? this.selectedDate,
      view: view ?? this.view,
    );
  }

  List<FeeModel> feesOn(DateTime day) {
    return fees.where((fee) {
      final payment = DateTime.tryParse(fee.paymentDate ?? '');
      if (payment == null) return false;
      return payment.year == day.year &&
          payment.month == day.month &&
          payment.day == day.day;
    }).toList();
  }

  List<FeeModel> get feesForSelectedDate => feesOn(selectedDate);

  @override
  List<Object?> get props => [
    selectedStudent,
    fees,
    isLoading,
    error,
    tenantId,
    selectedDate,
    view,
  ];
}
