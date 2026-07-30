import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_state.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/child_selector.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/daily_attendance_card.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/historial_reciente.dart';

class AsistenciaDiariaTab extends StatelessWidget {
  const AsistenciaDiariaTab({super.key});

  String _formatFullDate(DateTime date) {
    final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  List<DateTime> _recentSchoolDays(DateTime from) {
    final days = <DateTime>[];
    var current = from.subtract(const Duration(days: 1));
    while (days.length < 5) {
      if (current.weekday == DateTime.saturday || current.weekday == DateTime.sunday) {
        break;
      }
      days.add(current);
      current = current.subtract(const Duration(days: 1));
    }
    return days;
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        context.read<AsistenciaBloc>().add(
                          ChangeDate(date: state.selectedDate.subtract(const Duration(days: 1))),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        _formatFullDate(state.selectedDate),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        context.read<AsistenciaBloc>().add(
                          ChangeDate(date: state.selectedDate.add(const Duration(days: 1))),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ChildSelector(
                  students: state.students,
                  selectedStudent: state.selectedStudent,
                  onChanged: (s) => context.read<AsistenciaBloc>().add(SelectStudent(student: s)),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: state.isLoadingDaily ? null : () {
                      context.read<AsistenciaBloc>().add(ReloadAll());
                    },
                    icon: state.isLoadingDaily
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh),
                    label: const Text('Recargar'),
                  ),
                ),
                const SizedBox(height: 16),
                if (state.dailyReports.isNotEmpty)
                  DailyAttendanceCard(report: state.dailyReports.first, index: state.students.indexOf(state.selectedStudent!))
                else
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Sin datos para este día')),
                    ),
                  ),
                const SizedBox(height: 24),
                HistorialReciente(
                  reports: state.rangeReports,
                  days: _recentSchoolDays(state.selectedDate),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
