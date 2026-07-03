// =============================================================================
//  3. EDIT LISTING PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/agents_theme.dart';
import '../../../../../profile/ui/widget/sub_bar.dart';

class EditListingPage extends StatefulWidget {
  const EditListingPage({super.key, this.listingId});
  final String? listingId;

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController(text: '3 Bedroom Flat, GRA Phase 2');
  final _descCtrl = TextEditingController(
    text:
        'A spacious and well-maintained 3-bedroom flat in the serene '
        'GRA Phase 2 area of Port Harcourt.',
  );
  final _priceCtrl = TextEditingController(text: '1800000');
  final _addressCtrl = TextEditingController(text: '14 Aba Road');

  String? _priceUnit = 'per year';
  String? _paymentTerms = 'Lump sum or 2 installments';
  String? _availability = 'Available Now';
  bool _isVisible = true;
  bool _isFeatured = false;
  bool _saving = false;
  int _photoCount = 3;

  final Set<String> _amenities = {
    'Prepaid Meter',
    'Borehole Water',
    'Dedicated Parking',
    'Security Guard',
  };

  @override
  void dispose() {
    for (final c in [_titleCtrl, _descCtrl, _priceCtrl, _addressCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceVariant,
      appBar: SubBar(
        title: 'Edit Listing',
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              'Update',
              style: VeriRentText.labelLarge.copyWith(
                color: _saving ? cs.onSurfaceVariant : cs.primary,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VeriRentColors.success500.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(VeriRentRadius.md),
                  border: Border.all(
                    color: VeriRentColors.success500.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: VeriRentColors.success500,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This listing is Live. Changes take effect immediately after saving.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: VeriRentColors.success500,
                          height: 1.5,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),

              sectionLabel(context, 'Listing Title & Description'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldLabel(context, 'Title', required: true),
                    TextFormField(
                      controller: _titleCtrl,
                      maxLength: 80,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 3 Bedroom Flat, GRA Phase 2',
                        prefixIcon: Icon(Icons.title_rounded, size: 18),
                        counterText: '',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    fieldLabel(context, 'Description'),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 4,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Describe the property…',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),

              sectionLabel(context, 'Pricing & Availability'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldLabel(context, 'Price (₦)', required: true),
                    TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: '1800000',
                        prefixIcon: Icon(Icons.attach_money_rounded, size: 18),
                        prefixText: '₦ ',
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Price required' : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SimpleDropdown(
                            label: 'Price Unit',
                            value: _priceUnit,
                            items: const [
                              'per year',
                              'per month',
                              'per night',
                              'asking price',
                              'per sqm',
                            ],
                            onChanged: (v) => setState(() => _priceUnit = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SimpleDropdown(
                            label: 'Availability',
                            value: _availability,
                            items: const [
                              'Available Now',
                              'Available in 1 Month',
                              'Available in 3 Months',
                              'Not Available',
                            ],
                            onChanged: (v) => setState(() => _availability = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SimpleDropdown(
                      label: 'Payment Terms',
                      value: _paymentTerms,
                      items: const [
                        'Lump sum',
                        '2 installments',
                        '6-month plan',
                        '12-month plan',
                        'Negotiable',
                        'Lump sum or 2 installments',
                      ],
                      onChanged: (v) => setState(() => _paymentTerms = v),
                    ),
                  ],
                ),
              ),

              sectionLabel(context, 'Photos'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_photoCount photos attached',
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => setState(() => _photoCount++),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Add Photos'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _photoCount + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          if (i < _photoCount)
                            return Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: cs.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.md,
                                    ),
                                    border: Border.all(
                                      color: cs.primary.withOpacity(0.25),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.image_rounded,
                                    size: 24,
                                    color: cs.primary,
                                  ),
                                ),
                                if (i == 0)
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cs.primary,
                                        borderRadius: BorderRadius.circular(
                                          VeriRentRadius.full,
                                        ),
                                      ),
                                      child: Text(
                                        'Cover',
                                        style: VeriRentText.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _photoCount = (_photoCount - 1)
                                          .clamp(0, 99),
                                    ),
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: VeriRentColors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          return GestureDetector(
                            onTap: () => setState(() => _photoCount++),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: cs.surfaceVariant,
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.md,
                                ),
                                border: Border.all(color: cs.outlineVariant),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 20,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Add',
                                    style: VeriRentText.labelSmall.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              sectionLabel(context, 'Amenities'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._amenities.map(
                      (a) => _AmenityChip(
                        label: a,
                        selected: true,
                        onToggle: () => setState(() => _amenities.remove(a)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.md,
                          ),
                          border: Border.all(
                            color: cs.outlineVariant,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 12,
                              color: cs.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Add More',
                              style: VeriRentText.labelMedium.copyWith(
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              sectionLabel(context, 'Visibility Settings'),
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  children: [
                    _PrivacyToggle(
                      label: 'Listing Visible',
                      subtitle: 'Turn off to temporarily hide from search',
                      value: _isVisible,
                      onChanged: (v) => setState(() => _isVisible = v),
                    ),
                    Divider(height: 1, color: cs.outlineVariant, indent: 16),
                    _PrivacyToggle(
                      label: 'Featured Listing',
                      subtitle: 'Appears in featured section (Pro+ only)',
                      value: _isFeatured,
                      onChanged: (v) => setState(() => _isFeatured = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmUnpublish(context),
                icon: const Icon(
                  Icons.unpublished_outlined,
                  size: 16,
                  color: VeriRentColors.red,
                ),
                label: Text(
                  'Unpublish Listing',
                  style: VeriRentText.labelLarge.copyWith(
                    color: VeriRentColors.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: VeriRentColors.red),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing updated successfully.')),
      );
      Navigator.maybePop(context);
    }
  }

  void _confirmUnpublish(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unpublish Listing?'),
        content: const Text(
          'This listing will be removed from search results until '
          'you republish it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Unpublish',
              style: TextStyle(color: VeriRentColors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(context, label),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            'Select',
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          onChanged: onChanged,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              borderSide: BorderSide(color: cs.outline),
            ),
          ),
        ),
      ],
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({
    required this.label,
    required this.selected,
    required this.onToggle,
  });
  final String label;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(0.10) : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: 12, color: cs.primary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: VeriRentText.labelMedium.copyWith(
                color: selected ? cs.primary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyToggle extends StatelessWidget {
  const _PrivacyToggle({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        label,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
