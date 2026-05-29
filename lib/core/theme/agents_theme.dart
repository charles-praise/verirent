// =============================================================================
//  VeriRent NG — Design System & Theme
//  Nixel Technology Global
//  Version: 1.0.0 | May 2026
//
//  Usage:
//    MaterialApp(
//      theme:      VeriRentTheme.light,
//      darkTheme:  VeriRentTheme.dark,
//      themeMode:  ThemeMode.system,
//    )
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =============================================================================
//  SECTION 1 — BRAND PALETTE
//  All raw hex values live here. Nothing else should hard-code a color.
// =============================================================================

abstract final class VeriRentColors {
  // ── Primary — Deep Teal ──────────────────────────────────────────────────
  // The authority color. Used for primary actions, headers, key UI chrome.
  static const Color primary50 = Color(0xFFE6F4F6);
  static const Color primary100 = Color(0xFFBFE3E8);
  static const Color primary200 = Color(0xFF93D0D8);
  static const Color primary300 = Color(0xFF62BCC8);
  static const Color primary400 = Color(0xFF3AADBB);
  static const Color primary500 = Color(0xFF007B8A); // ← brand primary
  static const Color primary600 = Color(0xFF006E7C);
  static const Color primary700 = Color(0xFF005D69);
  static const Color primary800 = Color(0xFF004D57);
  static const Color primary900 = Color(0xFF003640);
  static const bg = Color(0xFF07090F); // --bg
  static const surface = Color(0xFF0F1420); // --surface
  static const surface2 = Color(0xFF161C2D); // --surface2
  static const surface3 = Color(0xFF1C2540); // --surface3
  static const border = Color(0x12FFFFFF); // --border
  static const primary = Color(0xFF00C9A7); // --primary
  static const primaryDim = Color(0x1F00C9A7); // --primary-dim
  static const primaryGlow = Color(0x5900C9A7); // --primary-glow
  static const gold = Color(0xFFF0C060); // --gold
  static const goldDim = Color(0x1FF0C060); // --gold-dim
  static const text = Color(0xFFF0F4FF); // --text
  static const textMuted = Color(0xFF8892A4); // --text-muted
  static const textDim = Color(0xFF4A5568); // --text-dim
  static const red = Color(0xFFFF5A5F); // --red
  static const green = Color(0xFF4ADE80);

  // ── Secondary — Warm Gold ────────────────────────────────────────────────
  // The trust signal. Certification badges, highlights, premium indicators.
  static const Color secondary50 = Color(0xFFFDF6E3);
  static const Color secondary100 = Color(0xFFF9E8B8);
  static const Color secondary200 = Color(0xFFF4D889);
  static const Color secondary300 = Color(0xFFEFC85A);
  static const Color secondary400 = Color(0xFFDDB235);
  static const Color secondary500 = Color(0xFFC9A84C); // ← brand gold
  static const Color secondary600 = Color(0xFFB89040);
  static const Color secondary700 = Color(0xFF9E7A33);
  static const Color secondary800 = Color(0xFF826328);
  static const Color secondary900 = Color(0xFF5E4719);

  // ── Neutral — Slate Navy ─────────────────────────────────────────────────
  // Document text, surfaces, subtle backgrounds.
  static const Color neutral50 = Color(0xFFF2F4F6);
  static const Color neutral100 = Color(0xFFE2E6EB);
  static const Color neutral200 = Color(0xFFC8CDD5);
  static const Color neutral300 = Color(0xFFACB3BE);
  static const Color neutral400 = Color(0xFF8E97A4);
  static const Color neutral500 = Color(0xFF707A88);
  static const Color neutral600 = Color(0xFF545E6C);
  static const Color neutral700 = Color(0xFF3A4350);
  static const Color neutral800 = Color(0xFF242D38); // dark surface base
  static const Color neutral900 = Color(0xFF131920); // darkest

