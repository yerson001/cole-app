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
  final Color background;
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
    this.background = AppColors.fill,
    this.initialValue,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        initialValue: controller != null ? null : initialValue,
        validator: validator,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: background,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
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
            borderSide: const BorderSide(
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
          labelText: text,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          errorStyle: const TextStyle(color: AppColors.error),
          prefixIcon: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Icon(icon, color: AppColors.primary),
                Container(height: 20, width: 1, color: AppColors.border),
              ],
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
