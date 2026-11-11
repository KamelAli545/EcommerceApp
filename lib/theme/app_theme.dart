import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexshop/widgets/app_button_styles.dart';

class AppColors {
  // Light Mode Colors (الأصلية كما هي تماماً بدون أي تعديل)
  static const paper = Color(0xFFF6F6F3);
  static const ink = Color(0xFF17202A);
  static const muted = Color(0xFF5B6470); // 5.7:1 on paper
  static const tag = Color(0xFFF4C430); // price tags only
  static const inStock = Color(0xFF1F7A4D); // 5.1:1 on paper
  static const outOfStock = Color(0xFFB42318); // 6:1 on paper
  static const hairline = Color(0xFFDCDCD6);
  static const imageWell = Color(0xFFECECE7);
  static const fieldEdge = Color(0xFF8A929C);// 3.2:1 on paper, field boundary
  static const navBackground = Color(0xFF1C1C1E); // خلفية الشريط
  static const navSelected = Color(0xFF3A3A3C);   // خلفية الزرار المختار
  static const alert = Color(0xFFB42318);          // النقطة الحمرا للإشعارات

  // Dark Mode Colors (ألوان الوضع الليلي الجديدة متوافقة مع نفس هوية التصميم)
  static const darkPaper = Color(0xFF121212);
  static const darkInk = Color(0xFFF6F6F3);
  static const darkMuted = Color(0xFFA0AAB5);
  static const darkHairline = Color(0xFF2C2C30);
  static const darkImageWell = Color(0xFF1E1E24);
  static const darkFieldEdge = Color(0xFF3F4652);
}

class AppText {
  static TextStyle price({double size = 18}) => GoogleFonts.fraunces(
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

class AppTheme {
  static OutlineInputBorder _edge(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: color, width: width),
      );

  // Light Theme (الكود الأصلي الخاص بك بالكامل بدون أي تغيير)
  static ThemeData light() {
    final body = GoogleFonts.instrumentSansTextTheme();
    final serif = GoogleFonts.frauncesTextTheme();
    final radius = BorderRadius.circular(6);

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

  // Dark Theme (الثيم الليلي الجديد المضاف بجانب الكود القديم)
  static ThemeData dark() {
    final body = GoogleFonts.instrumentSansTextTheme(ThemeData.dark().textTheme);
    final serif = GoogleFonts.frauncesTextTheme(ThemeData.dark().textTheme);
    final radius = BorderRadius.circular(6);

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