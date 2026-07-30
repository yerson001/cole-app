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

class DailyAttendanceCard extends StatelessWidget {
  final DayReportModel report;
  final int index;

  const DailyAttendanceCard({super.key, required this.report, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final s = report.student;
    final a = report.attendances.isNotEmpty ? report.attendances.first : null;
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final initials = '${s.name.isNotEmpty ? s.name[0] : ''}${s.lastName.isNotEmpty ? s.lastName[0] : ''}';
    return Card(
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
                  radius: 26,
                  backgroundColor: avatarColor,
                  child: Text(
                    initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${s.name} ${s.lastName}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('${s.level.name} - ${s.grade.name}${s.section.name}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                _badge(a?.updatedInClass ?? false),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _checkColumn('INGRESO', a?.checkInTime, a?.statusCheckIn),
                Container(width: 1, height: 50, color: Colors.grey[200]),
                _checkColumn('SALIDA', a?.checkOutTime, a?.statusCheckOut),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(bool updatedInClass) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: updatedInClass ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        updatedInClass ? 'Aula' : 'Puerta',
        style: TextStyle(
          fontSize: 11,
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
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Text(
          time != null ? time.substring(0, 5) : '--:--',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline, size: 14, color: statusColor),
            const SizedBox(width: 4),
            Text(
              _statusLabel(status),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
            ),
          ],
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
