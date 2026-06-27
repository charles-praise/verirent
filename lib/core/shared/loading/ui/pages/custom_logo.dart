// =============================================================================
//  VeriRent NG — Custom Animated Logo
//  Professional logo animations for different states
// =============================================================================
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';
import 'package:verirent/core/theme/agents_theme.dart';

// ── Animated Loading Logo ───────────────────────────────────────────────────
class AnimatedLoadingLogo extends StatefulWidget {
  const AnimatedLoadingLogo({
    super.key,
    this.size = 80,
    this.duration = const Duration(seconds: 2),
  });

  final double size;
  final Duration duration;

  @override
  State<AnimatedLoadingLogo> createState() => _AnimatedLoadingLogoState();
}

class _AnimatedLoadingLogoState extends State<AnimatedLoadingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();

    _rotation = Tween<double>(
      begin: 0,
      end: 360,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _scale = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(scale: _scale, child: PulsingRingLoader()),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VeriRentColors.primary600, VeriRentColors.primary500],
        ),
        boxShadow: [
          BoxShadow(
            color: VeriRentColors.primary600.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'V',
          style: VeriRentText.headlineLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Animated Success Logo ───────────────────────────────────────────────────
class AnimatedSuccessLogo extends StatefulWidget {
  const AnimatedSuccessLogo({super.key, this.size = 100});

  final double size;

  @override
  State<AnimatedSuccessLogo> createState() => _AnimatedSuccessLogoState();
}

class _AnimatedSuccessLogoState extends State<AnimatedSuccessLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _checkmarkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _checkmarkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      VeriRentColors.success500,
                      VeriRentColors.success200,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: VeriRentColors.success500.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              // Checkmark icon
              ScaleTransition(
                scale: _checkmarkAnimation,
                child: Icon(
                  Icons.check_rounded,
                  size: widget.size * 0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Animated Decline Logo ───────────────────────────────────────────────────
class AnimatedDeclineLogo extends StatefulWidget {
  const AnimatedDeclineLogo({super.key, this.size = 100});

  final double size;

  @override
  State<AnimatedDeclineLogo> createState() => _AnimatedDeclineLogoState();
}

class _AnimatedDeclineLogoState extends State<AnimatedDeclineLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticIn),
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Transform.translate(
            offset: Offset(
              _shakeAnimation.value *
                  10 *
                  ((_shakeAnimation.value * 2 - 1).abs() * 2 - 1),
              0,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [VeriRentColors.red, Color(0xFFD32F2F)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: VeriRentColors.red.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                // X icon
                Icon(
                  Icons.close_rounded,
                  size: widget.size * 0.5,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Progress Bar with percentage ────────────────────────────────────────────
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.borderRadius = 3,
  });

  final double progress;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: height,
            backgroundColor: cs.outlineVariant.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(VeriRentColors.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${progress.toStringAsFixed(0)}%',
          style: VeriRentText.bodySmall.copyWith(
            color: VeriRentColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Bouncing Dots Loading Indicator ─────────────────────────────────────────
class BouncingDotsLoader extends StatefulWidget {
  const BouncingDotsLoader({
    super.key,
    this.size = 8,
    this.dotColor = VeriRentColors.primary,
  });

  final double size;
  final Color dotColor;

  @override
  State<BouncingDotsLoader> createState() => _BouncingDotsLoaderState();
}

class _BouncingDotsLoaderState extends State<BouncingDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _BouncingDot(
              animation: _controller,
              delay: index * 0.2,
              size: widget.size,
              color: widget.dotColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _BouncingDot extends StatelessWidget {
  const _BouncingDot({
    required this.animation,
    required this.delay,
    required this.size,
    required this.color,
  });

  final AnimationController animation;
  final double delay;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _getSine(animation.value, delay) * 15),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)],
        ),
      ),
    );
  }

  double _getSine(double value, double delay) {
    return -1 *
        (math.sin((value * 2 * math.pi) + (delay * 2 * math.pi)) + 1) /
        2;
  }
}

// ── Pulsing Ring Loader ─────────────────────────────────────────────────────
class PulsingRingLoader extends StatefulWidget {
  const PulsingRingLoader({super.key, this.size = 80});

  final double size;

  @override
  State<PulsingRingLoader> createState() => _PulsingRingLoaderState();
}

class _PulsingRingLoaderState extends State<PulsingRingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing rings
          ...List.generate(
            3,
            (index) => ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  width: widget.size - (index * 20),
                  height: widget.size - (index * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: VeriRentColors.primary, width: 2),
                  ),
                ),
              ),
            ),
          ),
          // Center logo
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [VeriRentColors.primary600, VeriRentColors.primary500],
              ),
            ),
            child: CustomNetworkImage(imgUrl: ''),
          ),
        ],
      ),
    );
  }
}
