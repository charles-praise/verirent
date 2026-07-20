import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoWidget extends StatefulWidget {
  const NetworkVideoWidget({
    super.key,
    required this.url,
    this.borderRadius = BorderRadius.zero,
    this.autoPlay = false,
    this.loop = false,
  });

  final String url;
  final BorderRadius borderRadius;
  final bool autoPlay;
  final bool loop;

  @override
  State<NetworkVideoWidget> createState() => _NetworkVideoWidgetState();
}

class _NetworkVideoWidgetState extends State<NetworkVideoWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _loading = true;
  bool _hasError = false;

  BoxFit _fit = BoxFit.cover;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (widget.url.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _loading = false;
          _hasError = true;
        });
      }
      return;
    }

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );

      await _videoController!.initialize().timeout(const Duration(seconds: 15));

      _videoController!.setLooping(widget.loop);

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: widget.autoPlay,
        looping: widget.loop,
        allowMuting: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
          bufferedColor: Colors.white54,
          backgroundColor: Colors.white24,
        ),
      );

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e, s) {
      debugPrint("VIDEO ERROR");
      debugPrint(e.toString());
      debugPrint(s.toString());

      if (mounted) {
        setState(() {
          _loading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _retry() async {
    _chewieController?.dispose();
    await _videoController?.dispose();

    _chewieController = null;
    _videoController = null;

    if (mounted) {
      setState(() {
        _loading = true;
        _hasError = false;
      });
    }

    await _initialize();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _VideoShimmer(borderRadius: widget.borderRadius);
    }

    if (_hasError ||
        _videoController == null ||
        _chewieController == null ||
        !_videoController!.value.isInitialized) {
      return ClipRRect(
        borderRadius: widget.borderRadius,
        child: Container(
          color: Colors.black12,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.video_library_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Unable to load video",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _retry, child: const Text("Retry")),
              ],
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: _fit,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: Chewie(controller: _chewieController!),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<BoxFit>(
              color: Colors.black87,
              icon: const Icon(Icons.fit_screen, color: Colors.white),
              onSelected: (fit) {
                setState(() {
                  _fit = fit;
                });
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: BoxFit.cover, child: Text("Cover")),
                PopupMenuItem(value: BoxFit.contain, child: Text("Contain")),
                PopupMenuItem(value: BoxFit.fill, child: Text("Fill")),
                PopupMenuItem(value: BoxFit.fitWidth, child: Text("Fit Width")),
                PopupMenuItem(
                  value: BoxFit.fitHeight,
                  child: Text("Fit Height"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoShimmer extends StatelessWidget {
  const _VideoShimmer({required this.borderRadius});

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
