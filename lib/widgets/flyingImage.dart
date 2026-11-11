import 'package:flutter/cupertino.dart';
import 'package:nexshop/widgets/product_image.dart';

class FlyingImage extends StatefulWidget {
  const FlyingImage({
    required this.imageUrl,
    required this.title,
    required this.start,
    required this.end,
    required this.onDone,
  });

  final String imageUrl;
  final String title;
  final Rect start;
  final Rect end;
  final VoidCallback onDone;

  @override
  State<FlyingImage> createState() => _FlyingImageState();
}

class _FlyingImageState extends State<FlyingImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (_, __) {
        final rect = Rect.lerp(widget.start, widget.end, _curve.value)!;
        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: IgnorePointer(
            child: Opacity(
              opacity: 1 - _curve.value * 0.5,
              child: ProductImage(
                url: widget.imageUrl,
                title: widget.title,
                radius: 8,
              ),
            ),
          ),
        );
      },
    );
  }
}