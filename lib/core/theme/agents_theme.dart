// =============================================================================
//  VeriRent NG — Design System v2.0  "Slate Ink"
//  Nixel Technology Global  |  June 2026
//
//  Aesthetic: Premium PropTech — estate-agency authority meets fintech clarity.
//  Primary: Deep Slate (#1A2332) — conviction, trust, formality.
//  Accent:  Warm Amber (#E8A020) — energy, premium signal, call-to-action only.
//  Surface: Warm Fog (#F7F6F3 light / #131B27 dark) — not cold white/black.
//
//  Usage:
//    MaterialApp(
//      theme:     VeriRentTheme.light,
//      darkTheme: VeriRentTheme.dark,
//      themeMode: ThemeMode.system,
//    )
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =============================================================================
//  SECTION 1 — BRAND PALETTE
// =============================================================================

abstract final class VeriRentColors {
  // ── Primary — Deep Slate ─────────────────────────────────────────────────
  // Conveys legal authority, estate surveying gravitas, institutional trust.
  static const Color primary50 = Color(0xFFECEFF4);
  static const Color primary100 = Color(0xFFCDD3DF);
  static const Color primary200 = Color(0xFFABB5C8);
  static const Color primary300 = Color(0xFF7E91AD);
  static const Color primary400 = Color(0xFF526F90);
  static const Color primary500 = Color(0xFF1A2332); // ← brand primary
  static const Color primary600 = Color(0xFF16202E);
  static const Color primary700 = Color(0xFF111B27);
  static const Color primary800 = Color(0xFF0C141E);
  static const Color primary900 = Color(0xFF060C14);

  // ── Accent — Warm Amber ──────────────────────────────────────────────────
  // Used exclusively for: CTAs, tier badges, active states, price highlights.
  // Amber reads as premium in Nigerian PropTech context without the Jiji teal.
  static const Color accent50 = Color(0xFFFDF4E3);
  static const Color accent100 = Color(0xFFFAE0AA);
  static const Color accent200 = Color(0xFFF5C970);
  static const Color accent300 = Color(0xFFEFAF38);
  static const Color accent400 = Color(0xFFE8A020); // ← brand accent
  static const Color accent500 = Color(0xFFCC8C18);
  static const Color accent600 = Color(0xFFAD7512);
  static const Color accent700 = Color(0xFF8C5E0C);
  static const Color accent800 = Color(0xFF6A4608);
  static const Color accent900 = Color(0xFF482F04);

  // ── Neutral — Warm Fog ───────────────────────────────────────────────────
  // Slightly warm to avoid the clinical coldness of pure gray.
  static const Color neutral50 = Color(0xFFF7F6F3); // warm page bg
  static const Color neutral100 = Color(0xFFEEEDE9);
  static const Color neutral200 = Color(0xFFDDDBD5);
  static const Color neutral300 = Color(0xFFC4C1B8);
  static const Color neutral400 = Color(0xFFA09D94);
  static const Color neutral500 = Color(0xFF7C796F);
  static const Color neutral600 = Color(0xFF5A5750);
  static const Color neutral700 = Color(0xFF3E3C37);
  static const Color neutral800 = Color(0xFF252320);
  static const Color neutral900 = Color(0xFF131B27); // dark page bg

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success50 = Color(0xFFEBF7ED);
  static const Color success200 = Color(0xFFA8DCAF);
  static const Color success500 = Color(0xFF2D7A35);
  static const Color success700 = Color(0xFF1B4E21);

  static const Color warning50 = Color(0xFFFFF8E6);
  static const Color warning200 = Color(0xFFFFDE85);
  static const Color warning500 = Color(0xFFF59D0E);
  static const Color warning700 = Color(0xFFD17D00);

  static const Color error50 = Color(0xFFFEEBEB);
  static const Color error200 = Color(0xFFF0A0A0);
  static const Color error500 = Color(0xFFBF2626);
  static const Color error700 = Color(0xFF8C1B1B);

