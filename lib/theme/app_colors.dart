import 'dart:ui';

class AppColors {
  AppColors({this.appearance = Appearance.light});

  final Appearance appearance;

  bool get _isLightColors => appearance == Appearance.light;

  AppColorsScheme get scheme => _isLightColors ? lightScheme : darkScheme;

  static const AppColorsScheme lightScheme = AppColorsScheme(
    textGray: Color(0xFFAABBCC),
    textBlack: Color(0xFF000000),
    borderColor: Color(0xFFDCDCDC),
    buttonEnable: Color(0xFF418FFF),
    textOnBtnEnable: Color(0xFFFFFFFF),
    buttonDisable: Color(0xFFDDEBFF),
  );

  static const AppColorsScheme darkScheme = AppColorsScheme(
    textGray: Color(0xFFAABBCC),
    textBlack: Color(0xFFFFFFFF),
    borderColor: Color(0xFFF8F8F8),
    buttonEnable: Color(0xFF3A414C),
    textOnBtnEnable: Color(0xFF000000),
    buttonDisable: Color(0xFF9DC5FB),
  );
}

enum Appearance { light, dark }

class AppColorsScheme {
  const AppColorsScheme({
    required this.textGray,
    required this.textBlack,
    required this.borderColor,
    required this.buttonEnable,
    required this.buttonDisable,
    required this.textOnBtnEnable,
  });

  final Color textGray;
  final Color textBlack;
  final Color borderColor;
  final Color buttonEnable;
  final Color buttonDisable;
  final Color textOnBtnEnable;
}
