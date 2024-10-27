import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/widgets.dart';

class UserButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onTap;
  const UserButton({
    super.key,
    required this.text,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(iconData, size: 20),
          Text(text,
              style: AppTextStyle.body(size: 13, fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