  // ── Semantic — Success ───────────────────────────────────────────────────
  // Verified badges, KYC passed, active listing status.
  static const Color success50 = Color(0xFFE8F5E9);
  static const Color success200 = Color(0xFFA5D6A7);
  static const Color success500 = Color(0xFF2E7D32);
  static const Color success700 = Color(0xFF1B5E20);

  // ── Semantic — Warning ───────────────────────────────────────────────────
  // Pending review, incomplete KYC, expiring subscriptions.
  static const Color warning50 = Color(0xFFFFF8E1);
  static const Color warning200 = Color(0xFFFFE082);
  static const Color warning500 = Color(0xFFF9A825);
  static const Color warning700 = Color(0xFFE65100);

  // ── Semantic — Error ─────────────────────────────────────────────────────
  // Disputes, fraud flags, failed verification.
  static const Color error50 = Color(0xFFFFEBEE);
  static const Color error200 = Color(0xFFEF9A9A);
  static const Color error500 = Color(0xFFC62828);
  static const Color error700 = Color(0xFFB71C1C);

  // ── Semantic — Info ──────────────────────────────────────────────────────
  // Informational banners, help tooltips.
  static const Color info50 = Color(0xFFE3F2FD);
  static const Color info200 = Color(0xFF90CAF9);
  static const Color info500 = Color(0xFF1565C0);
  static const Color info700 = Color(0xFF0D47A1);

  // ── Trust Tier Badge Colors ──────────────────────────────────────────────
  // Visual identity for each verification tier.
  static const Color tierBasic = Color(0xFF90A4AE); // slate grey
  static const Color tierVerified = Color(0xFF3AADBB); // teal (primary400)
  static const Color tierPro = Color(0xFFC9A84C); // gold
  static const Color tierStarterAgency = Color(0xFF2E7D32); // green
  static const Color tierProfessional = Color(0xFF0D47A1); // deep blue
  static const Color tierEnterprise = Color(0xFF4A148C); // deep purple

  // ── Absolute ─────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
}

// =============================================================================
//  SECTION 2 — TYPOGRAPHY SCALE
//  Uses system fonts for reliability, with refined weight/tracking control.
// =============================================================================

abstract final class VeriRentText {
  // Display — hero section headings, splash screen
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Georgia', // serif for trust/authority feel
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.15,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.25,
    overflow: TextOverflow.ellipsis,
  );

  // Headline — section titles, card headers
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.3,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );

  // Title — list items, app bars, dialog titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    overflow: TextOverflow.ellipsis,
  );

  // Body — paragraph text, descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.55,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    overflow: TextOverflow.ellipsis,
  );

  // Label — buttons, tags, caps text, chips
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.3,
    overflow: TextOverflow.ellipsis,
  );
}

// =============================================================================
//  SECTION 3 — SPACING, RADIUS & ELEVATION
// =============================================================================

abstract final class VeriRentSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

abstract final class VeriRentRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 100.0; // pill-shaped chips, badges
}

abstract final class VeriRentElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 4;
  static const double high = 8;
  static const double modal = 16;
}

// =============================================================================
//  SECTION 4 — LIGHT THEME COLOR SCHEME
// =============================================================================

