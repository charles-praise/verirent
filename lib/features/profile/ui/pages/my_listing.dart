// =============================================================================
//  2. MY LISTINGS PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:verirent/core/util/share.dart';
import 'package:verirent/features/home/features/listing/ui/pages/create_listing.dart';
import 'package:verirent/features/home/features/listing/ui/pages/edit_listing.dart';

import '../../../../core/theme/agents_theme.dart';
import '../widget/sub_bar.dart';

enum ListingTab { active, pending, rejected, draft }

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // Simulated data — in production feed from ListingCubit
  static final _active = [
    _mockListing('res_01', 'active'),
    _mockListing('com_01', 'active'),
  ];
  static final _pending = [_mockListing('land_01', 'pending')];
  static final _rejected = <Map<String, dynamic>>[];
  static final _draft = [_mockListing('sht_01', 'draft')];

  static Map<String, dynamic> _mockListing(String id, String status) => {
    'id': id,
    'title': id.startsWith('res')
        ? '3 Bedroom Flat, GRA Phase 2'
        : id.startsWith('com')
        ? 'Office Space, 85 sqm — D-Line'
        : id.startsWith('land')
        ? 'Dry Land, 648 sqm — Rumuigbo'
        : 'Luxury 2-Bed Shortlet, Rumuola',
    'price': id.startsWith('res')
        ? '₦1,800,000/yr'
        : id.startsWith('com')
        ? '₦2,200,000/yr'
        : id.startsWith('land')
        ? '₦18,500,000'
        : '₦35,000/night',
    'category': id.startsWith('res')
        ? 'Residential'
        : id.startsWith('com')
        ? 'Commercial'
        : id.startsWith('land')
        ? 'Land'
        : 'Short-let',
    'status': status,
    'views': 142,
    'enquiries': 7,
    'updated': '2 days ago',
    'imageUrl':
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400',
  };

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceVariant,
      appBar: SubBar(
        title: 'My Listings',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 22),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateListingPage()),
            ),
            tooltip: 'Add listing',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats banner
          Container(
            color: cs.surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                _StatPill(
                  'Active',
                  '${_active.length}',
                  VeriRentColors.success500,
                ),
                const SizedBox(width: 8),
                _StatPill('Pending', '${_pending.length}', VeriRentColors.gold),
                const SizedBox(width: 8),
                _StatPill('Draft', '${_draft.length}', cs.onSurfaceVariant),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: VeriRentColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    border: Border.all(
                      color: VeriRentColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_rounded,
                        size: 12,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '284 total views',
                        style: VeriRentText.labelSmall.copyWith(
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            color: cs.surface,
            child: TabBar(
              controller: _tabs,
              tabs: [
                Tab(text: 'Active (${_active.length})'),
                Tab(text: 'Pending (${_pending.length})'),
                Tab(text: 'Rejected (${_rejected.length})'),
                Tab(text: 'Drafts (${_draft.length})'),
              ],
              labelStyle: VeriRentText.labelMedium,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _ListingList(
                  items: _active,
                  emptyIcon: Icons.home_work_outlined,
                  emptyMsg: 'No active listings yet.\nTap + to add one.',
                ),
                _ListingList(
                  items: _pending,
                  emptyIcon: Icons.hourglass_empty_rounded,
                  emptyMsg: 'No listings pending review.',
                ),
                _ListingList(
                  items: _rejected,
                  emptyIcon: Icons.cancel_outlined,
                  emptyMsg: 'No rejected listings.',
                ),
                _ListingList(
                  items: _draft,
                  emptyIcon: Icons.edit_note_rounded,
                  emptyMsg: 'No drafts saved.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill(this.label, this.value, this.color);
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$value $label',
          style: VeriRentText.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ListingList extends StatelessWidget {
  const _ListingList({
    required this.items,
    required this.emptyIcon,
    required this.emptyMsg,
  });
  final List<Map<String, dynamic>> items;
  final IconData emptyIcon;
  final String emptyMsg;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final cs = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 48, color: cs.outlineVariant),
            const SizedBox(height: 12),
            Text(
              emptyMsg,
              style: VeriRentText.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _MyListingCard(item: items[i]),
    );
  }
}

class _MyListingCard extends StatelessWidget {
  const _MyListingCard({required this.item});
  final Map<String, dynamic> item;

  Color _statusColor(String s) {
    switch (s) {
      case 'active':
        return VeriRentColors.success500;
      case 'pending':
        return VeriRentColors.gold;
      case 'rejected':
        return VeriRentColors.red;
      default:
        return VeriRentColors.neutral400;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'active':
        return 'Live';
      case 'pending':
        return 'Under Review';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Draft';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final status = item['status'] as String;
    final sColor = _statusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + status row
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(VeriRentRadius.lg),
                  bottomLeft: Radius.circular(VeriRentRadius.lg),
                ),
                child: Container(
                  width: 88,
                  height: 88,
                  color: cs.primary.withOpacity(0.08),
                  child: Icon(Icons.home_rounded, size: 32, color: cs.primary),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              style: VeriRentText.titleSmall.copyWith(
                                color: cs.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: sColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(
                                VeriRentRadius.full,
                              ),
                              border: Border.all(
                                color: sColor.withOpacity(0.35),
                              ),
                            ),
                            child: Text(
                              _statusLabel(status),
                              style: VeriRentText.labelSmall.copyWith(
                                color: sColor,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['price'],
                        style: VeriRentText.labelMedium.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _MetaChip(
                            Icons.visibility_rounded,
                            '${item['views']} views',
                          ),
                          const SizedBox(width: 8),
                          _MetaChip(
                            Icons.message_outlined,
                            '${item['enquiries']} enquiries',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Action row
          Divider(height: 1, color: cs.outlineVariant),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Updated ${item['updated']}',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                _ActionBtn(
                  Icons.edit_outlined,
                  'Edit',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditListingPage()),
                  ),
                ),
                const SizedBox(width: 8),
                _ActionBtn(Icons.share_outlined, 'Share', () => share(context)),
                // const SizedBox(width: 8),
                // _ActionBtn(
                //   Icons.more_horiz_rounded,
                //   'More',
                //   () => _showMore(context, status),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMore(BuildContext context, String status) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(VeriRentRadius.xl),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            if (status == 'active')
              _BottomAction(
                Icons.pause_circle_outline_rounded,
                'Pause Listing',
                VeriRentColors.gold,
                () {},
              ),
            _BottomAction(
              Icons.analytics_outlined,
              'View Analytics',
              Theme.of(context).colorScheme.primary,
              () {},
            ),
            _BottomAction(
              Icons.content_copy_rounded,
              'Duplicate Listing',
              Theme.of(context).colorScheme.primary,
              () {},
            ),
            _BottomAction(
              Icons.delete_outline_rounded,
              'Delete Listing',
              VeriRentColors.red,
              () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(VeriRentRadius.sm),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: cs.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              label,
              style: VeriRentText.labelSmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction(this.icon, this.label, this.color, this.onTap);
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      leading: Icon(icon, color: color, size: 20),
      title: Text(label, style: VeriRentText.bodyMedium.copyWith(color: color)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
