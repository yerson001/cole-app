import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

const _avatarColors = [
  Color(0xFF225BAA),
  Color(0xFF2E7D32),
  Color(0xFFE65100),
  Color(0xFF6A1B9A),
  Color(0xFFC62828),
  Color(0xFF00838F),
];

class AttendanceCard extends StatelessWidget {
  final DayReportModel report;
  final int index;

  const AttendanceCard({super.key, required this.report, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final s = report.student;
    final a = report.attendances.isNotEmpty ? report.attendances.first : null;
    final avatarColor = _avatarColors[index % _avatarColors.length];
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: avatarColor.withValues(alpha: 0.1),
                    child: Icon(Icons.school, color: avatarColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(s.lastName,
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _badge(context, a?.updatedInClass ?? false),
                      const SizedBox(height: 4),
                      Text('${s.level.name} ${s.grade.name}${s.section.name}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _checkColumn('INGRESO', a?.checkInTime, a?.statusCheckIn),
                  _checkColumn('SALIDA', a?.checkOutTime, a?.statusCheckOut),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, bool updatedInClass) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: updatedInClass ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        updatedInClass ? 'Aula' : 'Puerta',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: updatedInClass ? Colors.green[700] : Colors.orange[700],
        ),
      ),
    );
  }

  Widget _checkColumn(String label, String? time, String? status) {
    final statusColor = _statusColor(status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          time != null ? time.substring(0, 5) : '--:--',
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _statusLabel(status),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: statusColor),
          ),
        ),
      ],
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'PRESENT': return Colors.green;
      case 'LATE': return Colors.orange;
      case 'ABSENT': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'PRESENT': return 'PRESENTE';
      case 'LATE': return 'TARDE';
      case 'ABSENT': return 'FALTO';
      default: return 'SIN MARCAR';
    }
  }
}
