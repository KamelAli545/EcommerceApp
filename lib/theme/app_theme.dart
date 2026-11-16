import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexshop/widgets/app_button_styles.dart';

class AppColors {
  // Light Mode Colors
  static const paper = Color(0xFFF6F6F3);
  static const ink = Color(0xFF17202A);
  static const muted = Color(0xFF5B6470); // 5.7:1 on paper
  static const tag = Color(0xFFF4C430); // price tags only
  static const inStock = Color(0xFF1F7A4D); // 5.1:1 on paper
  static const outOfStock = Color(0xFFB42318); // 6:1 on paper
  static const hairline = Color(0xFFDCDCD6);
  static const imageWell = Color(0xFFECECE7);
  static const fieldEdge = Color(0xFF8A929C); // 3.2:1 on paper, field boundary
  static const navBackground = Color(0xFF1C1C1E);
  static const navSelected = Color(0xFF3A3A3C);
  static const alert = Color(0xFFB42318);

  // Dark Mode Colors
  static const darkPaper = Color(0xFF121212);
  static const darkInk = Color(0xFFF6F6F3);
  static const darkMuted = Color(0xFFA0AAB5);
  static const darkHairline = Color(0xFF2C2C30);
  static const darkImageWell = Color(0xFF1E1E24);
  static const darkFieldEdge = Color(0xFF3F4652);
}

class AppText {
  // ===== الأحجام: غيّر أي رقم هنا وهيتغير في التطبيق كله =====
  static const double sizeDisplay = 28;    // عناوين الصفحات الكبيرة
  static const double sizeTitle = 20;      // عناوين الأقسام (You may also like)
  static const double sizeAppBar = 18;     // عنوان الـ AppBar
  static const double sizeSubtitle = 16;   // أسماء المنتجات في الكروت
  static const double sizeBody = 15;       // الوصف
  static const double sizeCaption = 14;    // التصنيف والنصوص الصغيرة
  static const double sizePriceLarge = 22; // السعر في صفحة التفاصيل
  static const double sizePriceSmall = 15; // السعر في الكروت

  // ===== المحاذاة =====
  static const TextAlign bodyAlign = TextAlign.justify;

  // ===== الألوان حسب الـ theme (dark / light) =====
  static bool _isDark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;

  static Color ink(BuildContext c) =>
      _isDark(c) ? AppColors.darkInk : AppColors.ink;

  static Color muted(BuildContext c) =>
      _isDark(c) ? AppColors.darkMuted : AppColors.muted;

  // ===== الخطوط =====
  static TextStyle display({Color? color}) => GoogleFonts.fraunces(
    fontSize: sizeDisplay,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.ink,
  );

  static TextStyle title({double size = sizeTitle, Color? color}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.ink,
      );

  static TextStyle appBar({Color? color}) => GoogleFonts.fraunces(
    fontSize: sizeAppBar,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.ink,
  );

  static TextStyle subtitle({Color? color}) => GoogleFonts.instrumentSans(
    fontSize: sizeSubtitle,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.ink,
  );

  static TextStyle body({Color? color}) => GoogleFonts.instrumentSans(
    fontSize: sizeBody,
    height: 1.6,
    color: color ?? AppColors.ink,
  );

  static TextStyle caption({Color? color}) => GoogleFonts.instrumentSans(
    fontSize: sizeCaption,
    color: color ?? AppColors.muted,
  );

  static TextStyle price({double size = sizePriceSmall}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  static TextStyle brand() => GoogleFonts.fraunces(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
}

// ===== widget للعناوين اللي سطر واحد: بيصغّر الخط لو الاسم مش مستوعب =====
class FitText extends StatelessWidget {
  const FitText(
      this.text, {
        super.key,
        this.style,
        this.alignment = Alignment.centerLeft,
      });

  final String text;
  final TextStyle? style;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: Text(text, style: style, maxLines: 1),
    );
  }
}

class AppTheme {
  static OutlineInputBorder _edge(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: color, width: width),
      );

  // Light Theme
  static ThemeData light() {
    final body = GoogleFonts.instrumentSansTextTheme();
    final serif = GoogleFonts.frauncesTextTheme();

    TextStyle? display(TextStyle? s) =>
        s?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ink,
        primary: AppColors.ink,
        onPrimary: AppColors.paper,
        surface: AppColors.paper,
      ),
      scaffoldBackgroundColor: AppColors.paper,
      textTheme: body.copyWith(
        headlineLarge: display(serif.headlineLarge),
        headlineMedium: display(serif.headlineMedium),
        headlineSmall: display(serif.headlineSmall),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppText.brand(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.paper,
          disabledBackgroundColor: AppColors.hairline,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size(64, 52),
          elevation: 0,
          shape: AppButtonStyles.shape,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ink,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.imageWell,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: const TextStyle(color: AppColors.muted),
        floatingLabelStyle: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        errorStyle: const TextStyle(color: AppColors.outOfStock, fontSize: 13),
        border: _edge(AppColors.fieldEdge),
        enabledBorder: _edge(AppColors.fieldEdge),
        disabledBorder: _edge(AppColors.hairline),
        focusedBorder: _edge(AppColors.ink, 2),
        errorBorder: _edge(AppColors.outOfStock),
        focusedErrorBorder: _edge(AppColors.outOfStock, 2),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        space: 1,
        thickness: 1,
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.tag,
        textColor: AppColors.ink,
      ),
    );
  }

  // Dark Theme
  static ThemeData dark() {
    final body = GoogleFonts.instrumentSansTextTheme(ThemeData.dark().textTheme);
    final serif = GoogleFonts.frauncesTextTheme(ThemeData.dark().textTheme);

    TextStyle? display(TextStyle? s) =>
        s?.copyWith(fontWeight: FontWeight.w600, color: AppColors.darkInk);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkInk,
        brightness: Brightness.dark,
        primary: AppColors.darkInk,
        onPrimary: AppColors.darkPaper,
        surface: AppColors.darkPaper,
      ),
      scaffoldBackgroundColor: AppColors.darkPaper,
      textTheme: body.copyWith(
        headlineLarge: display(serif.headlineLarge),
        headlineMedium: display(serif.headlineMedium),
        headlineSmall: display(serif.headlineSmall),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkPaper,
        foregroundColor: AppColors.darkInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppText.brand().copyWith(color: AppColors.darkInk),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkInk,
          foregroundColor: AppColors.darkPaper,
          disabledBackgroundColor: AppColors.darkHairline,
          disabledForegroundColor: AppColors.darkMuted,
          minimumSize: const Size(64, 52),
          elevation: 0,
          shape: AppButtonStyles.shape,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkInk,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkImageWell,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: const TextStyle(color: AppColors.darkMuted),
        floatingLabelStyle: const TextStyle(
          color: AppColors.darkInk,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: const TextStyle(color: AppColors.darkMuted, fontSize: 13),
        errorStyle: const TextStyle(color: AppColors.outOfStock, fontSize: 13),
        border: _edge(AppColors.darkFieldEdge),
        enabledBorder: _edge(AppColors.darkFieldEdge),
        disabledBorder: _edge(AppColors.darkHairline),
        focusedBorder: _edge(AppColors.darkInk, 2),
        errorBorder: _edge(AppColors.outOfStock),
        focusedErrorBorder: _edge(AppColors.outOfStock, 2),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkHairline,
        space: 1,
        thickness: 1,
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.tag,
        textColor: AppColors.ink,
      ),
    );
  }
}