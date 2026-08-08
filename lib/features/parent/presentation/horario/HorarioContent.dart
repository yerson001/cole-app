import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/horario/bloc/HorarioBloc.dart';
import 'package:coleapp/features/parent/presentation/horario/bloc/HorarioEvent.dart';
import 'package:coleapp/features/parent/presentation/horario/bloc/HorarioState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/injection.dart';

class HorarioContent extends StatelessWidget {
  const HorarioContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HorarioBloc>(
      create: (_) => HorarioBloc(locator<ParentUseCases>()),
      child: const _HorarioBody(),
    );
  }
}

class _HorarioBody extends StatefulWidget {
  const _HorarioBody();

  @override
  State<_HorarioBody> createState() => _HorarioBodyState();
}

class _HorarioBodyState extends State<_HorarioBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final tenantId = state.tenant;
    if (state.students.isNotEmpty && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      context.read<HorarioBloc>().add(LoadHorario(
        student: state.students.first,
        tenantId: tenantId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentState = context.watch<ParentHomeBloc>().state;
    _tryInitialize(parentState);

    return BlocListener<ParentHomeBloc, ParentHomeState>(
      listenWhen: (previous, current) =>
        previous.tenant != current.tenant ||
        previous.students.length != current.students.length,
      listener: (context, state) => _tryInitialize(state),
      child: BlocBuilder<HorarioBloc, HorarioState>(
        builder: (context, state) {
          final tenantId = parentState.tenant;

          if (parentState.students.isEmpty) {
            return const Center(child: Text('No hay hijos registrados'));
          }

          if (state.isLoading && state.schedule.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (state.selectedStudent != null) {
                context.read<HorarioBloc>().add(LoadHorario(
                  student: state.selectedStudent!,
                  tenantId: tenantId,
                ));
              }
            },
            child: Column(
              children: [
                _StudentSelector(
                  students: parentState.students,
                  selectedStudent: state.selectedStudent,
                ),
                Expanded(
                  child: state.schedule.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          const Center(
                            child: Text(
                              'No hay horario disponible',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.scheduleByDay.keys.length,
                        itemBuilder: (context, index) {
                          final day = state.scheduleByDay.keys.toList()[index];
                          final items = state.scheduleByDay[day]!;
                          return _DaySection(day: day, items: items);
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
}

class _StudentSelector extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel? selectedStudent;

  const _StudentSelector({
    required this.students,
    this.selectedStudent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DropdownButtonFormField<StudentModel>(
        value: selectedStudent,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Hijo',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: students.map((s) => DropdownMenuItem(
          value: s,
          child: Text(
            '${s.name} ${s.lastName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        )).toList(),
        onChanged: (student) {
          if (student != null) {
            context.read<HorarioBloc>().add(SelectStudent(student: student));
          }
        },
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final int day;
  final List<ScheduleModel> items;

  const _DaySection({required this.day, required this.items});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            _dayName(day),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ac.primary,
            ),
          ),
        ),
        ...items.map((item) => _ScheduleItemCard(item: item)),
        const SizedBox(height: 16),
      ],
    );
  }

  String _dayName(int day) {
    const names = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    if (day >= 1 && day <= 7) return names[day - 1];
    return 'Día $day';
  }
}

class _ScheduleItemCard extends StatelessWidget {
  final ScheduleModel item;

  const _ScheduleItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: ac.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.startTime.substring(0, 5),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ac.primary,
                    ),
                  ),
                  Text(
                    item.endTime.substring(0, 5),
                    style: TextStyle(
                      fontSize: 11,
                      color: ac.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.courseName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prof. ${item.teacherName}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sección: ${item.sectionName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
