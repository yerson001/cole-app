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

  static const _primary = Color(0xFF225BAA);

  String _initials() {
    final s = report.student;
    final parts = [s.name, s.lastName].where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final s = report.student;
    final a = report.attendances.isNotEmpty ? report.attendances.first : null;
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final gradeLabel =
        '${s.level.name.toUpperCase()} ${s.grade.name.toUpperCase()}${s.section.name.toUpperCase()}';
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(color: avatarColor.withValues(alpha: 0.20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.name} ${s.lastName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      gradeLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _checkColumn(
                  label: 'INGRESO',
                  time: a?.checkInTime,
                  place: a?.updatedInClass == true ? 'Aula' : 'Puerta Principal',
                  highlighted: true,
                ),
              ),
              Expanded(
                child: _checkColumn(
                  label: 'SALIDA',
                  time: a?.checkOutTime,
                  place: a?.checkOutTime != null ? 'Registrado' : 'Pendiente',
                  highlighted: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkColumn({
    required String label,
    String? time,
    required String place,
    required bool highlighted,
  }) {
    final color = highlighted ? _primary : const Color(0xFF424751);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: highlighted ? _primary : const Color(0xFFE2E8F0),
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
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: _primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time != null && time.length >= 5 ? time.substring(0, 5) : '--:--',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color.withValues(alpha: highlighted ? 1 : 0.45),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            place,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: highlighted ? 0.75 : 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
