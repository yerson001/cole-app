import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            const SizedBox(height: 12),
            _row(Icons.star_border, 'Notas', '☆☆☆☆  16', Colors.amber),
            const SizedBox(height: 12),
            _row(Icons.check_circle_outline, 'Asistencia', '██████  95%', Colors.green),
            const SizedBox(height: 12),
            _row(Icons.campaign_outlined, 'Comunicados', '3 nuevos', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