const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary — teal hierarchy
  primary: VeriRentColors.primary500,
  onPrimary: VeriRentColors.white,
  primaryContainer: VeriRentColors.primary100,
  onPrimaryContainer: VeriRentColors.primary800,

  // Secondary — gold hierarchy
  secondary: VeriRentColors.secondary500,
  onSecondary: VeriRentColors.white,
  secondaryContainer: VeriRentColors.secondary100,
  onSecondaryContainer: VeriRentColors.secondary800,

  // Tertiary — used for success states & verified badges
  tertiary: VeriRentColors.success500,
  onTertiary: VeriRentColors.white,
  tertiaryContainer: VeriRentColors.success50,
  onTertiaryContainer: VeriRentColors.success700,

  // Error
  error: VeriRentColors.error500,
  onError: VeriRentColors.white,
  errorContainer: VeriRentColors.error50,
  onErrorContainer: VeriRentColors.error700,

  // Surfaces
  surface: VeriRentColors.white,
  onSurface: VeriRentColors.neutral900,
  surfaceVariant: VeriRentColors.neutral50,
  onSurfaceVariant: VeriRentColors.neutral600,

  // Outline
  outline: VeriRentColors.neutral300,
  outlineVariant: VeriRentColors.neutral200,

  // Background / inverse
  shadow: VeriRentColors.neutral900,
  scrim: Color(0x99131920),
  inverseSurface: VeriRentColors.neutral800,
  onInverseSurface: VeriRentColors.neutral50,
  inversePrimary: VeriRentColors.primary200,
  surfaceTint: VeriRentColors.primary500,
);

// =============================================================================
//  SECTION 5 — DARK THEME COLOR SCHEME
// =============================================================================

const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary — lighter teal for dark backgrounds
  primary: VeriRentColors.primary300,
  onPrimary: VeriRentColors.primary900,
  primaryContainer: VeriRentColors.primary800,
  onPrimaryContainer: VeriRentColors.primary100,

  // Secondary — warm gold, slightly toned for dark backgrounds
  secondary: VeriRentColors.secondary300,
  onSecondary: VeriRentColors.secondary900,
  secondaryContainer: VeriRentColors.secondary800,
  onSecondaryContainer: VeriRentColors.secondary100,

  // Tertiary
  tertiary: VeriRentColors.success200,
  onTertiary: VeriRentColors.success700,
  tertiaryContainer: VeriRentColors.success700,
  onTertiaryContainer: VeriRentColors.success50,

  // Error
  error: VeriRentColors.error200,
  onError: VeriRentColors.error700,
  errorContainer: VeriRentColors.error700,
  onErrorContainer: VeriRentColors.error50,

  // Surfaces — layered dark
  surface: VeriRentColors.neutral800, // main card / dialog bg
  onSurface: VeriRentColors.neutral50,
  surfaceVariant: VeriRentColors.neutral900, // scaffold bg
  onSurfaceVariant: VeriRentColors.neutral300,

  // Outline
  outline: VeriRentColors.neutral600,
  outlineVariant: VeriRentColors.neutral700,

  // Background / inverse
  shadow: VeriRentColors.black,
  scrim: Color(0xCC000000),
  inverseSurface: VeriRentColors.neutral100,
  onInverseSurface: VeriRentColors.neutral800,
  inversePrimary: VeriRentColors.primary500,
  surfaceTint: VeriRentColors.primary300,
);

// =============================================================================
//  SECTION 6 — COMPONENT THEMES (shared builder utilities)
// =============================================================================

AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
  backgroundColor: cs.surface,
  foregroundColor: cs.onSurface,
  elevation: 0,
  scrolledUnderElevation: 1,
  centerTitle: false,
  titleTextStyle: VeriRentText.titleLarge.copyWith(color: cs.onSurface),
  iconTheme: IconThemeData(color: cs.onSurface),
  actionsIconTheme: IconThemeData(color: cs.primary),
  systemOverlayStyle: cs.brightness == Brightness.light
      ? SystemUiOverlayStyle.dark
      : SystemUiOverlayStyle.light,
);

CardThemeData _cardTheme(ColorScheme cs) => CardThemeData(
  color: cs.surface,
  shadowColor: cs.shadow.withOpacity(0.08),
  elevation: VeriRentElevation.low,
  margin: const EdgeInsets.all(0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.lg),
    side: BorderSide(color: cs.outlineVariant, width: 1),
  ),
);

FilledButtonThemeData _filledButtonTheme(ColorScheme cs) =>
    FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        disabledBackgroundColor: cs.onSurface.withOpacity(0.12),
        disabledForegroundColor: cs.onSurface.withOpacity(0.38),
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: VeriRentText.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
        ),
        elevation: 0,
      ),
    );

OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.primary,
        disabledForegroundColor: cs.onSurface.withOpacity(0.38),
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: VeriRentText.labelLarge,
        side: BorderSide(color: cs.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
        ),
      ),
    );

TextButtonThemeData _textButtonTheme(ColorScheme cs) => TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: cs.primary,
    minimumSize: const Size(48, 40),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    textStyle: VeriRentText.labelLarge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
    ),
  ),
);

ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // Gold accent for premium / CTA actions
        backgroundColor: VeriRentColors.secondary500,
        foregroundColor: VeriRentColors.white,
        disabledBackgroundColor: cs.onSurface.withOpacity(0.12),
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: VeriRentText.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
        ),
        elevation: 2,
        shadowColor: VeriRentColors.secondary500.withOpacity(0.3),
      ),
    );

InputDecorationTheme _inputTheme(ColorScheme cs) => InputDecorationTheme(
  filled: true,
  fillColor: cs.surfaceVariant,
  hintStyle: VeriRentText.bodyMedium.copyWith(color: cs.onSurfaceVariant),
  labelStyle: VeriRentText.bodyMedium.copyWith(color: cs.onSurfaceVariant),
  floatingLabelStyle: VeriRentText.labelMedium.copyWith(color: cs.primary),
  prefixIconColor: cs.onSurfaceVariant,
  suffixIconColor: cs.onSurfaceVariant,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.outline, width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.outline, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.primary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.error, width: 1.5),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.error, width: 2),
  ),
  errorStyle: VeriRentText.bodySmall.copyWith(color: cs.error),
);

ChipThemeData _chipTheme(ColorScheme cs) => ChipThemeData(
  backgroundColor: cs.surfaceVariant,
  selectedColor: cs.primaryContainer,
  disabledColor: cs.onSurface.withOpacity(0.12),
  labelStyle: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
  secondaryLabelStyle: VeriRentText.labelMedium.copyWith(
    color: cs.onPrimaryContainer,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.full),
    side: BorderSide(color: cs.outlineVariant),
  ),
  elevation: 0,
  pressElevation: 1,
);

BottomNavigationBarThemeData _bottomNavTheme(ColorScheme cs) =>
    BottomNavigationBarThemeData(
      backgroundColor: cs.surface,
      selectedItemColor: cs.primary,
      unselectedItemColor: cs.onSurfaceVariant,
      selectedLabelStyle: VeriRentText.labelSmall.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: VeriRentText.labelSmall,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );

NavigationBarThemeData _navigationBarTheme(ColorScheme cs) =>
    NavigationBarThemeData(
      backgroundColor: cs.surface,
      indicatorColor: cs.primaryContainer,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(color: cs.onPrimaryContainer, size: 24);
        }
        return IconThemeData(color: cs.onSurfaceVariant, size: 24);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return VeriRentText.labelSmall.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w700,
          );
        }
        return VeriRentText.labelSmall.copyWith(color: cs.onSurfaceVariant);
      }),
      elevation: 0,
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );

TabBarThemeData _tabBarTheme(ColorScheme cs) => TabBarThemeData(
  labelColor: cs.primary,
  unselectedLabelColor: cs.onSurfaceVariant,
  labelStyle: VeriRentText.labelLarge,
  unselectedLabelStyle: VeriRentText.labelLarge.copyWith(
    fontWeight: FontWeight.w400,
  ),
  indicator: UnderlineTabIndicator(
    borderSide: BorderSide(color: cs.primary, width: 3),
    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
  ),
  indicatorSize: TabBarIndicatorSize.label,
  dividerColor: cs.outlineVariant,
);