  static const Color info50 = Color(0xFFE5EEF8);
  static const Color info200 = Color(0xFF91B8E8);
  static const Color info500 = Color(0xFF1B5BAD);
  static const Color info700 = Color(0xFF0E3D78);

  // ── Tier Badge Colors ────────────────────────────────────────────────────
  static const Color tierBasic = Color(0xFF9AA4B2); // Cool slate
  static const Color tierVerified = Color(0xFF3B82F6); // Vivid blue
  static const Color tierPro = Color(0xFFE8A020); // Brand amber
  static const Color tierStarterAgency = Color(0xFF22C55E); // Emerald
  static const Color tierProfessional = Color(0xFF6366F1); // Indigo
  static const Color tierEnterprise = Color(0xFFEC4899); // Rose

  // ── Utility ──────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ── Legacy aliases (kept for widget compatibility) ───────────────────────
  // secondary* → accent* so existing widgets need zero changes.
  static const Color secondary50 = accent50;
  static const Color secondary100 = accent100;
  static const Color secondary200 = accent200;
  static const Color secondary300 = accent300;
  static const Color secondary400 = accent400;
  static const Color secondary500 =
      accent400; // was brand gold; amber is the closest equivalent
  static const Color secondary600 = accent500;
  static const Color secondary700 = accent600;
  static const Color secondary800 = accent700;
  static const Color secondary900 = accent900;

  static const Color primary = primary500;
  static const Color gold = accent400;
  static const Color goldDim = Color(0x1FE8A020);
  static const Color red = error500;
  static const Color green = success500;
  static const Color text = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF7C796F);
  static const Color textDim = Color(0xFFC4C1B8);
  static const Color bg = neutral900;
  static const Color surface = neutral800;
  static const Color surface2 = Color(0xFF1E2A3B);
  static const Color surface3 = Color(0xFF2A3A50);
  static const Color border = Color(0x14000000);
  static const Color primaryDim = Color(0x1F1A2332);
  static const Color primaryGlow = Color(0x591A2332);
}

// =============================================================================
//  SECTION 2 — TYPOGRAPHY SCALE  (compact — everything ~1pt tighter)
// =============================================================================

abstract final class VeriRentText {
  // Display
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.15,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.25,
    overflow: TextOverflow.ellipsis,
  );

  // Headline
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.3,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );

  // Title
  static const TextStyle titleLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    overflow: TextOverflow.ellipsis,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.6,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.55,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    overflow: TextOverflow.ellipsis,
  );

  // Label
  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.3,
    overflow: TextOverflow.ellipsis,
  );
}

// =============================================================================
//  SECTION 3 — SPACING, RADIUS & ELEVATION (tighter)
// =============================================================================

abstract final class VeriRentSpacing {
  static const double xs = 3.0;
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double base = 14.0;
  static const double lg = 20.0;
  static const double xl = 28.0;
  static const double xxl = 40.0;
  static const double xxxl = 56.0;
}

abstract final class VeriRentRadius {
  static const double xs = 3.0;
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 14.0;
  static const double xl = 20.0;
  static const double full = 100.0;
}

abstract final class VeriRentElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 6;
  static const double modal = 12;
}

// =============================================================================
//  SECTION 4 — LIGHT COLOR SCHEME
// =============================================================================

const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: VeriRentColors.primary500,
  onPrimary: VeriRentColors.white,
  primaryContainer: VeriRentColors.primary100,
  onPrimaryContainer: VeriRentColors.primary800,
  secondary: VeriRentColors.accent400,
  onSecondary: VeriRentColors.white,
  secondaryContainer: VeriRentColors.accent100,
  onSecondaryContainer: VeriRentColors.accent800,
  tertiary: VeriRentColors.success500,
  onTertiary: VeriRentColors.white,
  tertiaryContainer: VeriRentColors.success50,
  onTertiaryContainer: VeriRentColors.success700,
  error: VeriRentColors.error500,
  onError: VeriRentColors.white,
  errorContainer: VeriRentColors.error50,
  onErrorContainer: VeriRentColors.error700,
  surface: VeriRentColors.white,
  onSurface: VeriRentColors.neutral800,
  surfaceVariant: VeriRentColors.neutral50,
  onSurfaceVariant: VeriRentColors.neutral500,
  outline: VeriRentColors.neutral300,
  outlineVariant: VeriRentColors.neutral200,
  shadow: VeriRentColors.neutral900,
  scrim: Color(0x99131B27),
  inverseSurface: VeriRentColors.neutral800,
  onInverseSurface: VeriRentColors.neutral50,
  inversePrimary: VeriRentColors.primary200,
  surfaceTint: VeriRentColors.primary500,
);

