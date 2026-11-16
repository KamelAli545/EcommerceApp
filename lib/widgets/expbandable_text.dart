import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexshop/theme/app_theme.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 3,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _fontsReady = false;

  @override
  void initState() {
    super.initState();
    GoogleFonts.pendingFonts().then((_) {
      if (mounted) setState(() => _fontsReady = true);
    });
  }

  // بنسأل سؤال واحد بس: هل النص كامل بيعدي عدد الأسطر؟
  // ده أدق بكتير من إننا نحسب مكان القطع بالحروف
  bool _isOverflowing(
      double maxWidth,
      TextStyle style,
      TextDirection dir,
      TextScaler scaler,
      ) {
    final p = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: widget.maxLines,
      textDirection: dir,
      textScaler: scaler,
      textAlign: AppText.bodyAlign,
    )..layout(maxWidth: maxWidth);
    return p.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final dir = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final style = widget.style ?? AppText.body(color: AppText.ink(context));
    final linkColor = AppText.ink(context);

    final text = Text(
      widget.text,
      style: style,
      textAlign: AppText.bodyAlign,
      maxLines: _expanded ? null : widget.maxLines,
      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );

    // قبل تحميل الخطوط نعرض النص من غير قياس
    if (!_fontsReady) return text;

    return LayoutBuilder(
      builder: (context, constraints) {
        final overflows = _isOverflowing(
          constraints.maxWidth,
          style,
          dir,
          scaler,
        );

        if (!overflows) return text;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text,
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _expanded ? 'less' : 'more',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: linkColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}