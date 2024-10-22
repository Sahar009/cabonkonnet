import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class AppTextFields extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData iconData;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool isReadOnly;
  final VoidCallback? onTab;
  const AppTextFields(
      {super.key,
      required this.controller,
      required this.hint,
      required this.iconData,
      this.validator,
      this.isPassword = false,
      this.keyboardType,
      this.isReadOnly = false,
      this.onTab});

  @override
  State<AppTextFields> createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextFields> {
  // Boolean to toggle password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTab,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: widget.isPassword &&
          !_isPasswordVisible, // Toggles obscureText for password
      style: AppTextStyle.body(fontWeight: FontWeight.normal, size: 12),
      validator: widget.validator,
      readOnly: widget.isReadOnly,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.iconData),
        hintText: widget.hint,
        hintStyle: AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: const Color(0xffF5F5F5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        // Add a suffix icon for password fields
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  // Toggle between visibility icons
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  // Toggle password visibility when the icon is pressed
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null, // No suffix icon for non-password fields
      ),
    );
  }
}