DialogThemeData _dialogTheme(ColorScheme cs) => DialogThemeData(
  backgroundColor: cs.surface,
  surfaceTintColor: cs.surfaceTint,
  elevation: VeriRentElevation.modal,
  shadowColor: cs.shadow.withOpacity(0.2),
  titleTextStyle: VeriRentText.headlineMedium.copyWith(color: cs.onSurface),
  contentTextStyle: VeriRentText.bodyMedium.copyWith(
    color: cs.onSurfaceVariant,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.xl),
  ),
);

SnackBarThemeData _snackBarTheme(ColorScheme cs) => SnackBarThemeData(
  backgroundColor: cs.inverseSurface,
  contentTextStyle: VeriRentText.bodyMedium.copyWith(
    color: cs.onInverseSurface,
  ),
  actionTextColor: cs.inversePrimary,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
  ),
  elevation: VeriRentElevation.high,
);

ListTileThemeData _listTileTheme(ColorScheme cs) => ListTileThemeData(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  titleTextStyle: VeriRentText.bodyLarge.copyWith(color: cs.onSurface),
  subtitleTextStyle: VeriRentText.bodySmall.copyWith(
    color: cs.onSurfaceVariant,
  ),
  leadingAndTrailingTextStyle: VeriRentText.bodySmall.copyWith(
    color: cs.onSurfaceVariant,
  ),
  iconColor: cs.onSurfaceVariant,
  selectedColor: cs.primary,
  selectedTileColor: cs.primaryContainer.withOpacity(0.5),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
  ),
);

DividerThemeData _dividerTheme(ColorScheme cs) =>
    DividerThemeData(color: cs.outlineVariant, thickness: 1, space: 1);

FloatingActionButtonThemeData _fabTheme(ColorScheme cs) =>
    FloatingActionButtonThemeData(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      extendedTextStyle: VeriRentText.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
      ),
      elevation: VeriRentElevation.medium,
      focusElevation: VeriRentElevation.medium,
      hoverElevation: VeriRentElevation.high,
      highlightElevation: VeriRentElevation.high,
    );

SwitchThemeData _switchTheme(ColorScheme cs) => SwitchThemeData(
  thumbColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) return cs.onPrimary;
    return cs.outline;
  }),
  trackColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) return cs.primary;
    return cs.surfaceVariant;
  }),
  trackOutlineColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) return Colors.transparent;
    return cs.outline;
  }),
);

CheckboxThemeData _checkboxTheme(ColorScheme cs) => CheckboxThemeData(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) return cs.primary;
    return Colors.transparent;
  }),
  checkColor: MaterialStateProperty.all(cs.onPrimary),
  side: BorderSide(color: cs.outline, width: 2),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.xs),
  ),
);

RadioThemeData _radioTheme(ColorScheme cs) => RadioThemeData(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) return cs.primary;
    return cs.outline;
  }),
);

ProgressIndicatorThemeData _progressTheme(ColorScheme cs) =>
    ProgressIndicatorThemeData(
      color: cs.primary,
      circularTrackColor: cs.surfaceVariant,
      linearTrackColor: cs.surfaceVariant,
      linearMinHeight: 4,
      refreshBackgroundColor: cs.surface,
    );

TooltipThemeData _tooltipTheme(ColorScheme cs) => TooltipThemeData(
  decoration: BoxDecoration(
    color: cs.inverseSurface,
    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
  ),
  textStyle: VeriRentText.bodySmall.copyWith(color: cs.onInverseSurface),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
);

PopupMenuThemeData _popupMenuTheme(ColorScheme cs) => PopupMenuThemeData(
  color: cs.surface,
  elevation: VeriRentElevation.high,
  shadowColor: cs.shadow.withOpacity(0.15),
  textStyle: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
  labelTextStyle: MaterialStateProperty.all(
    VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
  ),
);

