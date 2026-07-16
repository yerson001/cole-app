import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry margin;
  final double cBorder;

  const DefaultButton({
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
      width: MediaQuery.of(context).size.width,
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: cBorder > 0
              ? BorderSide(
                  color: const Color.fromARGB(255, 54, 56, 55),
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
