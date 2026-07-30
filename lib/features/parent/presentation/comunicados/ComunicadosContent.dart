import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosBloc.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosEvent.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/injection.dart';

class ComunicadosContent extends StatelessWidget {
  const ComunicadosContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComunicadosBloc>(
      create: (_) => ComunicadosBloc(locator<ParentUseCases>()),
      child: const _ComunicadosBody(),
    );
  }
}

class _ComunicadosBody extends StatefulWidget {
  const _ComunicadosBody();

  @override
  State<_ComunicadosBody> createState() => _ComunicadosBodyState();
}

class _ComunicadosBodyState extends State<_ComunicadosBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final parentId = state.user?.profile?.id;
    final tenantId = state.tenant;
    if (parentId != null && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      final now = DateTime.now();
      final range = _dateRangeForMonth(now);
      context.read<ComunicadosBloc>().add(LoadComunicados(
        parentId: parentId,
        tenantId: tenantId,
        startDate: range.startDate,
        endDate: range.endDate,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentState = context.watch<ParentHomeBloc>().state;
    _tryInitialize(parentState);

    return BlocListener<ParentHomeBloc, ParentHomeState>(
      listenWhen: (previous, current) =>
        previous.user?.profile?.id != current.user?.profile?.id ||
        previous.tenant != current.tenant ||
        previous.students.length != current.students.length,
      listener: (context, state) => _tryInitialize(state),
      child: BlocBuilder<ComunicadosBloc, ComunicadosState>(
        builder: (context, state) {
          final parentId = parentState.user?.profile?.id;
          final tenantId = parentState.tenant;

          if (parentId == null || tenantId.isEmpty) {
            return const Center(child: Text('No hay sesión de padre activa'));
          }

          if (state.isLoading && state.comunicados.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final comunicados = state.selectedStudentId == null
              ? state.comunicados
              : state.comunicados.where((c) => c.student?.id == state.selectedStudentId).toList();

          return RefreshIndicator(
            onRefresh: () async {
              final now = DateTime.now();
              final range = _dateRangeForMonth(now);
              context.read<ComunicadosBloc>().add(LoadComunicados(
                parentId: parentId,
                tenantId: tenantId,
                startDate: range.startDate,
                endDate: range.endDate,
                studentId: state.selectedStudentId,
              ));
            },
            child: Column(
              children: [
                _StudentSelector(
                  students: parentState.students,
                  selectedStudentId: state.selectedStudentId,
                ),
                Expanded(
                  child: comunicados.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          const Center(
                            child: Text(
                              'No hay comunicados',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: comunicados.length,
                        itemBuilder: (context, index) {
                          return _ComunicadoCard(item: comunicados[index]);
                        },
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ({String startDate, String endDate}) _dateRangeForMonth(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return (
      startDate: _formatDate(start),
      endDate: _formatDate(end),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _StudentSelector extends StatelessWidget {
  final List<StudentModel> students;
  final int? selectedStudentId;

  const _StudentSelector({
    required this.students,
    this.selectedStudentId,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DropdownButtonFormField<int?>(
        value: selectedStudentId,
        decoration: InputDecoration(
          labelText: 'Hijo',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem<int?>(
            value: null,
            child: Text('Todos mis hijos'),
          ),
          ...students.map((s) => DropdownMenuItem(
            value: s.id,
            child: Text('${s.name} ${s.lastName}'),
          )),
        ],
        onChanged: (studentId) {
          context.read<ComunicadosBloc>().add(SelectStudent(studentId: studentId));
        },
      ),
    );
  }
}

class _ComunicadoCard extends StatelessWidget {
  final AgendaItemModel item;

  const _ComunicadoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final date = item.publishedAt != null
        ? _formatDateTime(DateTime.parse(item.publishedAt!))
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green.withValues(alpha: 0.4), width: 1),
      ),
      child: InkWell(
        onTap: () {
          if (!item.isRead) {
            context.read<ComunicadosBloc>().add(MarkComunicadoAsRead(itemId: item.id));
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.campaign_outlined, color: ac.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ac.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: item.isRead ? FontWeight.normal : FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.sender.fullName,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (date != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    final month = months[date.month - 1];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} $month · $hour:$minute';
  }
}
