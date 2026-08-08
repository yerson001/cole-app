class FeeModel {
  final int id;
  final String? paymentDate;
  final double amount;
  final String? notes;
  final List<FeePaymentItemModel> paymentItems;

  FeeModel({
    required this.id,
    this.paymentDate,
    required this.amount,
    this.notes,
    this.paymentItems = const [],
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) => FeeModel(
    id: json['id'] as int,
    paymentDate: json['paymentDate'] as String?,
    amount: (json['amount'] as num).toDouble(),
    notes: json['notes'] as String?,
    paymentItems: (json['paymentItems'] as List? ?? const [])
        .map((e) => FeePaymentItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class FeePaymentItemModel {
  final int id;
  final bool isPaid;
  final FeeStudentModel? student;
  final String? updatedAt;
  final String? createdAt;

  FeePaymentItemModel({
    required this.id,
    required this.isPaid,
    this.student,
    this.updatedAt,
    this.createdAt,
  });

  factory FeePaymentItemModel.fromJson(Map<String, dynamic> json) =>
      FeePaymentItemModel(
        id: json['id'] as int,
        isPaid: json['isPaid'] as bool? ?? false,
        student: json['student'] != null
            ? FeeStudentModel.fromJson(json['student'] as Map<String, dynamic>)
            : null,
        updatedAt: json['updatedAt'] as String?,
        createdAt: json['createdAt'] as String?,
      );
}

class FeeStudentModel {
  final int id;
  final String name;
  final String lastName;

  FeeStudentModel({
    required this.id,
    required this.name,
    required this.lastName,
  });

  factory FeeStudentModel.fromJson(Map<String, dynamic> json) =>
      FeeStudentModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
      );
}
