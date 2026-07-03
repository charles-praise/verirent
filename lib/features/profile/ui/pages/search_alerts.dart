// =============================================================================
//  4. SEARCH ALERTS PAGE
// =============================================================================
//
import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../../home/features/listing/ui/pages/edit_listing.dart';
import '../widget/sub_bar.dart';

class SearchAlertsPage extends StatefulWidget {
  const SearchAlertsPage({super.key});

  @override
  State<SearchAlertsPage> createState() => _SearchAlertsPageState();
}

class _SearchAlertsPageState extends State<SearchAlertsPage> {
  final List<_AlertModel> _alerts = [
    _AlertModel(
      id: '1',
      name: '3-bed in GRA',
      category: 'Residential',
      listingType: 'Rent',
      area: 'GRA Phase 2',
      lga: 'Port Harcourt',
      minPrice: 1_000_000,
      maxPrice: 3_000_000,
      minBeds: 3,
      frequency: 'Instant',
      active: true,
      matchCount: 14,
    ),
    _AlertModel(
      id: '2',
      name: 'Office space D-Line',
      category: 'Commercial',
      listingType: 'Rent',
      area: 'D-Line',
      lga: 'Port Harcourt',
      minPrice: 1_500_000,
      maxPrice: 5_000_000,
      frequency: 'Daily',
      active: true,
      matchCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceVariant,
      appBar: SubBar(title: 'Search Alerts'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAlert(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Alert'),
      ),
      body: _alerts.isEmpty
          ? _EmptyAlerts(onCreate: () => _showCreateAlert(context))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                    border: Border.all(color: cs.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active_rounded,
                        size: 16,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You\'ll be notified when new listings match your criteria.',
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurface,
                            height: 1.5,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ..._alerts.map(
                  (a) => _AlertCard(
                    alert: a,
                    onToggle: (v) => setState(() => a.active = v),
                    onDelete: () => setState(() => _alerts.remove(a)),
                    onEdit: () => _showCreateAlert(context, existing: a),
                  ),
                ),
              ],
            ),
    );
  }

  void _showCreateAlert(BuildContext context, {_AlertModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateAlertSheet(
        existing: existing,
        onSave: (alert) {
          setState(() {
            if (existing != null) {
              final idx = _alerts.indexWhere((a) => a.id == existing.id);
              if (idx >= 0) _alerts[idx] = alert;
            } else {
              _alerts.add(alert);
            }
          });
        },
      ),
    );
  }
}

class _AlertModel {
  _AlertModel({
    required this.id,
    required this.name,
    required this.category,
    required this.listingType,
    required this.area,
    required this.lga,
    required this.minPrice,
    required this.maxPrice,
    this.minBeds,
    required this.frequency,
    required this.active,
    required this.matchCount,
  });
  final String id, name, category, listingType, area, lga, frequency;
  final int minPrice, maxPrice;
  final int? minBeds;
  bool active;
  final int matchCount;
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });
  final _AlertModel alert;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete, onEdit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(
          color: alert.active ? cs.primary.withOpacity(0.3) : cs.outlineVariant,
          width: alert.active ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  size: 18,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.name,
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      '${alert.matchCount} matching listings',
                      style: VeriRentText.bodySmall.copyWith(color: cs.primary),
                    ),
                  ],
                ),
              ),
              Switch(value: alert.active, onChanged: onToggle),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _FilterTag(alert.category),
              _FilterTag(alert.listingType),
              _FilterTag(alert.area),
              _FilterTag('₦${_fmt(alert.minPrice)} – ₦${_fmt(alert.maxPrice)}'),
              if (alert.minBeds != null) _FilterTag('${alert.minBeds}+ beds'),
              _FilterTag('🔔 ${alert.frequency}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 14,
                  color: VeriRentColors.red,
                ),
                label: Text(
                  'Delete',
                  style: TextStyle(color: VeriRentColors.red),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1_000_000) return '${(n / 1_000_000).toStringAsFixed(1)}M';
    if (n >= 1_000) return '${(n / 1_000).round()}k';
    return '$n';
  }
}

