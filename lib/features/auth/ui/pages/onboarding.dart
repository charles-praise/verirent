// =============================================================================
//  VeriRent NG — Onboarding Screen
//  Nixel Technology Global | May 2026
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/agents_theme.dart';

// ---------------------------------------------------------------------------
//  Onboarding slide data
// ---------------------------------------------------------------------------

class _OnboardSlide {
  const _OnboardSlide({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.icon,
    required this.accentColor,
    required this.tag,
  });

  final String title;
  final String subtitle;
  final String body;
  final IconData icon;
  final Color accentColor;
  final String tag; // small chip label above title
}

const List<_OnboardSlide> _kSlides = [
  _OnboardSlide(
    tag: 'NIGERIA\'S FIRST',
    title: 'A Marketplace\nBuilt on Trust',
    subtitle: 'Professional certification for every rental.',
    body:
        'VeriRent NG connects certified estate agencies and '
        'verified landlords with tenants who deserve protection. '
        'Every listing is badge-checked before it goes live.',
    icon: Icons.verified_outlined,
    accentColor: VeriRentColors.primary500,
  ),
  _OnboardSlide(
    tag: 'ESVARBON CERTIFIED',
    title: 'Real Agencies.\nReal Credentials.',
    subtitle: 'ESVARBON & NIESV verified professionals only.',
    body:
        'Every agency on the platform is validated against the '
        'ESVARBON register. CAC documents, office checks, and '
        'professional licenses — all confirmed before listing.',
    icon: Icons.business_center_outlined,
    accentColor: VeriRentColors.secondary500,
  ),
  _OnboardSlide(
    tag: 'TENANT FIRST',
    title: 'Rent with\nConfidence',
    subtitle: 'Rivers State law-compliant documentation.',
    body:
        'Standardized tenancy agreements, Notice to Quit '
        'templates, and in-app dispute resolution. Know '
        'your rights — every step is documented.',
    icon: Icons.shield_outlined,
    accentColor: VeriRentColors.success500,
  ),
];

// ---------------------------------------------------------------------------
//  OnboardingScreen widget
// ---------------------------------------------------------------------------

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onComplete});

  /// Called when the user taps "Get Started" on the last slide.
  final VoidCallback? onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _kSlides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onComplete?.call();
    }
  }

  void _skip() => widget.onComplete?.call();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: VeriRentColors.primary900,
        body: Stack(
          children: [
            // ── Background gradient that shifts with page ──────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _kSlides[_page].accentColor.withOpacity(0.95),
                    VeriRentColors.primary900,
                  ],
                ),
              ),
            ),

            // ── Decorative circles ─────────────────────────────────────────
            Positioned(
              top: -60,
              right: -60,
              child: _DecorCircle(size: 220, opacity: 0.07),
            ),
            Positioned(
              bottom: size.height * 0.3,
              left: -80,
              child: _DecorCircle(size: 180, opacity: 0.05),
            ),

            // ── Main content ───────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _page < _kSlides.length - 1 ? _skip : null,
                      style: TextButton.styleFrom(
                        foregroundColor: VeriRentColors.white.withOpacity(0.7),
                        padding: const EdgeInsets.fromLTRB(0, 12, 20, 0),
                      ),
                      child: Text(
                        'Skip',
                        style: VeriRentText.labelLarge.copyWith(
                          color: _page < _kSlides.length - 1
                              ? VeriRentColors.white.withOpacity(0.7)
                              : VeriRentColors.transparent,
                        ),
                      ),
                    ),
                  ),

                  // Page slides
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _kSlides.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (context, i) =>
                          _SlideContent(slide: _kSlides[i]),
                    ),
                  ),

                  // Dot indicators + CTA
                  _BottomControls(
                    totalPages: _kSlides.length,
                    currentPage: _page,
                    isLastPage: _page == _kSlides.length - 1,
                    onNext: _next,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Slide content
// ---------------------------------------------------------------------------

class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final _OnboardSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero icon inside frosted card
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: VeriRentColors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(VeriRentRadius.xl),
                border: Border.all(
                  color: VeriRentColors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(slide.icon, size: 52, color: VeriRentColors.white),
            ),
          ),

          const SizedBox(height: 36),

          // Tag chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: VeriRentSpacing.sm,
              vertical: VeriRentSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: VeriRentColors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(VeriRentRadius.full),
              border: Border.all(
                color: VeriRentColors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              slide.tag,
              style: VeriRentText.labelSmall.copyWith(
                color: VeriRentColors.white,
                letterSpacing: 1.4,
              ),
            ),
          ),

          const SizedBox(height: VeriRentSpacing.md),

          // Title
          Text(
            slide.title,
            style: VeriRentText.displaySmall.copyWith(
              color: VeriRentColors.white,
              fontFamily: 'Georgia',
              height: 1.2,
            ),
          ),

          const SizedBox(height: VeriRentSpacing.sm),

          // Subtitle
          Text(
            slide.subtitle,
            style: VeriRentText.titleMedium.copyWith(
              color: VeriRentColors.secondary300,
            ),
          ),

          const SizedBox(height: VeriRentSpacing.base),

          // Body
          Text(
            slide.body,
            style: VeriRentText.bodyMedium.copyWith(
              color: VeriRentColors.white.withOpacity(0.75),
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Bottom controls (dots + CTA button)
// ---------------------------------------------------------------------------

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.totalPages,
    required this.currentPage,
    required this.isLastPage,
    required this.onNext,
  });

  final int totalPages;
  final int currentPage;
  final bool isLastPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          // Dot indicators
          Row(
            children: List.generate(
              totalPages,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(right: 6),
                width: currentPage == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == i
                      ? VeriRentColors.white
                      : VeriRentColors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(VeriRentRadius.full),
                ),
              ),
            ),
          ),

          const Spacer(),

          // CTA button
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isLastPage
                  ? VeriRentColors.secondary500
                  : VeriRentColors.white,
              borderRadius: BorderRadius.circular(VeriRentRadius.full),
              boxShadow: [
                BoxShadow(
                  color:
                      (isLastPage
                              ? VeriRentColors.secondary500
                              : VeriRentColors.white)
                          .withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: VeriRentColors.transparent,
              child: InkWell(
                onTap: onNext,
                borderRadius: BorderRadius.circular(VeriRentRadius.full),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLastPage ? 24 : 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLastPage) ...[
                        Text(
                          'Get Started',
                          style: VeriRentText.labelLarge.copyWith(
                            color: VeriRentColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Icon(
                        isLastPage
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                        size: 20,
                        color: isLastPage
                            ? VeriRentColors.white
                            : VeriRentColors.primary700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Decorative circle
// ---------------------------------------------------------------------------

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: VeriRentColors.white.withOpacity(opacity),
      ),
    );
  }
}