// =============================================================================
//  SECTION 5 — DARK COLOR SCHEME
// =============================================================================

const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: VeriRentColors.primary300,
  onPrimary: VeriRentColors.primary900,
  primaryContainer: VeriRentColors.primary700,
  onPrimaryContainer: VeriRentColors.primary100,
  secondary: VeriRentColors.accent300,
  onSecondary: VeriRentColors.accent900,
  secondaryContainer: VeriRentColors.accent700,
  onSecondaryContainer: VeriRentColors.accent100,
  tertiary: VeriRentColors.success200,
  onTertiary: VeriRentColors.success700,
  tertiaryContainer: VeriRentColors.success700,
  onTertiaryContainer: VeriRentColors.success50,
  error: VeriRentColors.error200,
  onError: VeriRentColors.error700,
  errorContainer: VeriRentColors.error700,
  onErrorContainer: VeriRentColors.error50,
  surface: VeriRentColors.neutral800,
  onSurface: VeriRentColors.neutral100,
  surfaceVariant: VeriRentColors.neutral900,
  onSurfaceVariant: VeriRentColors.neutral300,
  outline: VeriRentColors.neutral600,
  outlineVariant: VeriRentColors.neutral700,
  shadow: VeriRentColors.black,
  scrim: Color(0xCC000000),
  inverseSurface: VeriRentColors.neutral100,
  onInverseSurface: VeriRentColors.neutral800,
  inversePrimary: VeriRentColors.primary500,
  surfaceTint: VeriRentColors.primary300,
);

// =============================================================================
//  SECTION 6 — COMPONENT THEMES
// =============================================================================

AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
  backgroundColor: cs.surface,
  foregroundColor: cs.onSurface,
  elevation: 0,
  scrolledUnderElevation: 0.5,
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
  shadowColor: cs.shadow.withOpacity(0.06),
  elevation: VeriRentElevation.low,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.lg),
    side: BorderSide(color: cs.outlineVariant, width: 0.75),
  ),
);

FilledButtonThemeData _filledButtonTheme(ColorScheme cs) =>
    FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        minimumSize: const Size(56, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        minimumSize: const Size(56, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: VeriRentText.labelLarge,
        side: BorderSide(color: cs.primary, width: 1.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
        ),
      ),
    );

TextButtonThemeData _textButtonTheme(ColorScheme cs) => TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: cs.primary,
    minimumSize: const Size(40, 36),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    textStyle: VeriRentText.labelLarge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
    ),
  ),
);

// Gold CTA (premium / upgrade actions)
ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: VeriRentColors.accent400,
        foregroundColor: VeriRentColors.white,
        minimumSize: const Size(56, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: VeriRentText.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
        ),
        elevation: 1,
        shadowColor: VeriRentColors.accent400.withOpacity(0.25),
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
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.outline, width: 0.75),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.outline, width: 0.75),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.primary, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.error, width: 1),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
    borderSide: BorderSide(color: cs.error, width: 1.5),
  ),
  errorStyle: VeriRentText.bodySmall.copyWith(color: cs.error),
);

ChipThemeData _chipTheme(ColorScheme cs) => ChipThemeData(
  backgroundColor: cs.surfaceVariant,
  selectedColor: cs.primaryContainer,
  labelStyle: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
  secondaryLabelStyle: VeriRentText.labelMedium.copyWith(
    color: cs.onPrimaryContainer,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.full),
    side: BorderSide(color: cs.outlineVariant),
  ),
  elevation: 0,
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
      elevation: 6,
    );

