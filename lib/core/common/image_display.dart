import 'package:flutter/material.dart';
import 'package:vlogify/core/constants/constants.dart';
import 'package:vlogify/core/enums/enums.dart';

class ImageDisplayWidget extends StatelessWidget {
  final String imagePath;
  final ImageType imageType;

  const ImageDisplayWidget({
    super.key,
    required this.imagePath,
    required this.imageType,
  });

  Image getImage() {
    switch (imageType) {
      case ImageType.asset:
        return Image.asset(imagePath);
      case ImageType.network:
        return Image.network(imagePath);
      default:
        return Image.asset(Constants.placeHolder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: getImage());
  }
}
