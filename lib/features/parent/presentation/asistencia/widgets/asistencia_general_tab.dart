import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_state.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/attendance_calendar.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/attendance_summary.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/child_selector.dart';

class AsistenciaGeneralTab extends StatelessWidget {
  const AsistenciaGeneralTab({super.key});

  String _monthLabel(DateTime month) {
    final names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return '${names[month.month - 1]} ${month.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AsistenciaBloc, AsistenciaState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<AsistenciaBloc>().add(ReloadAll());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChildSelector(
                  students: state.students,
                  selectedStudent: state.selectedStudent,
                  onChanged: (s) => context.read<AsistenciaBloc>().add(SelectStudent(student: s)),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: state.isLoadingRange ? null : () {
                      context.read<AsistenciaBloc>().add(ReloadAll());
                    },
                    icon: state.isLoadingRange
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh),
                    label: const Text('Recargar'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        context.read<AsistenciaBloc>().add(
                          ChangeMonth(month: DateTime(state.currentMonth.year, state.currentMonth.month - 1)),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        _monthLabel(state.currentMonth),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        context.read<AsistenciaBloc>().add(
                          ChangeMonth(month: DateTime(state.currentMonth.year, state.currentMonth.month + 1)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AttendanceCalendar(
                      month: state.currentMonth,
                      reports: state.rangeReports,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AttendanceSummary(reports: state.rangeReports),
              ],
            ),
          ),
        );
      },
    );
  }
}
