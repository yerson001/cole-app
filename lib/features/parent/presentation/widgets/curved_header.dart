import 'package:flutter/material.dart';

const _primary = Color(0xFF225BAA);
const _error = Color(0xFFBA1A1A);

class CurvedHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationsPressed;
  final double arc;

  const CurvedHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onMenuPressed,
    this.onNotificationsPressed,
    this.arc = 16,
  });

  static double preferredHeight(double topPadding, double arc) =>
      topPadding + kToolbarHeight + arc * 2;

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      color: _primary,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      clipper: _CurvedClipper(arc: arc),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight + arc * 2,
          width: double.infinity,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, size: 28),
                color: Colors.white,
                onPressed: onMenuPressed,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 26),
                      color: Colors.white,
                      onPressed: onNotificationsPressed,
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: _error,
                          shape: BoxShape.circle,
                          border: Border.all(color: _primary, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  final double arc;

  const _CurvedClipper({this.arc = 16});

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path
      ..moveTo(0, 0)
      ..lineTo(0, h - arc * 2)
      ..quadraticBezierTo(w / 2, h, w, h - arc * 2)
      ..lineTo(w, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _CurvedClipper oldClipper) => oldClipper.arc != arc;
}
