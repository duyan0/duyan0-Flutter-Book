import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselBanner extends StatelessWidget {
  const CarouselBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 3),
        viewportFraction: 0.9,
      ),
      items: [
        'lib/core/assets/hks_1.jpeg',
        'lib/core/assets/hks_1.jpeg',
        'lib/core/assets/hks_1.jpeg',
      ].map((path) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
} 