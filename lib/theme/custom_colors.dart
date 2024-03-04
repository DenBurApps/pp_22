import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color green;
  final Color red;
  final Color disabled;

  const CustomColors({
    required this.green,
    required this.red,
    required this.disabled,
  });

  @override
  CustomColors copyWith({
    Color? green,
    Color? red,
    Color? disabled,
  }) {
    return CustomColors(
      green: green ?? this.green,
      red: red ?? this.red,
      disabled: disabled ?? this.disabled,
    );
  }

  static const customColors = CustomColors(
    green: Color.fromARGB(255, 136, 191, 63),
    red: Color(0xFFCD2B31),
    disabled: Color(0xFFD3D3D9),
  );

  @override
  ThemeExtension<CustomColors> lerp(
      covariant ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      green: Color.lerp(green, other.green, t)!,
      red: Color.lerp(red, other.red, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}