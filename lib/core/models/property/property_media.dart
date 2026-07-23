enum MediaType { image, video, virtualTour, document }

class MediaItem {
  const MediaItem({required this.url, required this.type});

  final String url;
  final MediaType type;

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      url: json['url'] as String,
      type: MediaType.values[json['type'] as int],
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'type': type.index};
}

/// Everything about a property's photos/videos. Replaces the single
/// `emoji` placeholder field and the untyped `mediaUrls` list — each item
/// now knows whether it's a photo, video, or virtual tour, so the UI
/// doesn't have to guess from a file extension.
class PropertyMedia {
  const PropertyMedia({this.items, this.thumbnailUrl});

  final List<MediaItem>? items;
  final String? thumbnailUrl;

  bool get hasVideo => items?.any((i) => i.type == MediaType.video) ?? false;

  factory PropertyMedia.fromJson(Map<String, dynamic> json) {
    return PropertyMedia(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((i) => i.toJson()).toList(),
    'thumbnailUrl': thumbnailUrl,
  };
}
