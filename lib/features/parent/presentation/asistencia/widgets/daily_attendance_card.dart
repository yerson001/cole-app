import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
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

  static const _verde = Color(0xFF54DEB1);
  static const _naranja = Color(0xFFFCB700);
  static const _salidaAzul = Color(0xFF00B9FE);
  static const _gris = Color(0xFF9E9E9E);
  static const _labelGris = Color(0xFF757575);

  String _initials() {
    final s = report.student;
    final parts = [s.name, s.lastName].where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'PRESENT':
      case 'EARLY':
      case 'ON_TIME':
        return _verde;
      case 'LATE':
        return _naranja;
      default:
        return _gris;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'PRESENT':
      case 'EARLY':
      case 'ON_TIME':
        return 'PRESENTE';
      case 'LATE':
        return 'TARDE';
      case 'ABSENT':
        return 'FALTO';
      default:
        return 'SIN MARCAR';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final s = report.student;
    final a = report.attendances.isNotEmpty ? report.attendances.first : null;
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final gradeLabel =
        '${_capitalize(s.level.name)}-${_capitalize(s.grade.name)}-${_capitalize(s.section.name)}';
    final inPlace = a?.checkInTime != null
        ? (a?.statusCheckIn != null ? _statusLabel(a?.statusCheckIn) : 'PRESENTE')
        : 'SIN MARCAR';
    final outPlace = a?.checkOutTime != null ? 'REGISTRADO' : 'SIN MARCAR';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ac.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.name} ${s.lastName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ac.textPrimary),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      gradeLabel,
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.5,
                        color: ac.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _badge(a?.updatedInClass ?? false),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _checkColumn(
                  label: 'INGRESO',
                  time: a?.checkInTime,
                  status: a?.statusCheckIn,
                  place: inPlace,
                  ac: ac,
                ),
              ),
              Expanded(
                child: _checkColumn(
                  label: 'SALIDA',
                  time: a?.checkOutTime,
                  status: a?.statusCheckOut,
                  place: outPlace,
                  fixedAccent: a?.checkOutTime != null ? _salidaAzul : null,
                  ac: ac,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(bool updatedInClass) {
    final color = updatedInClass ? _verde : _naranja;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        updatedInClass ? 'Aula' : 'Puerta',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _checkColumn({
    required String label,
    String? time,
    required String place,
    String? status,
    Color? fixedAccent,
    required AppColors ac,
  }) {
    final hasMark = time != null;
    final accent = hasMark
        ? (fixedAccent ?? _statusColor(status))
        : _gris;
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: hasMark ? accent : ac.border,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: _labelGris,
            ),
          ),
          const SizedBox(height: 2),
          if (hasMark)
            Text(
              _formatTime(time),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            )
          else
            Text(
              '--:--',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _gris.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(height: 1),
          Row(
            children: [
              Icon(
                _statusIcon(hasMark, status),
                size: 14,
                color: hasMark ? accent : _gris,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  place,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: hasMark ? accent : _gris,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(bool hasMark, String? status) {
    if (!hasMark) return Icons.hourglass_empty;
    if (status == 'LATE') return Icons.schedule;
    return Icons.check_circle;
  }

  String _formatTime(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final suffix = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '${hour.toString().padLeft(2, '0')}:$minute $suffix';
  }
}
