import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleUserAvatar extends StatelessWidget {
  final double? width;
  final double? height;
  final String? url;

  const CircleUserAvatar({super.key, this.width, this.height, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 30,
      height: height ?? 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: CachedNetworkImageProvider(url ?? ''),fit: BoxFit.cover),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ]
      ),
    );
  }
}
