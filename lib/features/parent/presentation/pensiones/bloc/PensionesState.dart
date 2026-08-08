import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/pension_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

const List<String> monthNames = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

class PensionesState extends Equatable {
  final StudentModel? selectedStudent;
  final List<StudentFeeModel> fees;
  final List<MonthlyPaymentModel> payments;
  final bool isLoading;
  final String? error;
  final String tenantId;

  const PensionesState({
    this.selectedStudent,
    this.fees = const [],
    this.payments = const [],
    this.isLoading = false,
    this.error,
    this.tenantId = '',
  });

  PensionesState copyWith({
    StudentModel? selectedStudent,
    List<StudentFeeModel>? fees,
    List<MonthlyPaymentModel>? payments,
    bool? isLoading,
    String? error,
    String? tenantId,
    bool clearError = false,
  }) {
    return PensionesState(
      selectedStudent: selectedStudent ?? this.selectedStudent,
      fees: fees ?? this.fees,
      payments: payments ?? this.payments,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
    );
  }

  double get monthlyAmount {
    if (fees.isEmpty) return 0;
    return fees.first.amount;
  }

  List<PensionMonthRow> get months {
    final paidByMonth = <int, MonthlyPaymentModel>{};
    for (final payment in payments) {
      paidByMonth[payment.month] = payment;
    }
    final rows = <PensionMonthRow>[];
    for (var i = 1; i <= 12; i++) {
      final paid = paidByMonth[i];
      rows.add(PensionMonthRow(
        number: i,
        name: monthNames[i - 1],
        debt: monthlyAmount,
        payment: paid?.amount,
        isPaid: paid?.isPaid ?? false,
        paymentDate: paid?.paymentDate,
      ));
    }
    return rows;
  }

  @override
  List<Object?> get props => [selectedStudent, fees, payments, isLoading, error, tenantId];
}

class PensionMonthRow {
  final int number;
  final String name;
  final double debt;
  final double? payment;
  final bool isPaid;
  final String? paymentDate;

  PensionMonthRow({
    required this.number,
    required this.name,
    required this.debt,
    this.payment,
    required this.isPaid,
    this.paymentDate,
  });
}
