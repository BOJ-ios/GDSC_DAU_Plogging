import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Display text style
  static get displayMediumBlack900 => theme.textTheme.displayMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 36.fSize,
      );
  static get displayMediumBlack90050 => theme.textTheme.displayMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 50.fSize,
      );
  // Title text style
  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumOnErrorContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer,
        fontSize: 17.fSize,
      );
  static get pointTest => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer,
        fontSize: 20.fSize,
      );
  static get titleMediumRoboto => theme.textTheme.titleMedium!.roboto.copyWith(
        fontSize: 17.fSize,
      );
  static get titleMediumRobotoBlueA200 =>
      theme.textTheme.titleMedium!.roboto.copyWith(
        color: appTheme.blueA200,
      );
  static get titleSmallInter => theme.textTheme.titleSmall!.inter;
  static get titleSmallInterBlack900 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.black900.withOpacity(0.63),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallInterBluegray400 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.blueGray400,
      );
  static get titleSmallInterRedA200 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.redA200,
      );
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get pretendard {
    return copyWith(
      fontFamily: 'Pretendard',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }
}
