import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class PillSegment<T> {
  final T value;
  final String label;
  final IconData icon;

  const PillSegment({required this.value, required this.label, required this.icon});
}

class PillSegmented<T> extends StatelessWidget {
  final List<PillSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  const PillSegmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: ac.fill,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _PillOption(
                label: segment.label,
                icon: segment.icon,
                isSelected: segment.value == selected,
                onTap: () => onChanged(segment.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ac.card : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? ac.primary : ac.textSecondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? ac.textPrimary : ac.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}