import 'package:flutter/widgets.dart';
import 'package:nexshop/widgets/flyingImage.dart';

void flyToCart({
  required BuildContext context,
  required GlobalKey imageKey,
  required GlobalKey cartKey,
  required String imageUrl,
  required String title,
}) {
  final startBox = imageKey.currentContext?.findRenderObject() as RenderBox?;
  final endBox = cartKey.currentContext?.findRenderObject() as RenderBox?;
  if (startBox == null || endBox == null) return;

  final start = startBox.localToGlobal(Offset.zero) & startBox.size;
  final end = endBox.localToGlobal(Offset.zero) & endBox.size;

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => FlyingImage(
      imageUrl: imageUrl,
      title: title,
      start: start,
      end: end,
      onDone: () => entry.remove(),
    ),
  );

  Overlay.of(context).insert(entry);
}