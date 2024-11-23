import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final int maxLines;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final Function(String?)? onDropdownChanged;
  final String? dropdownValue;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.maxLines = 1,
    this.isDropdown = false,
    this.dropdownItems,
    this.onDropdownChanged,
    this.dropdownValue,
  })  : assert(isDropdown == false || dropdownItems != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppTextStyle.soraBody(fontWeight: FontWeight.bold, size: 15),
        ),
        const SizedBox(height: 8),
        isDropdown
            ? DropdownButtonFormField<String>(
                value: dropdownValue,
                items: dropdownItems!.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onDropdownChanged,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  hintText: hintText,
                ),
              )
            : TextFormField(
                controller: controller,
                maxLines: maxLines,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: hintText,
                  fillColor: const Color(0xffF5F5F5),
                  border: _outlineBorder(),
                  focusedBorder: _outlineBorder(),
                  enabledBorder: _outlineBorder(),
                ),
              ),
        const SizedBox(height: 15),
      ],
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 0.2));
  }
}
