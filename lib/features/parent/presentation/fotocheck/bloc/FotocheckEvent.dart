import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/bloc/FotocheckState.dart';

class FotocheckEvent extends Equatable {
  const FotocheckEvent();

  @override
  List<Object?> get props => const [];
}

class LoadFotocheck extends FotocheckEvent {
  final String tenantKey;
  final int branchId;
  final StudentModel student;

  const LoadFotocheck({
    required this.tenantKey,
    required this.branchId,
    required this.student,
  });

  @override
  List<Object?> get props => [tenantKey, branchId, student];
}

class SelectStudent extends FotocheckEvent {
  final StudentModel student;

  const SelectStudent({required this.student});

  @override
  List<Object?> get props => [student];
}

class ChangeTemplate extends FotocheckEvent {
  final PhotocheckTemplate template;

  const ChangeTemplate({required this.template});

  @override
  List<Object?> get props => [template];
}
