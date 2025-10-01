import 'package:flutter/material.dart';

class NeonBanner extends StatefulWidget {
  final double height;
  final String title;
  final String subtitle;

  const NeonBanner({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
  });

  @override
  State<NeonBanner> createState() => _NeonBannerState();
}

class _NeonBannerState extends State<NeonBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _gradientAnimation1;
  late Animation<Color?> _gradientAnimation2;
  late Animation<Color?> _gradientAnimation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _gradientAnimation1 = ColorTween(
      begin: const Color(0xFF06991F),
      end: const Color(0xFF04781F),
    ).animate(_controller);
    _gradientAnimation2 = ColorTween(
      begin: const Color(0xFF14A4A2),
      end: const Color(0xFF157EA0),
    ).animate(_controller);
    _gradientAnimation3 = ColorTween(
      begin: const Color(0xFF150795),
      end: const Color(0xFF06065D),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          margin: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _gradientAnimation1.value!,
                _gradientAnimation2.value!,
                _gradientAnimation3.value!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _gradientAnimation1.value!.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.blueAccent.withOpacity(0.2),
                        blurRadius: 12,
                      ),
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
