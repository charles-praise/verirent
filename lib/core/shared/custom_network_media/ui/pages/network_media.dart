import 'package:flutter/material.dart';

import '../../domain/entities/media_types.dart';
import '../../utilities/media_detector.dart';
import 'network_image.dart';
import 'network_video.dart';

class CustomNetworkMedia extends StatelessWidget {
  const CustomNetworkMedia({
    super.key,
    required this.url,
    this.borderRadius = BorderRadius.zero,
    this.autoPlay = true,
    this.loop = false,
  });

  final String url;
  final BorderRadius borderRadius;
  final bool autoPlay;
  final bool loop;

  @override
  Widget build(BuildContext context) {
    final mediaType = MediaDetector.detect(url);

    switch (mediaType) {
      case MediaType.image:
        return NetworkImageWidget(url: url, borderRadius: borderRadius);

      case MediaType.video:
        return NetworkVideoWidget(
          url: url,
          borderRadius: borderRadius,
          autoPlay: autoPlay,
          loop: loop,
        );
    }
  }
}
