import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSliverAppbar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double expandedHeight;
  final Widget? leading;
  final Widget? bottomCenterWidget;

  const CustomSliverAppbar({
    super.key,
    required this.title,
    this.actions,
    this.pinned = false,
    this.floating = true,
    this.snap = false,
    this.expandedHeight = 56,
    this.leading,
    this.bottomCenterWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colores para AnimatedContainer
    final gradientColors = isDark
        ? [Color(0xFF0B102A), Color(0xFF121B2D), Color(0xFF1E293B)]
        : [Color(0xFFCBDFFF), Color(0xFFD3E2FE), Color(0xFFEEF7FD)];

    final separatorColor = isDark
        ? Colors.white.withAlpha((0.05 * 255).round())
        : Colors.black.withAlpha((0.05 * 255).round());

    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      snap: snap,
      expandedHeight: expandedHeight,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      title: Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
      centerTitle: true,
      leading: leading,
      actions: actions,
      iconTheme: Theme.of(context).appBarTheme.iconTheme,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
              stops: const [0.0, 0.7, 1.2],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Separador inferior
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(height: 1, color: separatorColor),
              ),
              // Logo
              if (bottomCenterWidget != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: bottomCenterWidget!,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/LogoCUT.png',
                      height: expandedHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
