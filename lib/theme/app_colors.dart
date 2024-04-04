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
    fingerID: Color(0xFFFFFFFF),
    textWhite: Color(0xFFFFFFFF),
    gradient_bg_1: Color(0xFF7BB0EF),
    gradient_bg_2: Color(0xFF66A6F1),
    gradient_bg_3: Color(0xFF478DE0),
    gradient_bg_4: Color(0xFF398AE5),
    tfcolor: Color(0xFF6CA8F1),
    defaultBgContainer: Color(0xFFFFFFFF),
  );

  static const AppColorsScheme darkScheme = AppColorsScheme(
    textGray: Color(0xFFAABBCC),
    textBlack: Color(0xFFFFFFFF),
    borderColor: Color(0xFFF8F8F8),
    buttonEnable: Color(0xFF3A414C),
    textOnBtnEnable: Color(0xFF000000),
    buttonDisable: Color(0xFF9DC5FB),
    fingerID: Color(0xFFFFFFFF),
    textWhite: Color(0xFFFFFFFF),
    gradient_bg_1: Color(0xFF7BB0EF),
    gradient_bg_2: Color(0xFF66A6F1),
    gradient_bg_3: Color(0xFF478DE0),
    gradient_bg_4: Color(0xFF398AE5),
    tfcolor: Color(0xFF6CA8F1),
    defaultBgContainer: Color(0xFFFFFFFF),
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
    required this.fingerID,
    required this.textWhite,
    required this.gradient_bg_1,
    required this.gradient_bg_2,
    required this.gradient_bg_3,
    required this.gradient_bg_4,
    required this.defaultBgContainer,
    required this.tfcolor
  });

  final Color textGray;
  final Color textBlack;
  final Color textWhite;
  final Color borderColor;
  final Color buttonEnable;
  final Color buttonDisable;
  final Color textOnBtnEnable;
  final Color fingerID;
  final Color gradient_bg_1;
  final Color gradient_bg_2;
  final Color gradient_bg_3;
  final Color gradient_bg_4;
  final Color tfcolor;
  final Color defaultBgContainer;
}
