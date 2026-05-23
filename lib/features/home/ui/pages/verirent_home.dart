// =============================================================================
//  VeriRent NG — Home App  (matches verirent.html exactly)
//  Single-file Flutter app with 4 screens, full dark theme applied.
//
//  HOW TO USE:
//  1. Copy this file + verirent_theme.dart into your lib/ folder
//  2. In main.dart:
//       void main() => runApp(const VeriRentApp());
//  3. Run: flutter run
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verirent/core/theme/agents_theme.dart';

// ─── If you have verirent_theme.dart, replace these constants with imports ───
// import 'verirent_theme.dart';
// For now, all colors are inlined so this file is self-contained.

// ─────────────────────────────────────────────────────────────────────────────
//  COLORS  (matches the HTML :root variables)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class C {
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
}

// ─────────────────────────────────────────────────────────────────────────────
//  TEXT STYLES  (Sora = headings, DM Sans = body — using system fallbacks)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class VT {
  static const head = TextStyle(fontWeight: FontWeight.w800, color: C.text);
  static TextStyle h1({double size = 30, Color color = C.text}) => TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w800,
    color: color,
    letterSpacing: -0.5,
    height: 1.15,
  );
  static TextStyle h2({double size = 16, Color color = C.text}) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: color);
  static TextStyle body({double size = 13, Color color = C.textMuted}) =>
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );
  static TextStyle label({double size = 11, Color color = C.textMuted}) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.w600, color: color);
  static TextStyle bold({double size = 14, Color color = C.text}) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: color);
}

// ─────────────────────────────────────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────
class Prop {
  final String title, location, price, agency, esvNum, imgUrl;
  final int beds, baths;
  final String thirdMeta;
  final IconData thirdIcon;
  final double accuracy;
  const Prop({
    required this.title,
    required this.location,
    required this.price,
    required this.agency,
    required this.esvNum,
    required this.imgUrl,
    required this.beds,
    required this.baths,
    required this.thirdMeta,
    required this.thirdIcon,
    required this.accuracy,
  });
}

