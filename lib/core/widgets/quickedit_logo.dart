import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class QuickEditLogo extends StatelessWidget {
  final double fontSize;
  final bool isDark;

  const QuickEditLogo({
    super.key,
    this.fontSize = 20,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.surfaceWhite : AppColors.textDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: fontSize * 0.45,
          height: fontSize * 0.9,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              fontFamily: 'Plus Jakarta Sans',
            ),
            children: [
              TextSpan(
                text: 'QUICK',
                style: TextStyle(color: textColor),
              ),
              const TextSpan(
                text: 'EDIT',
                style: TextStyle(color: AppColors.primaryOrange),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