NavigationBarThemeData _navigationBarTheme(ColorScheme cs) =>
    NavigationBarThemeData(
      backgroundColor: cs.surface,
      indicatorColor: cs.primaryContainer,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(color: cs.onPrimaryContainer, size: 22);
        }
        return IconThemeData(color: cs.onSurfaceVariant, size: 22);
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
      height: 66,
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
    borderSide: BorderSide(color: cs.primary, width: 2.5),
    borderRadius: const BorderRadius.vertical(top: Radius.circular(2.5)),
  ),
  indicatorSize: TabBarIndicatorSize.label,
  dividerColor: cs.outlineVariant,
);

DialogThemeData _dialogTheme(ColorScheme cs) => DialogThemeData(
  backgroundColor: cs.surface,
  elevation: VeriRentElevation.modal,
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
  actionTextColor: cs.secondary,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
  ),
  elevation: VeriRentElevation.high,
);

ListTileThemeData _listTileTheme(ColorScheme cs) => ListTileThemeData(
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
  titleTextStyle: VeriRentText.bodyLarge.copyWith(color: cs.onSurface),
  subtitleTextStyle: VeriRentText.bodySmall.copyWith(
    color: cs.onSurfaceVariant,
  ),
  iconColor: cs.onSurfaceVariant,
  selectedColor: cs.primary,
  selectedTileColor: cs.primaryContainer.withOpacity(0.4),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VeriRentRadius.md),
  ),
  minVerticalPadding: 8,
);

DividerThemeData _dividerTheme(ColorScheme cs) =>
    DividerThemeData(color: cs.outlineVariant, thickness: 0.75, space: 0.75);

FloatingActionButtonThemeData _fabTheme(ColorScheme cs) =>
    FloatingActionButtonThemeData(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      extendedTextStyle: VeriRentText.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
      ),
      elevation: VeriRentElevation.medium,
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
  side: BorderSide(color: cs.outline, width: 1.5),
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
      linearMinHeight: 3,
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
    const EdgeInsets.symmetric(horizontal: 14),
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
//  SECTION 7 — THEME ASSEMBLY
// =============================================================================

abstract final class AgentsTheme {
  static final ThemeData light = _build(_lightColorScheme);
  static final ThemeData dark = _build(_darkColorScheme);

  static ThemeData _build(ColorScheme cs) => ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    brightness: cs.brightness,
    scaffoldBackgroundColor: cs.brightness == Brightness.light
        ? VeriRentColors.neutral50
        : VeriRentColors.neutral900,
    canvasColor: cs.surface,
    cardColor: cs.surface,
    dialogBackgroundColor: cs.surface,
    focusColor: cs.primary.withOpacity(0.10),
    highlightColor: cs.primary.withOpacity(0.06),
    splashColor: cs.primary.withOpacity(0.08),
    hoverColor: cs.primary.withOpacity(0.04),
    textTheme: _buildTextTheme(cs),
    primaryTextTheme: _buildTextTheme(cs),
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
    searchBarTheme: _searchBarTheme(cs),
    iconTheme: IconThemeData(color: cs.onSurfaceVariant, size: 22),
    primaryIconTheme: IconThemeData(color: cs.primary, size: 22),
  );
}

// =============================================================================
//  SECTION 8 — SEMANTIC EXTENSION
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

  final Color success, onSuccess, successContainer;
  final Color warning, onWarning, warningContainer;
  final Color info, onInfo, infoContainer;
  final Color tierBasic, tierVerified, tierPro;
  final Color tierStarterAgency, tierProfessional, tierEnterprise;
  final Color cardSurface, listingCardBorder, divider;

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
    tierBasic: Color(0xFF9AA4B2),
    tierVerified: VeriRentColors.primary200,
    tierPro: VeriRentColors.accent300,
    tierStarterAgency: VeriRentColors.success200,
    tierProfessional: VeriRentColors.info200,
    tierEnterprise: Color(0xFFF0ABCB),
    cardSurface: VeriRentColors.neutral800,
    listingCardBorder: VeriRentColors.neutral700,
    divider: VeriRentColors.neutral700,
  );
}