class _FilterTag extends StatelessWidget {
  const _FilterTag(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        label,
        style: VeriRentText.labelSmall.copyWith(
          color: cs.onSurface,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 56,
              color: cs.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Search Alerts',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Create an alert and we\'ll notify you instantly when a '
              'matching property is listed.',
              style: VeriRentText.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create First Alert'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateAlertSheet extends StatefulWidget {
  const _CreateAlertSheet({this.existing, required this.onSave});
  final _AlertModel? existing;
  final ValueChanged<_AlertModel> onSave;

  @override
  State<_CreateAlertSheet> createState() => _CreateAlertSheetState();
}

class _CreateAlertSheetState extends State<_CreateAlertSheet> {
  final _nameCtrl = TextEditingController();
  String? _category = 'Residential';
  String? _listingType = 'Rent';
  String? _area;
  String? _lga;
  int _minBeds = 1;
  final _minPriceCtrl = TextEditingController();
  final _maxPriceCtrl = TextEditingController();
  String _frequency = 'Instant';

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _nameCtrl.text = e.name;
      _category = e.category;
      _listingType = e.listingType;
      _area = e.area;
      _lga = e.lga;
      _minBeds = e.minBeds ?? 1;
      _minPriceCtrl.text = '${e.minPrice}';
      _maxPriceCtrl.text = '${e.maxPrice}';
      _frequency = e.frequency;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final botPad = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(VeriRentRadius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        botPad + 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.existing == null ? 'Create Search Alert' : 'Edit Alert',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 20),

            fieldLabel(context, 'Alert Name', required: true),
            TextFormField(
              controller: _nameCtrl,
              style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              decoration: const InputDecoration(
                hintText: 'e.g. 3-bed in GRA',
                prefixIcon: Icon(Icons.label_outline_rounded, size: 18),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SimpleDropdown(
                    label: 'Category',
                    value: _category,
                    items: const [
                      'Residential',
                      'Land',
                      'Commercial',
                      'Estate',
                      'Short-let',
                    ],
                    onChanged: (v) => setState(() => _category = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SimpleDropdown(
                    label: 'Type',
                    value: _listingType,
                    items: const ['Rent', 'Sale'],
                    onChanged: (v) => setState(() => _listingType = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fieldLabel(context, 'Min Price (₦)'),
                      TextFormField(
                        controller: _minPriceCtrl,
                        keyboardType: TextInputType.number,
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                        decoration: const InputDecoration(
                          hintText: '500000',
                          prefixText: '₦ ',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fieldLabel(context, 'Max Price (₦)'),
                      TextFormField(
                        controller: _maxPriceCtrl,
                        keyboardType: TextInputType.number,
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                        decoration: const InputDecoration(
                          hintText: '3000000',
                          prefixText: '₦ ',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SimpleDropdown(
              label: 'Notification Frequency',
              value: _frequency,
              items: const ['Instant', 'Daily Digest', 'Weekly Summary'],
              onChanged: (v) => setState(() => _frequency = v ?? 'Instant'),
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                widget.existing == null ? 'Create Alert' : 'Update Alert',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;
    widget.onSave(
      _AlertModel(
        id:
            widget.existing?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text.trim(),
        category: _category ?? 'Residential',
        listingType: _listingType ?? 'Rent',
        area: _area ?? '',
        lga: _lga ?? '',
        minPrice: int.tryParse(_minPriceCtrl.text) ?? 0,
        maxPrice: int.tryParse(_maxPriceCtrl.text) ?? 999_000_000,
        minBeds: _minBeds,
        frequency: _frequency,
        active: true,
        matchCount: 0,
      ),
    );
    Navigator.pop(context);
  }
}
