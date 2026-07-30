class StudentFeeModel {
  final int id;
  final int schoolYear;
  final double amount;

  StudentFeeModel({
    required this.id,
    required this.schoolYear,
    required this.amount,
  });

  factory StudentFeeModel.fromJson(Map<String, dynamic> json) => StudentFeeModel(
    id: json['id'] as int,
    schoolYear: json['schoolYear'] as int,
    amount: (json['amount'] as num).toDouble(),
  );
}

class MonthlyPaymentModel {
  final int id;
  final int month;
  final double amount;
  final bool isPaid;
  final String? paymentDate;

  MonthlyPaymentModel({
    required this.id,
    required this.month,
    required this.amount,
    required this.isPaid,
    this.paymentDate,
  });

  factory MonthlyPaymentModel.fromJson(Map<String, dynamic> json) => MonthlyPaymentModel(
    id: json['id'] as int,
    month: json['month'] as int,
    amount: (json['amount'] as num).toDouble(),
    isPaid: json['isPaid'] as bool,
    paymentDate: json['paymentDate'] as String?,
  );
}
