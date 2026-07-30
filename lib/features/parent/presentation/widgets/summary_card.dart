import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Card(
      color: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: c.primary),
                const SizedBox(width: 8),
                Text('Resumen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            _row(context, Icons.star_outline, 'Notas', '☆☆☆☆  16', c),
            const SizedBox(height: 12),
            _row(context, Icons.check_circle_outline, 'Asistencia', '██████  95%', c),
            const SizedBox(height: 12),
            _row(context, Icons.campaign_outlined, 'Comunicados', '3 nuevos', c),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value, AppColors c) {
    return Row(
      children: [
        Icon(icon, size: 20, color: c.primary),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: c.textSecondary, fontSize: 14)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary)),
      ],
    );
  }
}
