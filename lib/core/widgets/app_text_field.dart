import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Standard labelled text field. Styling comes from the theme's
/// `inputDecorationTheme`; only content options are exposed here.
///
/// Fields never show inline (red) validation errors: forms validate on
/// submit and report the first problem with `TopSnackbar`.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.prefixIcon,
    this.suffixText,
    this.onChanged,
    this.onSubmitted,
    this.fieldKey,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final IconData? prefixIcon;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Key for the inner [TextFormField], for tests.
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final prefixIcon = this.prefixIcon;
    return TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        suffixText: suffixText,
        counterText: '',
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
    );
  }
}
