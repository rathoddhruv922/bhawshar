import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

IconThemeData customIconTheme(IconThemeData original) {
  return original.copyWith(color: black);
}

const ColorScheme kColorScheme = ColorScheme(
  primary: primary,
  secondary: secondary,
  surface: white,
  background: white,
  error: errorRed,
  onPrimary: white,
  onSecondary: white,
  onSurface: textBlack,
  onBackground: offWhite,
  onError: red,
  brightness: Brightness.light,
);

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: false);

  return base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    cardColor: Colors.white,
    shadowColor: black,
    dialogTheme: DialogTheme(
      titleTextStyle: base.textTheme.bodyLarge?.copyWith(
        color: primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: base.textTheme.bodyLarge?.copyWith(
        color: black,
        fontSize: 16,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: kColorScheme,
      textTheme: ButtonTextTheme.normal,
      buttonColor: black,
    ),
    primaryIconTheme: customIconTheme(base.iconTheme),
    textTheme: GoogleFonts.sairaTextTheme(),
    iconTheme: customIconTheme(base.iconTheme),
    hintColor: black,
    primaryColor: primary,
    primaryColorLight: white,
    primaryColorDark: white,
    scaffoldBackgroundColor: secondary,
    dividerColor: primary,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextStyle(
        color: black,
        backgroundColor: white,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(
        color: primary,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    tabBarTheme: const TabBarTheme(
      labelColor: black,
      unselectedLabelColor: black,
      labelPadding: EdgeInsets.zero,
    ),
    colorScheme: kColorScheme
        .copyWith(secondary: darkAccent)
        .copyWith(background: secondary)
        .copyWith(error: errorRed),
  );
}

class DecoratedInputBorder extends InputBorder {
  DecoratedInputBorder({
    required this.child,
    required this.shadow,
  }) : super(borderSide: child.borderSide);

  final InputBorder child;

  final BoxShadow shadow;

  @override
  bool get isOutline => child.isOutline;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      child.getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      child.getOuterPath(rect, textDirection: textDirection);

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  InputBorder copyWith(
      {BorderSide? borderSide,
      InputBorder? child,
      BoxShadow? shadow,
      bool? isOutline}) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scalledChild = child.scale(t);

    return DecoratedInputBorder(
      child: scalledChild is InputBorder ? scalledChild : child,
      shadow: BoxShadow.lerp(null, shadow, t)!,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection? textDirection}) {
    final clipPath = Path()
      ..addRect(const Rect.fromLTWH(-5000, -5000, 10000, 10000))
      ..addPath(getInnerPath(rect), Offset.zero)
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    final Paint paint = shadow.toPaint();
    final Rect bounds = rect.shift(shadow.offset).inflate(shadow.spreadRadius);

    canvas.drawPath(getOuterPath(bounds), paint);

    child.paint(canvas, rect,
        gapStart: gapStart,
        gapExtent: gapExtent,
        gapPercentage: gapPercentage,
        textDirection: textDirection);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DecoratedInputBorder &&
        other.borderSide == borderSide &&
        other.child == child &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(borderSide, child, shadow);
}
