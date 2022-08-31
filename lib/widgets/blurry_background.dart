import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryClickableContainer extends StatelessWidget {
  final VoidCallback function;
  final Widget child;
  final double intensity;

  const BlurryClickableContainer({
    Key? key,
    required this.function,
    required this.child,
    required this.intensity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: intensity * 5, sigmaY: intensity),
            child: child),
      ),
    );
  }
}
