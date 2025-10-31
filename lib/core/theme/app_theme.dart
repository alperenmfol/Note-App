import 'package:flutter/material.dart';

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xfffefb4e),
      onPrimary: Color(0xff1c1c00),
      primaryContainer: Color(0xfffff89a),
      onPrimaryContainer: Color(0xff1c1c00),
      secondary: Color(0xff8f8f58),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff3f1d0),
      onSecondaryContainer: Color(0xff1c1c00),
      tertiary: Color(0xff4e4e4e),
      onTertiary: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),

      background: Color(0xfffffcf2),
      onBackground: Color(0xff1c1c00),
      surface: Color(0xfffff9e5),
      onSurface: Color(0xff1c1c00),

      surfaceVariant: Color(0xfff1edcf),
      onSurfaceVariant: Color(0xff3c3c20),
      outline: Color(0xffbdb88c),
      outlineVariant: Color(0xffe7e1b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff292800),
      inversePrimary: Color(0xffeae457),
      surfaceTint: Colors.transparent,
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffefb4e),
      onPrimary: Color(0xff1c1c00),
      primaryContainer: Color(0xff5c5a00),
      onPrimaryContainer: Color(0xfffffda3),
      secondary: Color(0xffc5c282),
      onSecondary: Color(0xff1a1a00),
      secondaryContainer: Color(0xff3a3900),
      onSecondaryContainer: Color(0xfffff5a4),
      tertiary: Color(0xffd5d5b0),
      onTertiary: Color(0xff1a1a00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      background: Color(0xff141400),
      onBackground: Color(0xfff5f5e0),
      surface: Color(0xff1a1a00),
      onSurface: Color(0xfff9f9e4),
      surfaceVariant: Color(0xff2e2e00),
      onSurfaceVariant: Color(0xffd8d6a3),
      outline: Color(0xff78764c),
      outlineVariant: Color(0xff393900),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffefae2),
      inversePrimary: Color(0xfffefb4e),
      surfaceTint: Colors.transparent,
    );
  }
}
