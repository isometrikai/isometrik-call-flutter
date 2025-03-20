import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class CustomImage extends StatelessWidget {
  const CustomImage.asset(
    this.path, {
    super.key,
    this.name = 'U',
    this.isProfileImage = false,
    this.dimensions,
    this.height,
    this.width,
    this.radius,
    this.borderRadius,
    this.border,
    this.fromPackage = true,
    this.padding,
  })  : _imageType = CallImageType.asset,
        showError = false,
        color = null;

  const CustomImage.svg(
    this.path, {
    super.key,
    this.name = 'U',
    this.isProfileImage = false,
    this.dimensions,
    this.height,
    this.width,
    this.radius,
    this.color,
    this.borderRadius,
    this.border,
    this.fromPackage = true,
    this.padding,
  })  : _imageType = CallImageType.svg,
        showError = false;

  const CustomImage.network(
    this.path, {
    super.key,
    required this.name,
    this.isProfileImage = false,
    this.dimensions,
    this.height,
    this.width,
    this.radius,
    this.borderRadius,
    this.border,
    this.fromPackage = true,
    this.showError = true,
    this.padding,
  })  : _imageType = CallImageType.network,
        color = null;

  const CustomImage.file(
    this.path, {
    super.key,
    this.name = 'U',
    this.isProfileImage = true,
    this.dimensions,
    this.height,
    this.width,
    this.radius,
    this.borderRadius,
    this.border,
    this.fromPackage = true,
    this.padding,
  })  : _imageType = CallImageType.file,
        showError = false,
        color = null;

  final String path;
  final String name;
  final bool isProfileImage;
  final double? dimensions;
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final BorderRadius? borderRadius;
  final CallImageType _imageType;
  final bool fromPackage;
  final Border? border;
  final bool showError;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Container(
        height: height ?? dimensions,
        width: width ?? dimensions,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: isProfileImage
              ? null
              : borderRadius ?? BorderRadius.circular(radius ?? 0),
          shape: isProfileImage ? BoxShape.circle : BoxShape.rectangle,
          border: border,
        ),
        clipBehavior: Clip.antiAlias,
        child: switch (_imageType) {
          CallImageType.asset => _Asset(path, fromPackage: fromPackage),
          CallImageType.svg =>
            _Svg(path, fromPackage: fromPackage, color: color),
          CallImageType.file => _File(path),
          CallImageType.network => _Network(
              path,
              isProfileImage: isProfileImage,
              name: name,
              showError: showError,
            ),
        },
      );
}

class _Asset extends StatelessWidget {
  const _Asset(this.path, {required this.fromPackage});

  final String path;
  final bool fromPackage;

  @override
  Widget build(BuildContext context) => Image.asset(
        path,
        package: fromPackage ? AppConstants.packageName : null,
      );
}

class _File extends StatelessWidget {
  const _File(this.path);

  final String path;

  @override
  Widget build(BuildContext context) => Image.file(
        File(path),
        fit: BoxFit.cover,
      );
}

class _Network extends StatelessWidget {
  const _Network(
    this.imageUrl, {
    required this.name,
    required this.isProfileImage,
    required this.showError,
  });

  final String imageUrl;
  final String name;
  final bool isProfileImage;
  final bool showError;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        cacheKey: imageUrl,
        imageBuilder: (_, image) {
          try {
            if (imageUrl.isEmpty) {
              _ErrorImage(
                isProfileImage: isProfileImage,
                name: name,
                showError: showError,
              );
            }
            return Container(
              decoration: BoxDecoration(
                shape: isProfileImage ? BoxShape.circle : BoxShape.rectangle,
                image: DecorationImage(image: image, fit: BoxFit.cover),
              ),
            );
          } catch (e) {
            return _ErrorImage(
              isProfileImage: isProfileImage,
              name: name,
              showError: showError,
            );
          }
        },
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CallColors.primary.applyOpacity(0.2),
            shape: isProfileImage ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: isProfileImage && name.trim().isNotEmpty
              ? Text(
                  name[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: CallColors.black,
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
        errorWidget: (context, url, error) => _ErrorImage(
          isProfileImage: isProfileImage,
          name: name,
          showError: showError,
        ),
      );
}

class _Svg extends StatelessWidget {
  const _Svg(
    this.path, {
    this.color,
    required this.fromPackage,
  });

  final String path;
  final Color? color;

  final bool fromPackage;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        path,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
        package: fromPackage ? AppConstants.packageName : null,
      );
}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage({
    required this.isProfileImage,
    required this.name,
    required this.showError,
  });

  final bool isProfileImage;
  final String name;
  final bool showError;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isProfileImage ? CallColors.cardLight : CallColors.secondary,
          shape: isProfileImage ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: !showError || isProfileImage
            ? Text(
                name.trim().isEmpty ? '' : name[0].toUpperCase(),
                style: !isProfileImage
                    ? context.textTheme.displayMedium?.copyWith(
                        color: CallColors.black,
                        fontWeight: FontWeight.bold,
                      )
                    : context.textTheme.titleSmall?.copyWith(
                        color: CallColors.white,
                        fontWeight: FontWeight.bold,
                      ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: CallColors.secondary,
                  borderRadius: BorderRadius.circular(
                    Dimens.eight,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  CallStrings.errorLoadingImage,
                ),
              ),
      );
}
