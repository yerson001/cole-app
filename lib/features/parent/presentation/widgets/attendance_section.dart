import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_card.dart';

class AttendanceSection extends StatelessWidget {
  final List<DayReportModel> reports;
  final bool isLoading;
  final VoidCallback? onVerMas;

  const AttendanceSection({
    super.key,
    required this.reports,
    this.isLoading = false,
    this.onVerMas,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 6),
            Text(
              'Asistencia hoy (${reports.length})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            TextButton.icon(
              onPressed: onVerMas,
              icon: const Text('Ver más', style: TextStyle(fontSize: 13)),
              label: const Icon(Icons.arrow_forward_ios, size: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 4, right: 4),
            itemCount: reports.length,
            separatorBuilder: (_, _) => const SizedBox(width: 4),
            itemBuilder: (context, index) => AttendanceCard(report: reports[index], index: index),
          ),
        ),
      ],
    );
  }
}
