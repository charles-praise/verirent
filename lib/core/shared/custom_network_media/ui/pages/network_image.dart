import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.url,
    required this.borderRadius,
  });

  final String url;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

        placeholder: (context, string) =>
            Center(child: _ImageShimmer(borderRadius: borderRadius)),

        errorWidget: (context, string, object) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primaryContainer, colors.secondaryContainer],
              ),
            ),
            child: const Center(
              child: Text(
                "Image Not Found!",
                style: TextStyle(fontSize: 40),
              ), //🏢
            ),
          );
        },
      ),
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(color: Colors.white),
        ),
      ),
    );
  }
}
