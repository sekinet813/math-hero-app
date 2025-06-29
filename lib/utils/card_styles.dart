import 'package:flutter/material.dart';
import 'constants.dart';

/// カードのスタイルヘルパー
class CardStyles {
  // プライバシーコンストラクタ
  CardStyles._();

  /// スタイル付きカードを取得
  static Card getStyledCard({
    required Widget child,
    EdgeInsetsGeometry? margin,
    double? elevation,
  }) {
    return Card(
      elevation: elevation ?? 2.0,
      margin: margin ?? const EdgeInsets.all(AppConstants.kSpacing8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.kBorderRadius12),
      ),
      child: child,
    );
  }

  /// 角丸カードのスタイル
  static RoundedRectangleBorder get roundedBorder => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppConstants.kBorderRadius12),
  );

  /// カードのマージン
  static EdgeInsetsGeometry get cardMargin =>
      const EdgeInsets.all(AppConstants.kSpacing8);
}