SearchBarThemeData _searchBarTheme(ColorScheme cs) => SearchBarThemeData(
  backgroundColor: MaterialStateProperty.all(cs.surfaceVariant),
  elevation: MaterialStateProperty.all(0),
  hintStyle: MaterialStateProperty.all(
    VeriRentText.bodyMedium.copyWith(color: cs.onSurfaceVariant),
  ),
  textStyle: MaterialStateProperty.all(
    VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
  ),
  padding: MaterialStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 16),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(VeriRentRadius.full),
      side: BorderSide(color: cs.outlineVariant),
    ),
  ),
);

TextTheme _buildTextTheme(ColorScheme cs) {
  final base = cs.onSurface;
  final muted = cs.onSurfaceVariant;
  return TextTheme(
    displayLarge: VeriRentText.displayLarge.copyWith(color: base),
    displayMedium: VeriRentText.displayMedium.copyWith(color: base),
    displaySmall: VeriRentText.displaySmall.copyWith(color: base),
    headlineLarge: VeriRentText.headlineLarge.copyWith(color: base),
    headlineMedium: VeriRentText.headlineMedium.copyWith(color: base),
    headlineSmall: VeriRentText.headlineSmall.copyWith(color: base),
    titleLarge: VeriRentText.titleLarge.copyWith(color: base),
    titleMedium: VeriRentText.titleMedium.copyWith(color: base),
    titleSmall: VeriRentText.titleSmall.copyWith(color: base),
    bodyLarge: VeriRentText.bodyLarge.copyWith(color: base),
    bodyMedium: VeriRentText.bodyMedium.copyWith(color: base),
    bodySmall: VeriRentText.bodySmall.copyWith(color: muted),
    labelLarge: VeriRentText.labelLarge.copyWith(color: base),
    labelMedium: VeriRentText.labelMedium.copyWith(color: muted),
    labelSmall: VeriRentText.labelSmall.copyWith(color: muted),
  );
}

// =============================================================================
//  SECTION 7 — THEME DATA ASSEMBLY
// =============================================================================

abstract final class AgentsTheme {
  // ── Light Theme ────────────────────────────────────────────────────────────
  static final ThemeData light = _build(_lightColorScheme);

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static final ThemeData dark = _build(_darkColorScheme);

  // ── Builder ────────────────────────────────────────────────────────────────
  static ThemeData _build(ColorScheme cs) => ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    brightness: cs.brightness,

    // Scaffold
    scaffoldBackgroundColor: cs.brightness == Brightness.light
        ? VeriRentColors.neutral50
        : VeriRentColors.neutral900,

    // Canvas / dialog background
    canvasColor: cs.surface,
    cardColor: cs.surface,
    dialogBackgroundColor: cs.surface,

    // Focus / highlight
    focusColor: cs.primary.withOpacity(0.12),
    highlightColor: cs.primary.withOpacity(0.08),
    splashColor: cs.primary.withOpacity(0.10),
    hoverColor: cs.primary.withOpacity(0.06),

    // Typography
    textTheme: _buildTextTheme(cs),
    primaryTextTheme: _buildTextTheme(cs),

    // Components
    appBarTheme: _appBarTheme(cs),
    cardTheme: _cardTheme(cs),
    filledButtonTheme: _filledButtonTheme(cs),
    outlinedButtonTheme: _outlinedButtonTheme(cs),
    textButtonTheme: _textButtonTheme(cs),
    elevatedButtonTheme: _elevatedButtonTheme(cs),
    inputDecorationTheme: _inputTheme(cs),
    chipTheme: _chipTheme(cs),
    bottomNavigationBarTheme: _bottomNavTheme(cs),
    navigationBarTheme: _navigationBarTheme(cs),
    tabBarTheme: _tabBarTheme(cs),
    dialogTheme: _dialogTheme(cs),
    snackBarTheme: _snackBarTheme(cs),
    listTileTheme: _listTileTheme(cs),
    dividerTheme: _dividerTheme(cs),
    floatingActionButtonTheme: _fabTheme(cs),
    switchTheme: _switchTheme(cs),
    checkboxTheme: _checkboxTheme(cs),
    radioTheme: _radioTheme(cs),
    progressIndicatorTheme: _progressTheme(cs),
    tooltipTheme: _tooltipTheme(cs),
    popupMenuTheme: _popupMenuTheme(cs),
    searchBarTheme: _searchBarTheme(cs),

