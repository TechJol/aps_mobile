/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Inter.ttf
  String get inter => 'assets/fonts/Inter.ttf';

  /// File path: assets/fonts/Roboto-Regular.ttf
  String get robotoRegular => 'assets/fonts/Roboto-Regular.ttf';

  /// List of all assets
  List<String> get values => [inter, robotoRegular];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/appstore.png
  AssetGenImage get appstore =>
      const AssetGenImage('assets/icons/appstore.png');

  /// File path: assets/icons/calendar.svg
  String get calendar => 'assets/icons/calendar.svg';

  /// File path: assets/icons/comeout.svg
  String get comeout => 'assets/icons/comeout.svg';

  /// File path: assets/icons/delete.svg
  String get delete => 'assets/icons/delete.svg';

  /// File path: assets/icons/edit.svg
  String get edit => 'assets/icons/edit.svg';

  /// File path: assets/icons/eye.png
  AssetGenImage get eye => const AssetGenImage('assets/icons/eye.png');

  /// File path: assets/icons/folder1.svg
  String get folder1 => 'assets/icons/folder1.svg';

  /// File path: assets/icons/folder2.svg
  String get folder2 => 'assets/icons/folder2.svg';

  /// File path: assets/icons/folder3.svg
  String get folder3 => 'assets/icons/folder3.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/income.svg
  String get income => 'assets/icons/income.svg';

  /// File path: assets/icons/kg.png
  AssetGenImage get kg => const AssetGenImage('assets/icons/kg.png');

  /// File path: assets/icons/logo_softkg.png
  AssetGenImage get logoSoftkg =>
      const AssetGenImage('assets/icons/logo_softkg.png');

  /// File path: assets/icons/logotype.png
  AssetGenImage get logotype =>
      const AssetGenImage('assets/icons/logotype.png');

  /// File path: assets/icons/main.svg
  String get main => 'assets/icons/main.svg';

  /// File path: assets/icons/operation.svg
  String get operation => 'assets/icons/operation.svg';

  /// File path: assets/icons/profile_user.svg
  String get profileUser => 'assets/icons/profile_user.svg';

  /// File path: assets/icons/ru.png
  AssetGenImage get ru => const AssetGenImage('assets/icons/ru.png');

  /// File path: assets/icons/setting.svg
  String get setting => 'assets/icons/setting.svg';

  /// File path: assets/icons/success_check.png
  AssetGenImage get successCheck =>
      const AssetGenImage('assets/icons/success_check.png');

  /// File path: assets/icons/uk.png
  AssetGenImage get uk => const AssetGenImage('assets/icons/uk.png');

  /// File path: assets/icons/user.svg
  String get user => 'assets/icons/user.svg';

  /// List of all assets
  List<dynamic> get values => [
    appstore,
    calendar,
    comeout,
    delete,
    edit,
    eye,
    folder1,
    folder2,
    folder3,
    home,
    income,
    kg,
    logoSoftkg,
    logotype,
    main,
    operation,
    profileUser,
    ru,
    setting,
    successCheck,
    uk,
    user,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/cardimage.png
  AssetGenImage get cardimage =>
      const AssetGenImage('assets/images/cardimage.png');

  /// File path: assets/images/vector_all.svg
  String get vectorAll => 'assets/images/vector_all.svg';

  /// File path: assets/images/vector_down.svg
  String get vectorDown => 'assets/images/vector_down.svg';

  /// File path: assets/images/vector_up.svg
  String get vectorUp => 'assets/images/vector_up.svg';

  /// List of all assets
  List<dynamic> get values => [cardimage, vectorAll, vectorDown, vectorUp];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
