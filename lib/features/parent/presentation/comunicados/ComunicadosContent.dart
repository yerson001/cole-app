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
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';
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
                    ? _EmptyState(
                        icon: Icons.campaign_outlined,
                        title: 'Para ti',
                        message: 'No hay comunicados aún.\nTe avisaremos cuando lleguen.',
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: comunicados.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 16,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
                        ),
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
    final today = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month + 1, 0);
    return (
      startDate: _formatDate(today),
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

    StudentModel? selected;
    for (final s in students) {
      if (s.id == selectedStudentId) {
        selected = s;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: ChildSelector(
        students: students,
        selectedStudent: selected,
        showAll: true,
        onChanged: (student) {
          context.read<ComunicadosBloc>().add(SelectStudent(studentId: student?.id));
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
        ? _formatShortDate(DateTime.tryParse(item.publishedAt!))
        : '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isRead ? ac.border : ac.primary.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ac.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ac.primary.withValues(alpha: 0.20)),
            ),
            alignment: Alignment.center,
            child: Icon(
              item.isRead ? Icons.campaign_outlined : Icons.campaign,
              size: 24,
              color: ac.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: ac.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                          color: ac.textPrimary,
                        ),
                      ),
                    ),
                    if (date.isNotEmpty)
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: ac.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: ac.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatShortDate(DateTime? date) {
    if (date == null) return '';
    const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.12),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: ac.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(color: ac.primary.withValues(alpha: 0.30)),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 32, color: ac.primary),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ac.textPrimary),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: ac.textSecondary.withValues(alpha: 0.8)),
          ),
        ),
      ],
    );
  }
}