    // Icon
    iconTheme: IconThemeData(color: cs.onSurfaceVariant, size: 24),
    primaryIconTheme: IconThemeData(color: cs.primary, size: 24),
  );
}

// =============================================================================
//  SECTION 8 — SEMANTIC EXTENSION
//  Extra colors that don't map to Material ColorScheme slots.
//  Access via: Theme.of(context).extension<VeriRentExtension>()
// =============================================================================

@immutable
class VeriRentExtension extends ThemeExtension<VeriRentExtension> {
  const VeriRentExtension({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.tierBasic,
    required this.tierVerified,
    required this.tierPro,
    required this.tierStarterAgency,
    required this.tierProfessional,
    required this.tierEnterprise,
    required this.cardSurface,
    required this.listingCardBorder,
    required this.divider,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;

  // Verification tier badge colors
  final Color tierBasic;
  final Color tierVerified;
  final Color tierPro;
  final Color tierStarterAgency;
  final Color tierProfessional;
  final Color tierEnterprise;

  // Listing card specifics
  final Color cardSurface;
  final Color listingCardBorder;
  final Color divider;

  @override
  VeriRentExtension copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? tierBasic,
    Color? tierVerified,
    Color? tierPro,
    Color? tierStarterAgency,
    Color? tierProfessional,
    Color? tierEnterprise,
    Color? cardSurface,
    Color? listingCardBorder,
    Color? divider,
  }) => VeriRentExtension(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    successContainer: successContainer ?? this.successContainer,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    warningContainer: warningContainer ?? this.warningContainer,
    info: info ?? this.info,
    onInfo: onInfo ?? this.onInfo,
    infoContainer: infoContainer ?? this.infoContainer,
    tierBasic: tierBasic ?? this.tierBasic,
    tierVerified: tierVerified ?? this.tierVerified,
    tierPro: tierPro ?? this.tierPro,
    tierStarterAgency: tierStarterAgency ?? this.tierStarterAgency,
    tierProfessional: tierProfessional ?? this.tierProfessional,
    tierEnterprise: tierEnterprise ?? this.tierEnterprise,
    cardSurface: cardSurface ?? this.cardSurface,
    listingCardBorder: listingCardBorder ?? this.listingCardBorder,
    divider: divider ?? this.divider,
  );

