import 'package:bookmark_app/src/core/constants/colors.dart';
import 'package:bookmark_app/src/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(158, 32)),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.f16w500.copyWith(color: AppColors.white),
        ));
  }
}
