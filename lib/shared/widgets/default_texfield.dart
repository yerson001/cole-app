import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class DefaultTexfield extends StatelessWidget {
  final String text;
  final String? initialValue;
  final Function(String text) onChanged;
  final IconData icon;
  final EdgeInsetsGeometry margin;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Color? background;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const DefaultTexfield({
    super.key,
    required this.text,
    required this.icon,
    required this.onChanged,
    this.margin = const EdgeInsets.only(top: 20, left: 20, right: 20),
    this.validator,
    this.isPassword = false,
    this.background,
    this.initialValue,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      margin: margin,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        initialValue: controller != null ? null : initialValue,
        validator: validator,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14, color: c.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: background ?? c.fill,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: c.border),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: c.inputFocused,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: c.border,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: c.inputError,
              width: 0.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: c.inputError,
              width: 0.5,
            ),
          ),
          labelText: text,
          labelStyle: TextStyle(color: c.inputLabel, fontSize: 14),
          errorStyle: TextStyle(color: c.error),
          prefixIcon: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Icon(icon, color: c.primary),
                Container(height: 20, width: 1, color: c.border),
              ],
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
