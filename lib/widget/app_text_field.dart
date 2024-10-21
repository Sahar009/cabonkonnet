import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class AppTextFields extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData iconData;

  const AppTextFields({
    super.key,
    required this.controller,
    required this.hint,
    required this.iconData,
  });

  @override
  State<AppTextFields> createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextFields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyle.body(fontWeight: FontWeight.normal, size: 12),
      decoration: InputDecoration(
          prefixIcon: Icon(widget.iconData),
          hintText: widget.hint,
          hintStyle: AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
          filled: true,
          fillColor: const Color(0xffF5F5F5),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8))),
    );
  }
}
