import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

class AttendanceCard extends StatelessWidget {
  final DayReportModel report;

  const AttendanceCard({super.key, required this.report});

  static const _verde = Color(0xFF0F6E56);
  static const _naranja = Color(0xFFB0790F);
  static const _salidaAzul = Color(0xFF00B9FE);
  static const _gris = Color(0xFF9E9E9E);
  static const _labelGris = Color(0xFF757575);

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

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final a = report.attendances.isNotEmpty ? report.attendances.first : null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ac.border, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              // --- ENTRADA ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _checkLabel(
                      label: 'ENTRADA',
                      icon: a?.checkInTime != null
                          ? (a!.statusCheckIn == 'LATE'
                              ? Icons.schedule
                              : Icons.check_circle)
                          : Icons.access_time,
                      color: a?.checkInTime != null
                          ? _statusColor(a!.statusCheckIn)
                          : _labelGris,
                    ),
                    const SizedBox(height: 6),
                    if (a?.checkInTime != null)
                      _bigTime(a!.checkInTime!, ac: ac, color: ac.textPrimary)
                    else
                      _placeholderTime(ac),
                    const SizedBox(height: 6),
                    _statusLine(
                      text: a?.checkInTime != null ? 'Registrada' : 'Pendiente',
                      icon: a?.statusCheckIn == 'LATE'
                          ? Icons.schedule
                          : Icons.check_circle,
                      color: a?.checkInTime != null ? ac.primary : _labelGris,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      a?.updatedInClass == true ? 'Aula' : 'Puerta principal',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: _labelGris),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 92,
                color: ac.border,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              // --- SALIDA ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _checkLabel(
                      label: 'SALIDA',
                      icon: a?.checkOutTime != null
                          ? Icons.check_circle
                          : Icons.access_time,
                      color: a?.checkOutTime != null ? _salidaAzul : _labelGris,
                    ),
                    const SizedBox(height: 6),
                    if (a?.checkOutTime != null)
                      _bigTime(a!.checkOutTime!, ac: ac, color: _salidaAzul)
                    else
                      Text(
                        '--:--',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: _gris.withValues(alpha: 0.6),
                        ),
                      ),
                    const SizedBox(height: 6),
                    _statusLine(
                      text: a?.checkOutTime != null ? 'Registrado' : 'Pendiente',
                      icon: a?.checkOutTime != null
                          ? Icons.check_circle
                          : Icons.access_time,
                      color: a?.checkOutTime != null ? _salidaAzul : _labelGris,
                    ),
                    const SizedBox(height: 1),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 17, color: ac.textDisabled),
        ],
      ),
    );
  }

  Widget _checkLabel({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 0.5,
            color: _labelGris,
          ),
        ),
      ],
    );
  }

  Widget _bigTime(String raw, {required AppColors ac, required Color color}) {
    final parts = raw.split(':');
    var hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? parts[1] : '00';
    final suffix = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${hour.toString().padLeft(2, '0')}:$minute ',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              height: 1.1,
              color: color,
            ),
          ),
          TextSpan(
            text: suffix,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.1,
              color: ac.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderTime(AppColors ac) {
    return Text(
      '--:--',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: _gris.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _statusLine({
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}