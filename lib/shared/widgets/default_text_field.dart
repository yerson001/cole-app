import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class DefaultTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final IconData icon;
  final EdgeInsetsGeometry margin;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Color background;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const DefaultTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.onChanged,
    this.margin = const EdgeInsets.only(top: 20, left: 20, right: 20),
    this.validator,
    this.isPassword = false,
    this.background = AppColors.fill,
    this.initialValue,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        onChanged: onChanged,
        initialValue: initialValue,
        validator: validator,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: background,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 2.0,
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          errorStyle: const TextStyle(color: AppColors.error),
          prefixIcon: Icon(icon, color: AppColors.primary),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
