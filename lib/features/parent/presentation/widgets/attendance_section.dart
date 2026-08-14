import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_card.dart';

class AttendanceSection extends StatefulWidget {
  final List<DayReportModel> reports;
  final bool isLoading;
  final VoidCallback? onVerMas;
  final ValueChanged<int>? onPageChanged;

  const AttendanceSection({
    super.key,
    required this.reports,
    this.isLoading = false,
    this.onVerMas,
    this.onPageChanged,
  });

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  final PageController _controller = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final reports = widget.reports;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reports.isEmpty && !widget.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No hay registros de asistencia hoy',
                style: TextStyle(fontSize: 13, color: ac.textSecondary),
              ),
            ),
          )
        else
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _controller,
              itemCount: reports.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final page = _controller.hasClients ? _controller.page ?? 0 : _currentPage.toDouble();
                    final diff = (page - index).abs().clamp(0.0, 1.0);
                    final scale = 1.0 - (0.08 * diff);
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: AttendanceCard(report: reports[index]),
                );
              },
            ),
          ),
        Row(
          children: [
            Expanded(
              child: reports.length > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < reports.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _currentPage ? 20 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: i == _currentPage
                                  ? ac.primary
                                  : ac.border,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            if (widget.isLoading) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onTap: widget.onVerMas,
              child: Text(
                'Ver asistencia de la semana →',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: ac.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
