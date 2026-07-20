import '../domain/entities/media_types.dart';

abstract final class MediaDetector {
  static const Set<String> _videoExtensions = {
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
    '.3gp',
    '.m4v',
    '.m3u8',
  };

  static MediaType detect(String url) {
    final path = Uri.parse(url).path.toLowerCase();

    for (final extension in _videoExtensions) {
      if (path.endsWith(extension)) {
        return MediaType.video;
      }
    }

    return MediaType.image;
  }
}
