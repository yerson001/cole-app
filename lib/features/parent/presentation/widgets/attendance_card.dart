import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class AttendanceCard extends StatelessWidget {
  final String name;
  final String lastName;
  final String level;
  final String grade;
  final String section;
  final String? checkInTime;
  final String? checkOutTime;
  final String checkInStatus;
  final String checkOutStatus;
  final bool updatedInClass;

  const AttendanceCard({
    super.key,
    required this.name,
    required this.lastName,
    required this.level,
    required this.grade,
    required this.section,
    this.checkInTime,
    this.checkOutTime,
    this.checkInStatus = 'UNMARKED',
    this.checkOutStatus = 'UNMARKED',
    this.updatedInClass = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 320,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: c.primaryLight.withValues(alpha: 0.2),
                child: Text(
                  '${name[0]}${lastName[0]}',
                  style: TextStyle(
                    color: c.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      lastName,
                      style: TextStyle(fontWeight: FontWeight.w400, color: c.textSecondary, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (updatedInClass ? c.infoLight : c.successLight).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      updatedInClass ? 'Aula' : 'Puerta',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: updatedInClass ? c.info : c.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$level - $grade - $section',
                    style: TextStyle(fontSize: 9, color: c.textSecondary),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _statusBox(c, 'INGRESO', checkInTime, checkInStatus)),
              const SizedBox(width: 8),
              Expanded(child: _statusBox(c, 'SALIDA', checkOutTime, checkOutStatus)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBox(AppColors c, String label, String? time, String status) {
    final (displayTime, displayStatus, icon, color) = _attendanceData(time, status, c);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: c.fill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c.textSecondary)),
          const SizedBox(height: 2),
          Text(displayTime, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 2),
              Text(displayStatus, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  (String, String, IconData, Color) _attendanceData(String? time, String status, AppColors c) {
    switch (status) {
      case 'PRESENT':
        return (time ?? '--:--', 'PRESENTE', Icons.check_circle, c.success);
      case 'LATE':
        return (time ?? '--:--', 'TARDE', Icons.schedule, c.warning);
      case 'ABSENT':
        return ('--:--', 'FALTO', Icons.cancel, c.error);
      case 'EXCUSED':
        return ('--:--', 'FALTO', Icons.cancel, c.error);
      default:
        return ('--:--', 'SIN MARCAR', Icons.help, c.textDisabled);
    }
  }
}
