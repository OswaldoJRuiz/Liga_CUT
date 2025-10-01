import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liga/core/components/mixins/safestate.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner({super.key});

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> with SafeState {
  final List<Map<String, String>> banners = [
    {
      "title": "Partido del fin de semana",
      "image": "assets/images/Partido.jpeg",
    },
    {"title": "Tabla de posiciones", "image": "assets/images/Tabla.jpg"},
    {"title": "Jugador destacado del mes", "image": "assets/images/Isaac.jpeg"},
    {"title": "Noticias de la liga", "image": "assets/images/Noticias.jpg"},
  ];

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.90);

    // Timer seguro para auto-scroll
    final timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= banners.length) _currentPage = 0;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    registerTimer(timer); // Se cancela automáticamente al hacer dispose
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose(); // timers se cancelan por el mixin
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = 12;

    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];

          // Márgenes: sin espacio en los extremos, separación uniforme
          EdgeInsets margin = EdgeInsets.symmetric(horizontal: spacing / 2);
          if (index == 0) margin = EdgeInsets.only(right: spacing / 2);
          if (index == banners.length - 1)
            margin = EdgeInsets.only(left: spacing / 2);

          return Card(
            margin: margin,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(banner["image"]!, fit: BoxFit.cover),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  color: Colors.black38,
                  child: Text(
                    banner["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
