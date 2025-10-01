import 'package:flutter/material.dart';

/// Wrapper que permite usar un Widget dentro de listas donde se espera StatefulWidget
class StatefulWrapper extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  const StatefulWrapper({super.key, required this.builder});

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  Widget build(BuildContext context) => widget.builder(context);
}