  @override
  VeriRentExtension lerp(VeriRentExtension? other, double t) {
    if (other is! VeriRentExtension) return this;
    return VeriRentExtension(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      tierBasic: Color.lerp(tierBasic, other.tierBasic, t)!,
      tierVerified: Color.lerp(tierVerified, other.tierVerified, t)!,
      tierPro: Color.lerp(tierPro, other.tierPro, t)!,
      tierStarterAgency: Color.lerp(
        tierStarterAgency,
        other.tierStarterAgency,
        t,
      )!,
      tierProfessional: Color.lerp(
        tierProfessional,
        other.tierProfessional,
        t,
      )!,
      tierEnterprise: Color.lerp(tierEnterprise, other.tierEnterprise, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      listingCardBorder: Color.lerp(
        listingCardBorder,
        other.listingCardBorder,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }

  // ── Presets ───────────────────────────────────────────────────────────────

  static const VeriRentExtension light = VeriRentExtension(
    success: VeriRentColors.success500,
    onSuccess: VeriRentColors.white,
    successContainer: VeriRentColors.success50,
    warning: VeriRentColors.warning500,
    onWarning: VeriRentColors.white,
    warningContainer: VeriRentColors.warning50,
    info: VeriRentColors.info500,
    onInfo: VeriRentColors.white,
    infoContainer: VeriRentColors.info50,
    tierBasic: VeriRentColors.tierBasic,
    tierVerified: VeriRentColors.tierVerified,
    tierPro: VeriRentColors.tierPro,
    tierStarterAgency: VeriRentColors.tierStarterAgency,
    tierProfessional: VeriRentColors.tierProfessional,
    tierEnterprise: VeriRentColors.tierEnterprise,
    cardSurface: VeriRentColors.white,
    listingCardBorder: VeriRentColors.neutral200,
    divider: VeriRentColors.neutral200,
  );

  static const VeriRentExtension dark = VeriRentExtension(
    success: VeriRentColors.success200,
    onSuccess: VeriRentColors.success700,
    successContainer: VeriRentColors.success700,
    warning: VeriRentColors.warning200,
    onWarning: VeriRentColors.warning700,
    warningContainer: VeriRentColors.warning700,
    info: VeriRentColors.info200,
    onInfo: VeriRentColors.info700,
    infoContainer: VeriRentColors.info700,
    tierBasic: Color(0xFFB0BEC5),
    tierVerified: VeriRentColors.primary300,
    tierPro: VeriRentColors.secondary300,
    tierStarterAgency: VeriRentColors.success200,
    tierProfessional: VeriRentColors.info200,
    tierEnterprise: Color(0xFFCE93D8),
    cardSurface: VeriRentColors.neutral800,
    listingCardBorder: VeriRentColors.neutral700,
    divider: VeriRentColors.neutral700,
  );
}

// =============================================================================
//  SECTION 9 — MATERIAL APP WIRING (complete drop-in example)
// =============================================================================
//
//  class MyApp extends StatelessWidget {
//    const MyApp({super.key});
//
//    @override
//    Widget build(BuildContext context) {
//      return MaterialApp(
//        title: 'VeriRent NG',
//        debugShowCheckedModeBanner: false,
//        theme: VeriRentTheme.light.copyWith(
//          extensions: [VeriRentExtension.light],
//        ),
//        darkTheme: VeriRentTheme.dark.copyWith(
//          extensions: [VeriRentExtension.dark],
//        ),
//        themeMode: ThemeMode.system,   // or .light / .dark
//        home: const HomeScreen(),
//      );
//    }
//  }
//
// =============================================================================
//  SECTION 10 — USAGE PATTERNS
// =============================================================================
//
//  // --- Reading theme colors ---
//  final cs   = Theme.of(context).colorScheme;
//  final ext  = Theme.of(context).extension<VeriRentExtension>()!;
//  final text = Theme.of(context).textTheme;
//
//  // --- Primary action button ---
//  FilledButton(onPressed: () {}, child: Text('Verify Agency'))
//
//  // --- Gold CTA button (upgrade / premium) ---
//  ElevatedButton(onPressed: () {}, child: Text('Upgrade to Pro'))
//
//  // --- Outlined secondary action ---
//  OutlinedButton(onPressed: () {}, child: Text('View Profile'))
//
//  // --- Trust tier badge ---
//  Container(
//    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//    decoration: BoxDecoration(
//      color: ext.tierProfessional.withOpacity(0.12),
//      border: Border.all(color: ext.tierProfessional),
//      borderRadius: BorderRadius.circular(VeriRentRadius.full),
//    ),
//    child: Text('Professional Agency',
//      style: VeriRentText.labelSmall.copyWith(color: ext.tierProfessional),
//    ),
//  )
//
//  // --- Success/warning/error banners ---
//  Container(
//    color: ext.successContainer,
//    child: Text('KYC Verified', style: TextStyle(color: ext.success)),
//  )
//
//  // --- Verified listing card border ---
//  Card(
//    shape: RoundedRectangleBorder(
//      borderRadius: BorderRadius.circular(VeriRentRadius.lg),
//      side: BorderSide(color: cs.primary, width: 2),   // verified listings get primary border
//    ),
//  )
//
// =============================================================================
