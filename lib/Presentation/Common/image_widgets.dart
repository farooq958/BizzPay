import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:flutter/material.dart';

class AssetImageWidget extends StatelessWidget {
  final String url;
  final double? scale;
  final double? width;
  final double? height;
  final Color? color;
  final bool? isCircle;
  final double? radius;

  const AssetImageWidget({
    Key? key,
    required this.url,
    this.scale = 1,
    this.width = 25,
    this.height = 25,
    this.color,
    this.isCircle,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCircle != null
        ? CircleAvatar(
            radius: radius,
            backgroundColor: color,
            backgroundImage: AssetImage(url))
        : Image.asset(
            url,
            fit: BoxFit.fill,
            color: color,
            errorBuilder: (context, url, error) {
              return isCircle == true
                  ? CircleAvatar(
                      radius: radius,
                      backgroundImage: const AssetImage(Assets.appLogo))
                  : Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/hbk-blankets.appspot.com/o/logo.png?alt=media&token=409f2508-9b66-44ac-9c82-ec19a1046cd6",
                      width: width ?? 110,
                      height: height ?? 110,
                    );
            },
            width: width == null ? null : width! * scale!,
            height: height == null ? null : height! * scale!,
          );
  }
}

class CachedImage extends StatelessWidget {
  final String url;
  final double? scale;
  final double? radius;
  final bool? isCircle;
  final double? containerRadius;
  final double? bottomRadius;
  final double? topRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final bool? isFromProfilePic;

  const CachedImage({
    super.key,
    required this.url,
    this.scale = 1,
    this.radius = 50,
    this.isCircle = true,
    this.containerRadius = 0,
    this.topRadius,
    this.bottomRadius,
    this.fit = BoxFit.fill,
    this.height,
    this.isFromProfilePic,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => isCircle!
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : Container(
              width: height,
              height: width,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(containerRadius!),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
      errorWidget: (context, url, error) {
        return isCircle!
            ? CircleAvatar(
                radius: radius,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(isFromProfilePic == true
                    ? Assets.splashUserAvatar
                    : "https://firebasestorage.googleapis.com/v0/b/chat-app-7b215.appspot.com/o/193298F6-A7FE-42E0-9894-32C170239AD7_1-removebg-preview.png?alt=media&token=4e2e8c7d-4a81-4cd0-b6b0-8b17490988fe"))
            : Image.network(
                isFromProfilePic == true
                    ? Assets.splashUserAvatar
                    : "https://firebasestorage.googleapis.com/v0/b/chat-app-7b215.appspot.com/o/193298F6-A7FE-42E0-9894-32C170239AD7_1-removebg-preview.png?alt=media&token=4e2e8c7d-4a81-4cd0-b6b0-8b17490988fe",
                width: width ?? 110,
                height: height ?? 110,
              );
      },
      imageBuilder: (context, imageProvider) => isCircle!
          ? CircleAvatar(
              radius: radius,
              backgroundImage: imageProvider,
            )
          : ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(topRadius ?? containerRadius!),
                topLeft: Radius.circular(topRadius ?? containerRadius!),
                bottomLeft: Radius.circular(bottomRadius ?? containerRadius!),
                bottomRight: Radius.circular(bottomRadius ?? containerRadius!),
              ),
              child: Image(
                image: imageProvider,
                width: width,
                height: height,
                fit: fit,
              ),
            ),
    );
  }
}

class InboxImage extends StatelessWidget {
  final String url;
  final double? scale;
  final double? radius;
  final bool? isCircle;
  final double? containerRadius;
  final double? bottomRadius;
  final double? topRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const InboxImage({
    super.key,
    required this.url,
    this.scale = 1,
    this.radius = 50,
    this.isCircle = true,
    this.containerRadius = 0,
    this.topRadius,
    this.bottomRadius,
    this.fit = BoxFit.fill,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
