import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.controller,
    required this.keyboardType,
    required this.textCapitalization,
    required this.textInputAction,
    required this.readOnly,
    required this.obscureText,
    required this.maxLines,
    required this.maxLength,
    required this.onChanged,
    required this.onTap,
    required this.validator,
    required this.inputFormatters,
    required this.enabled,
    required this.autofillHints,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    super.key,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?) validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final String labelText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).buttonTheme.colorScheme!.primary;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorColor: primary,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelStyle: TextStyle(color: primary),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
