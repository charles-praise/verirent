// =============================================================================
//  9.  RATE VERIRENT NG PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';

class RateAppPage extends StatefulWidget {
  const RateAppPage({super.key});

  @override
  State<RateAppPage> createState() => _RateAppPageState();
}

class _RateAppPageState extends State<RateAppPage> {
  int _rating = 0;
  final _reviewCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap a star to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SubPageAppBar(title: 'Rate VeriRent NG')),
            if (_submitted)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 16),
                      Text(
                        'Thank you for your feedback!',
                        style: VeriRentText.headlineMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your review helps us improve VeriRent NG.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // App icon area
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.lg,
                          ),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.lg,
                                ),
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'VeriRent NG',
                              style: VeriRentText.titleLarge.copyWith(
                                color: cs.onSurface,
                              ),
                            ),
                            Text(
                              'How would you rate your experience?',
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final filled = i < _rating;
                                return GestureDetector(
                                  onTap: () => setState(() => _rating = i + 1),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      filled
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: 40,
                                      color: filled
                                          ? VeriRentColors.gold
                                          : cs.outlineVariant,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: Text(
                                _ratingLabel,
                                key: ValueKey(_rating),
                                style: VeriRentText.titleSmall.copyWith(
                                  color: _rating > 0
                                      ? VeriRentColors.gold
                                      : cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Review text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.lg,
                          ),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: TextField(
                          controller: _reviewCtrl,
                          maxLines: 4,
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Share more about your experience (optional)…',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      FilledButton(
                        onPressed: _rating == 0
                            ? null
                            : () {
                                if (_rating >= 4) {
                                  // Direct to store for 4/5 stars
                                  setState(() => _submitted = true);
                                } else {
                                  setState(() => _submitted = true);
                                }
                              },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Submit Review'),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Maybe Later'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
