import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_state.dart';
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/historial_reciente.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_card.dart';

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
    final ac = context.appColors;
    return BlocBuilder<AsistenciaBloc, AsistenciaState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<AsistenciaBloc>().add(ReloadAll());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChildSelector(
                  students: state.students,
                  selectedStudent: state.selectedStudent,
                  onChanged: (s) {
                    if (s != null) {
                      context.read<AsistenciaBloc>().add(SelectStudent(student: s));
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: ac.fill,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ac.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: ac.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.chevron_left, size: 22),
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
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ac.textPrimary),
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: ac.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.chevron_right, size: 22),
                        onPressed: () {
                          context.read<AsistenciaBloc>().add(
                            ChangeDate(date: state.selectedDate.add(const Duration(days: 1))),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (state.dailyReports.isNotEmpty)
                  AttendanceCard(report: state.dailyReports.first, index: state.students.indexOf(state.selectedStudent!))
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: ac.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ac.border),
                    ),
                    child: Center(
                      child: Text('Sin datos para este día', style: TextStyle(fontSize: 14, color: ac.textSecondary)),
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
