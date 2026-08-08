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
            const Text(
              'Asistencia de Hoy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF225BAA),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
              ),
              icon: const Text('Ver más', style: TextStyle(fontSize: 13)),
              label: const Icon(Icons.arrow_forward_ios, size: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (reports.isEmpty && !isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No hay registros de asistencia hoy',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ),
          )
        else
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
