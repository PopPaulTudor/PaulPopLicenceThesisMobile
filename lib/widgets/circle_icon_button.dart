import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CircleImageButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback function;

  const CircleImageButton({
    Key? key,
    required this.icon,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Icon(
        icon,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        primary: AppColors.primaryColor,
// <-- Button color
        onPrimary: AppColors.secondaryColor, // <-- Splash color
      ),
    );
  }
}
