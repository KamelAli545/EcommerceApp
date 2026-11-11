import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  static const _base = Color(0xFF2A2A2A);      // لون الـ blocks
  static const _highlight = Color(0xFF4A4A4A); // لون اللمعة

  Widget _bar(double widthFactor, double height) => FractionallySizedBox(
    widthFactor: widthFactor,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: _base,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 2 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: _base,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _bar(0.8, 12),
        const SizedBox(height: 6),
        _bar(0.4, 10),
      ],
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: _highlight);
  }
}