import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserButton extends StatelessWidget {
  final String text;
  final String iconData;
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
          iconData.endsWith(".png")
              ? Image.asset(iconData)
              : SvgPicture.asset(
                  iconData,
                ),
          Text(text,
              style: AppTextStyle.body(size: 13, fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
