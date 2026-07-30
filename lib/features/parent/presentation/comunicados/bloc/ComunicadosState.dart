import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';

class ComunicadosState extends Equatable {
  final List<AgendaItemModel> comunicados;
  final bool isLoading;
  final String? error;
  final int? selectedStudentId;
  final String tenantId;
  final int? parentId;

  const ComunicadosState({
    this.comunicados = const [],
    this.isLoading = false,
    this.error,
    this.selectedStudentId,
    this.tenantId = '',
    this.parentId,
  });

  ComunicadosState copyWith({
    List<AgendaItemModel>? comunicados,
    bool? isLoading,
    String? error,
    int? selectedStudentId,
    String? tenantId,
    int? parentId,
    bool clearError = false,
  }) {
    return ComunicadosState(
      comunicados: comunicados ?? this.comunicados,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedStudentId: selectedStudentId ?? this.selectedStudentId,
      tenantId: tenantId ?? this.tenantId,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  List<Object?> get props => [
    comunicados,
    isLoading,
    error,
    selectedStudentId,
    tenantId,
    parentId,
  ];
}
