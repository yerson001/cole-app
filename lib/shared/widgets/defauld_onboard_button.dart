import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class DefauldOnboardButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry margin;
  final double cBorder;

  const DefauldOnboardButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.cBorder = 1,
    this.margin = const EdgeInsets.only(top: 20, left: 20, right: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: cBorder > 0
              ? BorderSide(
                  color: AppColors.border,
                  width: cBorder,
                )
              : BorderSide.none,
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