class Deal {
  final String title, location, status, price, imgUrl;
  const Deal({
    required this.title,
    required this.location,
    required this.status,
    required this.price,
    required this.imgUrl,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────
final kProps = [
  const Prop(
    title: '4-Bedroom Duplex',
    location: 'GRA Phase 2, Port Harcourt',
    price: '₦2.8M/yr',
    agency: 'Prime Estates',
    esvNum: 'ESVARBON #08742',
    imgUrl: 'https://picsum.photos/id/1016/600/400',
    beds: 4,
    baths: 5,
    thirdMeta: '2 Car',
    thirdIcon: Icons.directions_car_rounded,
    accuracy: 99,
  ),
  const Prop(
    title: '3-Bedroom Apartment',
    location: 'Rumuola, Port Harcourt',
    price: '₦1.9M/yr',
    agency: 'Delta Realty',
    esvNum: 'ESVARBON #06211',
    imgUrl: 'https://picsum.photos/id/1060/600/400',
    beds: 3,
    baths: 3,
    thirdMeta: 'WiFi',
    thirdIcon: Icons.wifi_rounded,
    accuracy: 97,
  ),
  const Prop(
    title: '5-Bed Executive Villa',
    location: 'Trans-Amadi, Port Harcourt',
    price: '₦4.5M/yr',
    agency: 'Rivers PropCo',
    esvNum: 'ESVARBON #11034',
    imgUrl: 'https://picsum.photos/id/164/600/400',
    beds: 5,
    baths: 6,
    thirdMeta: 'Power',
    thirdIcon: Icons.bolt_rounded,
    accuracy: 100,
  ),
];

final kDeals = [
  const Deal(
    title: '3-Bed Apartment, Rumuola',
    location: 'Rumuola · Ref #VR-2291',
    status: 'active',
    price: '₦1.9M/yr',
    imgUrl: 'https://picsum.photos/id/1060/300/300',
  ),
  const Deal(
    title: '2-Bed Flat, Old GRA',
    location: 'Old GRA · Ref #VR-1883',
    status: 'pending',
    price: '₦1.1M/yr',
    imgUrl: 'https://picsum.photos/id/1029/300/300',
  ),
  const Deal(
    title: 'Office Space, D-Line',
    location: 'D-Line · Ref #VR-3041',
    status: 'review',
    price: '₦2.4M/yr',
    imgUrl: 'https://picsum.photos/id/1041/300/300',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────
class VeriRentApp extends StatelessWidget {
  const VeriRentApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: 'VeriRent NG',
      debugShowCheckedModeBanner: false,
      // ── Wire in the VeriRent dark theme ──────────────────────────────────
      // If you have verirent_theme.dart in the same folder, use:
      //   theme: VeriRentTheme.dark,
      // For this self-contained file, we define a minimal theme inline:
      theme: AgentsTheme.light,
      home: const _Shell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHELL — Bottom Nav + Screen switcher
// ─────────────────────────────────────────────────────────────────────────────
class _Shell extends StatefulWidget {
  const _Shell();
  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const _HomeScreen(),
      const _ExploreScreen(),
      const _DealsScreen(),
      const _AccountScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _idx, children: screens),
      bottomNavigationBar: _BottomNav(
        current: _idx,
        onTap: (i) => setState(() => _idx = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BOTTOM NAVIGATION
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext ctx) => Container(
    decoration: BoxDecoration(
      color: C.surface.withOpacity(0.95),
      border: const Border(top: BorderSide(color: C.border)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 66,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBtn(
              icon: Icons.home_rounded,
              label: 'Home',
              active: current == 0,
              onTap: () => onTap(0),
            ),
            _NavBtn(
              icon: Icons.explore_rounded,
              label: 'Explore',
              active: current == 1,
              onTap: () => onTap(1),
            ),
            // Center "Post" floating button
            GestureDetector(
              onTap: () {},
              child: Transform.translate(
                offset: const Offset(0, -10),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [C.primary, Color(0xFF00A68A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: C.primaryGlow,
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
            _NavBtn(
              icon: Icons.handshake_rounded,
              label: 'My Deals',
              active: current == 2,
              onTap: () => onTap(2),
            ),
            _NavBtn(
              icon: Icons.person_rounded,
              label: 'Account',
              active: current == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? C.primary : C.textDim, size: 22),
        const SizedBox(height: 3),
        Text(
          label,
          style: VT.label(size: 10, color: active ? C.primary : C.textDim),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN 0 — HOME
// ─────────────────────────────────────────────────────────────────────────────
class _HomeScreen extends StatefulWidget {
  const _HomeScreen();
  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int _activeFilter = 0;
  int _activeTab = 0; // Browse / List
  final _filters = ['All', 'Apartment', 'Duplex', 'Furnished', 'Corporate'];
  final _filterIcons = [
    Icons.star_rounded,
    Icons.house_rounded,
    Icons.apartment_rounded,
    Icons.chair_rounded,
    Icons.business_center_rounded,
  ];

  @override
  Widget build(BuildContext ctx) => CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(child: _StatusBar()),
      SliverToBoxAdapter(child: _buildHero()),
      SliverToBoxAdapter(child: _buildSearch()),
      SliverToBoxAdapter(child: _buildFilters()),
      SliverToBoxAdapter(
        child: _buildSectionHead('Platform Stats', 'Live Data'),
      ),
      SliverToBoxAdapter(child: _buildStats()),
      SliverToBoxAdapter(
        child: _buildSectionHead('Featured Properties', 'See all →'),
      ),
      SliverToBoxAdapter(child: _buildCards()),
      SliverToBoxAdapter(child: _buildAgencyBanner()),
      SliverToBoxAdapter(
        child: _buildSectionHead('Recently Audited', 'View all'),
      ),
      SliverToBoxAdapter(child: _buildRecentlyAudited()),
      const SliverToBoxAdapter(child: SizedBox(height: 40)),
    ],
  );

  // ── Hero ─────────────────────────────────────────────────────────────────
  Widget _buildHero() => Container(
    color: C.bg,
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Stack(
      children: [
        // Glow decorations
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x2E00C9A7), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          top: -20,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x1AF0C060), Colors.transparent],
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar: logo + actions
            Row(
              children: [
                // Logo icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [C.primary, Color(0xFF00A68A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: C.primaryGlow, blurRadius: 16),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'V',
                      style: VT.h2(size: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'VeriRent',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: C.text,
                        ),
                        children: [
                          TextSpan(
                            text: 'NG',
                            style: TextStyle(color: C.primary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Certified Marketplace',
                      style: VT.label(size: 10, color: C.primary),
                    ),
                  ],
                ),
                const Spacer(),
                // Notification button
                Stack(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: C.surface2,
                        border: Border.all(color: C.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: C.textMuted,
                        size: 18,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: C.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: C.surface, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                // Avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: C.primary, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/id/64/200/200',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Greeting
            RichText(
              text: const TextSpan(
                text: 'Good morning, ',
                style: TextStyle(fontSize: 13, color: C.textMuted),
                children: [
                  TextSpan(
                    text: 'Chukwuemeka 👋',
                    style: TextStyle(
                      color: C.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Headline
            RichText(
              text: TextSpan(
                text: 'Rent with\n',
                style: VT.h1(size: 30),
                children: [
                  TextSpan(
                    text: 'Certainty.',
                    style: VT.h1(size: 30, color: C.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Every listing is professionally verified by an ESVARBON-certified agency.',
              style: VT.body(size: 13),
            ),
            const SizedBox(height: 20),

            // Trust pills scroll
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _TrustPill(
                    icon: Icons.shield_rounded,
                    label: 'ESVARBON Verified',
                  ),
                  const SizedBox(width: 8),
                  _TrustPill(
                    icon: Icons.article_rounded,
                    label: 'Title Checked',
                  ),
                  const SizedBox(width: 8),
                  _TrustPill(
                    icon: Icons.manage_search_rounded,
                    label: 'Audited Listings',
                  ),
                  const SizedBox(width: 8),
                  _TrustPill(
                    icon: Icons.handshake_rounded,
                    label: 'No Hidden Fees',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Browse / List toggle
            Row(
              children: [
                Expanded(
                  child: _TabToggle(
                    label: 'Browse Homes',
                    active: _activeTab == 0,
                    onTap: () => setState(() => _activeTab = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabToggle(
                    label: 'List Property',
                    active: _activeTab == 1,
                    onTap: () => setState(() => _activeTab = 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    ),
  );

  // ── Search ────────────────────────────────────────────────────────────────
  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
    child: Container(
      decoration: BoxDecoration(
        color: C.surface2,
        border: Border.all(color: C.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: C.textDim, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: VT.body(size: 14, color: C.text),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'GRA, Rumuola, Trans-Amadi…',
                hintStyle: VT.body(size: 14, color: C.textDim),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: C.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    ),
  );

  // ── Filters ───────────────────────────────────────────────────────────────
  Widget _buildFilters() => SizedBox(
    height: 46,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      itemCount: _filters.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (ctx, i) {
        final active = i == _activeFilter;
        return GestureDetector(
          onTap: () => setState(() => _activeFilter = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? C.primaryDim : C.surface2,
              border: Border.all(color: active ? C.primary : C.border),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _filterIcons[i],
                  size: 11,
                  color: active ? C.primary : C.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  _filters[i],
                  style: VT.label(
                    size: 12,
                    color: active ? C.primary : C.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  // ── Stats ─────────────────────────────────────────────────────────────────
  Widget _buildStats() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Row(
      children: [
        Expanded(
          child: _StatCard(value: '300+', label: 'Verified\nListings'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '15', label: 'Certified\nAgencies'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '98%', label: 'Audit\nAccuracy'),
        ),
      ],
    ),
  );

  // ── Section Head ──────────────────────────────────────────────────────────
  Widget _buildSectionHead(String title, String action) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: VT.h2(size: 16)),
        Text(action, style: VT.label(size: 12, color: C.primary)),
      ],
    ),
  );

  // ── Property Cards ────────────────────────────────────────────────────────
  Widget _buildCards() => SizedBox(
    height: 320,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      itemCount: kProps.length,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (ctx, i) => _PropCard(prop: kProps[i]),
    ),
  );

  // ── Agency Banner ─────────────────────────────────────────────────────────
  Widget _buildAgencyBanner() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.surface2,
        border: Border.all(color: C.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: C.goldDim,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.verified_rounded, color: C.gold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you an agency?', style: VT.bold(size: 13)),
                Text(
                  'Get ESVARBON-certified & join the platform',
                  style: VT.label(size: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: C.gold,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Apply',
                style: VT.label(size: 11, color: const Color(0xFF07090F)),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // ── Recently Audited ──────────────────────────────────────────────────────
  Widget _buildRecentlyAudited() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: kProps.reversed
          .take(2)
          .map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AuditRow(prop: p),
            ),
          )
          .toList(),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN 1 — EXPLORE
// ─────────────────────────────────────────────────────────────────────────────
class _ExploreScreen extends StatefulWidget {
  const _ExploreScreen();
  @override
  State<_ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<_ExploreScreen> {
  int _typeIdx = 0;
  final _types = ['Apartment', 'Duplex', 'Office', 'Land', 'Shortlet'];
  final _typeIcons = [
    Icons.apartment_rounded,
    Icons.home_rounded,
    Icons.business_rounded,
    Icons.landscape_rounded,
    Icons.king_bed_rounded,
  ];

  @override
  Widget build(BuildContext ctx) => SafeArea(
    child: Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            children: [
              const _BackBtn(),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore Listings', style: VT.h2(size: 18)),
                  Text(
                    'Port Harcourt, Rivers State',
                    style: VT.label(size: 12, color: C.primary),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: C.surface2,
                  border: Border.all(color: C.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: C.textMuted,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Type pills
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _types.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (ctx, i) {
              final active = i == _typeIdx;
              return GestureDetector(
                onTap: () => setState(() => _typeIdx = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: active ? C.primaryDim : C.surface2,
                    border: Border.all(color: active ? C.primary : C.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _typeIcons[i],
                        size: 22,
                        color: active ? C.primary : C.textMuted,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _types[i],
                        style: VT.label(
                          size: 11,
                          color: active ? C.primary : C.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Listing rows
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: kProps.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => _ExploreRow(prop: kProps[i]),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN 2 — MY DEALS
// ─────────────────────────────────────────────────────────────────────────────
class _DealsScreen extends StatelessWidget {
  const _DealsScreen();

  @override
  Widget build(BuildContext ctx) => SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Row(
            children: [
              Text('My Deals', style: VT.h2(size: 20)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: C.primary),
                  color: C.primaryDim,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '3 Active',
                  style: VT.label(size: 11, color: C.primary),
                ),
              ),
            ],
          ),
        ),
        // Progress bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tenancy Process',
                    style: VT.label(size: 12, color: C.textMuted),
                  ),
                  Text('65%', style: VT.label(size: 12, color: C.primary)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 6,
                  backgroundColor: C.surface3,
                  valueColor: const AlwaysStoppedAnimation(C.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: kDeals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => _DealCard(deal: kDeals[i]),
          ),
        ),
        // Timeline
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: _Timeline(),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN 3 — ACCOUNT
// ─────────────────────────────────────────────────────────────────────────────
class _AccountScreen extends StatelessWidget {
  const _AccountScreen();

  @override
  Widget build(BuildContext ctx) => SingleChildScrollView(
    child: Column(
      children: [
        // Profile hero
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [C.surface2, C.surface.withOpacity(1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: const Border(bottom: BorderSide(color: C.border)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: C.primary, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: C.primaryDim,
                      blurRadius: 16,
                      spreadRadius: 6,
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/id/64/200/200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Chukwuemeka Obi', style: VT.h1(size: 20)),
              const SizedBox(height: 4),
              Text(
                'ESVARBON Licensed Agent · Port Harcourt',
                style: VT.body(size: 13, color: C.textMuted),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Pill(label: 'Pro Agency', color: C.primary),
                  const SizedBox(width: 8),
                  _Pill(label: 'ESVARBON #08742', color: C.gold),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Menu groups
        _MenuGroup(
          label: 'Account',
          items: [
            _MenuItem(
              icon: Icons.person_rounded,
              iconBg: C.primaryDim,
              iconColor: C.primary,
              title: 'Edit Profile',
              sub: 'Name, phone, email, photo',
            ),
            _MenuItem(
              icon: Icons.shield_rounded,
              iconBg: C.primaryDim,
              iconColor: C.primary,
              title: 'KYC & Verification',
              sub: 'NIN · BVN · ESVARBON',
            ),
            _MenuItem(
              icon: Icons.description_rounded,
              iconBg: C.primaryDim,
              iconColor: C.primary,
              title: 'My Documents',
              sub: 'Tenancy agreements, notices',
            ),
          ],
        ),
        _MenuGroup(
          label: 'Subscription',
          items: [
            _MenuItem(
              icon: Icons.workspace_premium_rounded,
              iconBg: C.goldDim,
              iconColor: C.gold,
              title: 'Pro Agency Plan',
              sub: 'Renews December 2026',
            ),
            _MenuItem(
              icon: Icons.bar_chart_rounded,
              iconBg: C.goldDim,
              iconColor: C.gold,
              title: 'Analytics',
              sub: 'Views, leads, conversion',
            ),
          ],
        ),
        _MenuGroup(
          label: 'Support',
          items: [
            _MenuItem(
              icon: Icons.help_outline_rounded,
              iconBg: const Color(0x1A60A5FA),
              iconColor: const Color(0xFF60A5FA),
              title: 'Help Center',
              sub: 'FAQs, chat support',
            ),
            _MenuItem(
              icon: Icons.logout_rounded,
              iconBg: const Color(0x1AFF5A5F),
              iconColor: C.red,
              title: 'Sign Out',
              sub: 'Log out of your account',
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHARED COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBar extends StatelessWidget {
  const _StatusBar();
  @override
  Widget build(BuildContext ctx) => Container(
    color: C.bg,
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: SafeArea(
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('9:41', style: VT.bold(size: 13)),
          Row(
            children: const [
              Icon(Icons.signal_cellular_alt_rounded, color: C.text, size: 14),
              SizedBox(width: 5),
              Icon(Icons.wifi_rounded, color: C.text, size: 14),
              SizedBox(width: 5),
              Icon(Icons.battery_3_bar_rounded, color: C.text, size: 14),
            ],
          ),
        ],
      ),
    ),
  );
}

class _TrustPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustPill({required this.icon, required this.label});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: C.primary),
        const SizedBox(width: 6),
        Text(label, style: VT.label(size: 11)),
      ],
    ),
  );
}

class _TabToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabToggle({
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? C.primary : C.surface2,
        border: Border.all(color: active ? Colors.transparent : C.border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: active
            ? [BoxShadow(color: C.primaryGlow, blurRadius: 16)]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: VT.label(size: 13, color: active ? Colors.white : C.textMuted),
        ),
      ),
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard({required this.value, required this.label});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Text(value, style: VT.h1(size: 20, color: C.primary)),
        const SizedBox(height: 3),
        Text(label, style: VT.label(size: 10), textAlign: TextAlign.center),
      ],
    ),
  );
}

class _PropCard extends StatelessWidget {
  final Prop prop;
  const _PropCard({required this.prop});
  @override
  Widget build(BuildContext ctx) => Container(
    width: 230,
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(22),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Stack(
          children: [
            Image.network(
              prop.imgUrl,
              height: 150,
              width: 230,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: C.surface3,
                child: const Center(
                  child: Icon(Icons.home_rounded, color: C.textDim, size: 40),
                ),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [const Color(0xB307090F), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Verified tag
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: C.primary,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: C.primaryGlow, blurRadius: 12)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'VERIFIED',
                      style: VT.label(size: 9, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Price tag
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xCC07090F),
                  border: Border.all(color: C.border),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(prop.price, style: VT.bold(size: 12)),
              ),
            ),
            // ESV tag
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xB307090F),
                  border: Border.all(color: C.primary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  prop.esvNum,
                  style: VT.label(size: 9, color: C.primary),
                ),
              ),
            ),
          ],
        ),

        // Body
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prop.title, style: VT.h2(size: 14)),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 11,
                    color: C.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      prop.location,
                      style: VT.label(size: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _MetaItem(icon: Icons.bed_rounded, label: '${prop.beds} Bed'),
                  const SizedBox(width: 10),
                  _MetaItem(
                    icon: Icons.bathtub_rounded,
                    label: '${prop.baths} Bath',
                  ),
                  const SizedBox(width: 10),
                  _MetaItem(icon: prop.thirdIcon, label: prop.thirdMeta),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Agency: ',
                      style: VT.label(size: 11),
                      children: [
                        TextSpan(
                          text: prop.agency,
                          style: VT.label(size: 11, color: C.text),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: C.primaryDim,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${prop.accuracy.toInt()}% ✓',
                      style: VT.label(size: 10, color: C.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 11, color: C.textDim),
      const SizedBox(width: 4),
      Text(label, style: VT.label(size: 11)),
    ],
  );
}

class _AuditRow extends StatelessWidget {
  final Prop prop;
  const _AuditRow({required this.prop});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            prop.imgUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: C.surface3,
              child: const Icon(Icons.home_rounded, color: C.textDim),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prop.title, style: VT.bold(size: 13)),
              const SizedBox(height: 2),
              Text(prop.location, style: VT.label(size: 11)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(prop.price, style: VT.bold(size: 13, color: C.primary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: C.primaryDim,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      prop.esvNum,
                      style: VT.label(size: 9, color: C.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: C.textDim),
      ],
    ),
  );
}

class _ExploreRow extends StatelessWidget {
  final Prop prop;
  const _ExploreRow({required this.prop});
  @override
  Widget build(BuildContext ctx) => Container(
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(18),
    ),
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            prop.imgUrl,
            width: 76,
            height: 76,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 76,
              height: 76,
              color: C.surface3,
              child: const Icon(Icons.home_rounded, color: C.textDim, size: 30),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prop.title, style: VT.bold(size: 14)),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 11,
                    color: C.primary,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      prop.location,
                      style: VT.label(size: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(prop.price, style: VT.bold(size: 13, color: C.primary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: C.primaryDim,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${prop.accuracy.toInt()}% ✓',
                      style: VT.label(size: 10, color: C.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DealCard extends StatelessWidget {
  final Deal deal;
  const _DealCard({required this.deal});

  Color get _statusColor => deal.status == 'active'
      ? C.green
      : deal.status == 'pending'
      ? C.gold
      : C.primary;
  String get _statusLabel => deal.status == 'active'
      ? 'Active'
      : deal.status == 'pending'
      ? 'Pending'
      : 'Under Review';

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            deal.imgUrl,
            width: 68,
            height: 68,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 68,
              height: 68,
              color: C.surface3,
              child: const Icon(Icons.home_rounded, color: C.textDim, size: 28),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(deal.title, style: VT.bold(size: 14)),
              const SizedBox(height: 3),
              Text(deal.location, style: VT.label(size: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _statusLabel,
                      style: VT.label(size: 11, color: _statusColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(deal.price, style: VT.h2(size: 13, color: C.primary)),
      ],
    ),
  );
}

class _Timeline extends StatelessWidget {
  const _Timeline();
  @override
  Widget build(BuildContext ctx) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Tenancy Timeline', style: VT.h2(size: 14)),
      const SizedBox(height: 14),
      IntrinsicHeight(
        child: Row(
          children: [
            // Vertical line + dots
            Column(
              children: [
                _TlDot(done: true),
                Expanded(child: Container(width: 1, color: C.border)),
                _TlDot(done: true),
                Expanded(child: Container(width: 1, color: C.border)),
                _TlDot(current: true),
                Expanded(child: Container(width: 1, color: C.border)),
                _TlDot(done: false),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  _TlItem(
                    title: 'Application Submitted',
                    date: '14 May 2026',
                    done: true,
                  ),
                  const SizedBox(height: 18),
                  _TlItem(
                    title: 'Background Check Cleared',
                    date: '16 May 2026',
                    done: true,
                  ),
                  const SizedBox(height: 18),
                  _TlItem(
                    title: 'Agreement Signing',
                    date: 'In Progress',
                    current: true,
                  ),
                  const SizedBox(height: 18),
                  _TlItem(title: 'Move-in & Key Collection', date: 'Pending'),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _TlDot extends StatelessWidget {
  final bool done;
  final bool current;
  const _TlDot({this.done = false, this.current = false});
  @override
  Widget build(BuildContext ctx) => Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: done
          ? C.primary
          : current
          ? C.goldDim
          : C.surface3,
      border: current ? Border.all(color: C.gold, width: 2) : null,
    ),
    child: Center(
      child: done
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
          : current
          ? const Icon(Icons.hourglass_empty_rounded, color: C.gold, size: 14)
          : const Icon(Icons.circle, color: C.textDim, size: 8),
    ),
  );
}

class _TlItem extends StatelessWidget {
  final String title, date;
  final bool done;
  final bool current;
  const _TlItem({
    required this.title,
    required this.date,
    this.done = false,
    this.current = false,
  });
  @override
  Widget build(BuildContext ctx) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: VT.bold(
          size: 13,
          color: (done || current) ? C.text : C.textMuted,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        date,
        style: VT.label(size: 11, color: current ? C.gold : C.textMuted),
      ),
    ],
  );
}

class _BackBtn extends StatelessWidget {
  const _BackBtn();
  @override
  Widget build(BuildContext ctx) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: C.surface2,
      border: Border.all(color: C.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.arrow_back_rounded, color: C.textMuted, size: 18),
  );
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(label, style: VT.label(size: 10, color: color)),
  );
}

class _MenuGroup extends StatelessWidget {
  final String label;
  final List<_MenuItem> items;
  const _MenuGroup({required this.label, required this.items});
  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: VT.label(size: 11, color: C.textDim)),
        const SizedBox(height: 8),
        ...items,
      ],
    ),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, sub;
  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.sub,
  });
  @override
  Widget build(BuildContext ctx) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: C.border)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: VT.bold(size: 14)),
              Text(sub, style: VT.label(size: 12)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: C.textDim, size: 16),
      ],
    ),
  );
}
