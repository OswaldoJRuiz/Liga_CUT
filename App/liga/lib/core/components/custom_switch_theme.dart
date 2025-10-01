import 'package:flutter/material.dart';

class CustomSwitchTheme extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor; // color de fondo activo
  final Color? inactiveColor; // color de fondo inactivo
  final Color? activeThumbColor; // color de la bolita activa
  final Color? inactiveThumbColor; // color de la bolita inactiva

  const CustomSwitchTheme({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
  });

  @override
  State<CustomSwitchTheme> createState() => _CustomSwitchThemeState();
}

class _CustomSwitchThemeState extends State<CustomSwitchTheme> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _toggle() {
    setState(() {
      _value = !_value;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 55,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: _value
              ? (widget.activeColor ?? const Color(0xFF243366))
              : (widget.inactiveColor ?? const Color(0xFF616161)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _value
                  ? (widget.activeThumbColor ?? Colors.white)
                  : (widget.inactiveThumbColor ?? Colors.black87),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
