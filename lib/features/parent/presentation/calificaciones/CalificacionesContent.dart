import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/bloc/CalificacionesBloc.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/bloc/CalificacionesEvent.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/bloc/CalificacionesState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/injection.dart';

class CalificacionesContent extends StatelessWidget {
  const CalificacionesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalificacionesBloc>(
      create: (_) => CalificacionesBloc(locator<ParentUseCases>()),
      child: const _CalificacionesBody(),
    );
  }
}

class _CalificacionesBody extends StatefulWidget {
  const _CalificacionesBody();

  @override
  State<_CalificacionesBody> createState() => _CalificacionesBodyState();
}

class _CalificacionesBodyState extends State<_CalificacionesBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final tenantId = state.tenant;
    if (state.students.isNotEmpty && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      context.read<CalificacionesBloc>().add(LoadCalificaciones(
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
      child: BlocBuilder<CalificacionesBloc, CalificacionesState>(
        builder: (context, state) {
          final tenantId = parentState.tenant;

          if (parentState.students.isEmpty) {
            return const Center(child: Text('No hay hijos registrados'));
          }

          if (state.isLoading && state.grades.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (state.selectedStudent != null) {
                context.read<CalificacionesBloc>().add(LoadCalificaciones(
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
                  child: state.grades.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          const Center(
                            child: Text(
                              'No hay calificaciones registradas',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.gradesByCourse.length,
                        itemBuilder: (context, index) {
                          final course = state.gradesByCourse.values.toList()[index];
                          return _CourseCard(course: course);
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
            context.read<CalificacionesBloc>().add(SelectStudent(student: student));
          }
        },
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseGrades course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    course.courseName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ac.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Prom: ${course.totalScore.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: ac.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...course.sets.values.map((set) => _SetSection(set: set)),
          ],
        ),
      ),
    );
  }
}

class _SetSection extends StatelessWidget {
  final SetGrades set;

  const _SetSection({required this.set});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  set.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${set.percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...set.grades.map((grade) => _GradeRow(grade: grade)),
        ],
      ),
    );
  }
}

class _GradeRow extends StatelessWidget {
  final StudentGradeModel grade;

  const _GradeRow({required this.grade});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              grade.definitionName,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            '${grade.score.toStringAsFixed(0)}/${grade.assessmentDefinition.maxScore.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ac.primary,
            ),
          ),
        ],
      ),
    );
  }
}
