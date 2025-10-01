import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  final double borderRadius;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool withScaleAnimation;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.gradientColors,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    this.withScaleAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
                    : [const Color(0xFFFF5F6D), const Color(0xFFFFC371)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: gradientColors == null && backgroundColor != null
            ? backgroundColor
            : null,
        border: border,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: isDark ? Colors.black54 : Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (withScaleAnimation && onTap != null) {
      return _ScaleOnTap(onTap: onTap!, child: content);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: content,
    );
  }
}

class _ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ScaleOnTap({required this.child, required this.onTap});

  @override
  State<_ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<_ScaleOnTap> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.92);
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
