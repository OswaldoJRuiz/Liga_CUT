import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphismBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color backgroundColor;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;

  const GlassmorphismBox({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 10,
    this.backgroundColor = Colors.white,
    this.opacity = 0.2,
    this.padding = const EdgeInsets.all(16),
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
