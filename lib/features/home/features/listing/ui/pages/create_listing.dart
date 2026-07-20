// =============================================================================
//  VeriRent NG — Create Listing Page  (Multi-Step Wizard)
//  File: lib/features/listing/ui/pages/create_listing_page.dart
//
//  Step flow:
//   Gate 0 — KYC hard block (unverified users can't proceed at all)
//   Step 1 — Category selection  (tier-gated: Basic → Residential only)
//   Step 2 — Listing type + property sub-type
//   Step 3 — Basic details  (title, description, address, LGA, price)
//   Step 4 — Category-specific details
//              Residential  → rooms, condition, furnishing, security toggles
//              Land         → dims, survey plan, doc type, infrastructure
//              Commercial   → office type, layout, floor, facilities
//              Estate       → unit count, unit beds/baths, payment plans
//              Shortlet     → check-in/out, house rules, cancellation
//   Step 5 — Amenities  (category-tailored checklist)
//   Step 6 — Photos     (placeholder grid, min 1 to proceed)
//   Step 7 — Review & legal consent → Submit
//   State 8 — Success screen
//
//  Regulatory compliance surface:
//   - NDPR notice on data collection (Step 3)
//   - Rivers State Tenancy Law rent cap warning (Step 3, rent listings)
//   - ESVARBON/NIESV licence requirement enforced at KYC Gate
//   - C of O / title doc requirement for Land & Estate (Step 4)
//   - Legal compliance declaration before submit (Step 7)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/models/property/property_model.dart';
import '../../../../../../core/theme/agents_theme.dart';

// =============================================================================
//  ENTRY POINT
// =============================================================================

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  // ── Simulated auth state — replace with BLoC/Cubit reads in production ───
  static const bool _isKycVerified = true;
  static const String _userTier = 'Pro'; // 'Basic' | 'Pro' | 'Enterprise'
  static const bool _hasEsvarbonLicence = true;
  // ─────────────────────────────────────────────────────────────────────────

  int _step = 0;
  static const int _totalSteps = 7;

  // ── Step 1 ────────────────────────────────────────────────────────────────
  PropertyCategory? _category;

  // ── Step 2 ────────────────────────────────────────────────────────────────
  ListingType? _listingType;
  PropertyType? _propertyType;

  // ── Step 3 ────────────────────────────────────────────────────────────────
  final _step3Key = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _neighbourhoodCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _areaSqmCtrl = TextEditingController();
  String? _lga;
  String? _priceUnit;
  String? _paymentTerms;
  bool _ndprConsent = false;

  // ── Step 4 — Residential ─────────────────────────────────────────────────
  int _bedrooms = 1, _bathrooms = 1, _toilets = 1;
  String? _furnishing, _condition, _waterSupply, _powerSupply;
  bool _hasAC = false, _hasParking = false, _hasGarden = false;
  bool _isFenced = true, _hasGuard = false, _hasCCTV = false;

  // ── Step 4 — Land ────────────────────────────────────────────────────────
  final _dimsCtrl = TextEditingController();
  final _surveyNumCtrl = TextEditingController();
  String? _landUse, _documentType;
  bool _hasFrontage = false, _hasTarredRoad = false;
  bool _hasDrainage = false, _hasElecPoles = false;

  // ── Step 4 — Commercial ──────────────────────────────────────────────────
  String? _officeType, _layoutType;
  int _floorLevel = 0, _parkingSpaces = 0;
  bool _hasHVAC = false, _hasElevator = false;
  bool _hasConferenceRoom = false, _hasInternet = false;
  bool _has24HrPower = false, _hasFireSafety = false;
  int _minLeaseMonths = 12;

  // ── Step 4 — Estate ──────────────────────────────────────────────────────
  int _unitCount = 10, _unitBeds = 3, _unitBaths = 2;
  String? _estatePlan;
  bool _hasEstateCof0 = false;

  // ── Step 4 — Shortlet ────────────────────────────────────────────────────
  int _sltBeds = 1, _sltBaths = 1;
  final _checkInCtrl = TextEditingController(text: '2:00 PM');
  final _checkOutCtrl = TextEditingController(text: '12:00 PM');
  bool _sltWifi = false, _sltHousekeeping = false;
  bool _sltPets = false, _sltSmoking = false;
  String? _cancellationPolicy;

  // ── Step 5 ────────────────────────────────────────────────────────────────
  final Set<String> _amenities = {};

  // ── Step 6 ────────────────────────────────────────────────────────────────
  int _photoCount = 0;

  // ── Step 7 ────────────────────────────────────────────────────────────────
  bool _legalConsent = false;
  bool _submitting = false;
  bool _submitted = false;

  // ── Derived ───────────────────────────────────────────────────────────────
  bool _canListCategory(PropertyCategory c) {
    if (_userTier == 'Basic') return c == PropertyCategory.residential;
    return true;
  }

  bool get _stepValid {
    switch (_step) {
      case 0:
        return _category != null;
      case 1:
        return _listingType != null && _propertyType != null;
      case 2:
        return _ndprConsent &&
            _titleCtrl.text.trim().isNotEmpty &&
            _priceCtrl.text.trim().isNotEmpty &&
            _lga != null;
      case 5:
        return _photoCount >= 1;
      case 6:
        return _legalConsent;
      default:
        return true;
    }
  }

  void _next() {
    if (_step == 2) {
      if (!(_step3Key.currentState?.validate() ?? false)) return;
    }
    if (_step < _totalSteps) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descCtrl,
      _addressCtrl,
      _neighbourhoodCtrl,
      _priceCtrl,
      _areaSqmCtrl,
      _dimsCtrl,
      _surveyNumCtrl,
      _checkInCtrl,
      _checkOutCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
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
        body: !_isKycVerified
            ? _KycGate(hasLicence: _hasEsvarbonLicence)
            : _submitted
            ? _SuccessScreen(onDone: () => Navigator.maybePop(context))
            : Column(
                children: [
                  _TopBar(
                    step: _step,
                    total: _totalSteps,
                    onBack: _step == 0
                        ? () => Navigator.maybePop(context)
                        : _back,
                  ),
                  _ProgressRail(step: _step, total: _totalSteps),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _buildStep(),
                    ),
                  ),
                  _BottomBar(
                    step: _step,
                    total: _totalSteps,
                    enabled: _stepValid,
                    submitting: _submitting,
                    onNext: _next,
                    onBack: _back,
                    onSubmit: _submit,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StepCategory(
          key: const ValueKey('s0'),
          selected: _category,
          userTier: _userTier,
          canList: _canListCategory,
          onSelect: (c) => setState(() {
            _category = c;
            if (c == PropertyCategory.land) {
              _listingType = ListingType.sale;
              _propertyType = PropertyType.land;
            }
            if (c == PropertyCategory.shortLet) {
              _listingType = ListingType.rent;
              _propertyType = PropertyType.apartment;
            }
            if (c == PropertyCategory.commercial) {
              _propertyType = PropertyType.office;
            }
          }),
        );
      case 1:
        return _StepType(
          key: const ValueKey('s1'),
          category: _category!,
          listingType: _listingType,
          propertyType: _propertyType,
          onListingType: (v) => setState(() => _listingType = v),
          onPropertyType: (v) => setState(() => _propertyType = v),
        );
      case 2:
        return _StepBasicDetails(
          key: const ValueKey('s2'),
          formKey: _step3Key,
          category: _category!,
          listingType: _listingType!,
          titleCtrl: _titleCtrl,
          descCtrl: _descCtrl,
          addressCtrl: _addressCtrl,
          neighbourhoodCtrl: _neighbourhoodCtrl,
          priceCtrl: _priceCtrl,
          areaSqmCtrl: _areaSqmCtrl,
          lga: _lga,
          priceUnit: _priceUnit,
          paymentTerms: _paymentTerms,
          ndprConsent: _ndprConsent,
          onLga: (v) => setState(() => _lga = v),
          onPriceUnit: (v) => setState(() => _priceUnit = v),
          onPaymentTerms: (v) => setState(() => _paymentTerms = v),
          onNdpr: (v) => setState(() => _ndprConsent = v),
          onChange: () => setState(() {}),
        );
      case 3:
        return _StepSpecific(
          key: const ValueKey('s3'),
          category: _category!,
          listingType: _listingType!,
          // residential
          bedrooms: _bedrooms,
          bathrooms: _bathrooms,
          toilets: _toilets,
          furnishing: _furnishing,
          condition: _condition,
          waterSupply: _waterSupply,
          powerSupply: _powerSupply,
          hasAC: _hasAC,
          hasParking: _hasParking,
          hasGarden: _hasGarden,
          isFenced: _isFenced,
          hasGuard: _hasGuard,
          hasCCTV: _hasCCTV,
          onBeds: (v) => setState(() => _bedrooms = v),
          onBaths: (v) => setState(() => _bathrooms = v),
          onToilets: (v) => setState(() => _toilets = v),
          onFurnishing: (v) => setState(() => _furnishing = v),
          onCondition: (v) => setState(() => _condition = v),
          onWater: (v) => setState(() => _waterSupply = v),
          onPower: (v) => setState(() => _powerSupply = v),
          onAC: (v) => setState(() => _hasAC = v),
          onParking: (v) => setState(() => _hasParking = v),
          onGarden: (v) => setState(() => _hasGarden = v),
          onFenced: (v) => setState(() => _isFenced = v),
          onGuard: (v) => setState(() => _hasGuard = v),
          onCCTV: (v) => setState(() => _hasCCTV = v),
          // land
          dimsCtrl: _dimsCtrl,
          surveyNumCtrl: _surveyNumCtrl,
          landUse: _landUse,
          documentType: _documentType,
          hasFrontage: _hasFrontage,
          hasTarredRoad: _hasTarredRoad,
          hasDrainage: _hasDrainage,
          hasElecPoles: _hasElecPoles,
          onLandUse: (v) => setState(() => _landUse = v),
          onDocType: (v) => setState(() => _documentType = v),
          onFrontage: (v) => setState(() => _hasFrontage = v),
          onTarred: (v) => setState(() => _hasTarredRoad = v),
          onDrainage: (v) => setState(() => _hasDrainage = v),
          onElecPoles: (v) => setState(() => _hasElecPoles = v),
          // commercial
          officeType: _officeType,
          layoutType: _layoutType,
          floorLevel: _floorLevel,
          parkingSpaces: _parkingSpaces,
          hasHVAC: _hasHVAC,
          hasElevator: _hasElevator,
          hasConferenceRoom: _hasConferenceRoom,
          hasInternet: _hasInternet,
          has24HrPower: _has24HrPower,
          hasFireSafety: _hasFireSafety,
          minLeaseMonths: _minLeaseMonths,
          onOfficeType: (v) => setState(() => _officeType = v),
          onLayoutType: (v) => setState(() => _layoutType = v),
          onFloorLevel: (v) => setState(() => _floorLevel = v),
          onParkingSpaces: (v) => setState(() => _parkingSpaces = v),
          onHVAC: (v) => setState(() => _hasHVAC = v),
          onElevator: (v) => setState(() => _hasElevator = v),
          onConference: (v) => setState(() => _hasConferenceRoom = v),
          onInternet: (v) => setState(() => _hasInternet = v),
          on24Pwr: (v) => setState(() => _has24HrPower = v),
          onFire: (v) => setState(() => _hasFireSafety = v),
          onMinLease: (v) => setState(() => _minLeaseMonths = v),
          // estate
          unitCount: _unitCount,
          unitBeds: _unitBeds,
          unitBaths: _unitBaths,
          estatePlan: _estatePlan,
          hasEstateCof0: _hasEstateCof0,
          onUnitCount: (v) => setState(() => _unitCount = v),
          onUnitBeds: (v) => setState(() => _unitBeds = v),
          onUnitBaths: (v) => setState(() => _unitBaths = v),
          onEstatePlan: (v) => setState(() => _estatePlan = v),
          onEstateCof0: (v) => setState(() => _hasEstateCof0 = v),
          // shortlet
          sltBeds: _sltBeds,
          sltBaths: _sltBaths,
          checkInCtrl: _checkInCtrl,
          checkOutCtrl: _checkOutCtrl,
          sltWifi: _sltWifi,
          sltHousekeeping: _sltHousekeeping,
          sltPets: _sltPets,
          sltSmoking: _sltSmoking,
          cancellationPolicy: _cancellationPolicy,
          onSltBeds: (v) => setState(() => _sltBeds = v),
          onSltBaths: (v) => setState(() => _sltBaths = v),
          onSltWifi: (v) => setState(() => _sltWifi = v),
          onSltHousekeeping: (v) => setState(() => _sltHousekeeping = v),
          onSltPets: (v) => setState(() => _sltPets = v),
          onSltSmoking: (v) => setState(() => _sltSmoking = v),
          onCancellation: (v) => setState(() => _cancellationPolicy = v),
        );
      case 4:
        return _StepAmenities(
          key: const ValueKey('s4'),
          category: _category!,
          selected: _amenities,
          onToggle: (a) => setState(
            () => _amenities.contains(a)
                ? _amenities.remove(a)
                : _amenities.add(a),
          ),
        );
      case 5:
        return _StepPhotos(
          key: const ValueKey('s5'),
          count: _photoCount,
          onAdd: () => setState(() => _photoCount++),
          onRemove: () =>
              setState(() => _photoCount = (_photoCount - 1).clamp(0, 99)),
        );
      case 6:
        return _StepReview(
          key: const ValueKey('s6'),
          category: _category!,
          listingType: _listingType!,
          title: _titleCtrl.text,
          address: '${_addressCtrl.text}, ${_neighbourhoodCtrl.text}',
          lga: _lga ?? '—',
          price: _priceCtrl.text,
          priceUnit: _priceUnit ?? '—',
          description: _descCtrl.text,
          amenities: _amenities.toList(),
          photoCount: _photoCount,
          bedrooms: _bedrooms,
          bathrooms: _bathrooms,
          legalConsent: _legalConsent,
          onLegalConsent: (v) => setState(() => _legalConsent = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// =============================================================================
//  KYC GATE
// =============================================================================

class _KycGate extends StatelessWidget {
  const _KycGate({required this.hasLicence});
  final bool hasLicence;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, topPad + 12, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(height: 32),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: VeriRentColors.gold.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: VeriRentColors.gold.withOpacity(0.35),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.gavel_rounded,
              size: 38,
              color: VeriRentColors.gold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Verification Required to List',
            style: VeriRentText.headlineMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Text(
            'VeriRent NG is a regulated marketplace. Only verified ESVARBON or '
            'NIESV-licensed practitioners may list properties, in compliance '
            'with the Estate Surveyors and Valuers (Registration, etc.) Act and '
            'the Recovery of Premises Law of Rivers State.',
            style: VeriRentText.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 28),

          _RegCard(
            icon: Icons.badge_outlined,
            color: cs.primary,
            title: 'NIN / BVN Identity Verification',
            subtitle:
                'Links your listing to a real identity as required by the NDPR 2019.',
            done: false,
          ),
          const SizedBox(height: 10),
          _RegCard(
            icon: Icons.workspace_premium_outlined,
            color: VeriRentColors.gold,
            title: 'ESVARBON or NIESV Licence',
            subtitle:
                'Mandatory under Cap E13 LFN 2004 before listing real property in Nigeria.',
            done: hasLicence,
          ),
          const SizedBox(height: 10),
          _RegCard(
            icon: Icons.portrait_outlined,
            color: VeriRentColors.tierVerified,
            title: 'Selfie / Liveness Check',
            subtitle: 'Prevents impersonation and satisfies KYC obligations.',
            done: false,
          ),
          const SizedBox(height: 36),

          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.verified_user_outlined, size: 18),
            label: const Text('Complete Verification Now'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.maybePop(context),
              child: const Text('Maybe Later'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegCard extends StatelessWidget {
  const _RegCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.done,
  });
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(
          color: done
              ? VeriRentColors.success500.withOpacity(0.4)
              : cs.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (done ? VeriRentColors.success500 : color).withOpacity(
                0.10,
              ),
              borderRadius: BorderRadius.circular(VeriRentRadius.sm),
            ),
            child: Icon(
              done ? Icons.check_circle_rounded : icon,
              size: 18,
              color: done ? VeriRentColors.success500 : color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.55,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  CHROME — TopBar / ProgressRail / BottomBar
// =============================================================================

const _stepLabels = [
  'Property Category',
  'Listing Type',
  'Basic Details',
  'Specific Details',
  'Amenities',
  'Photos',
  'Review & Submit',
];

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.step,
    required this.total,
    required this.onBack,
  });
  final int step, total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: cs.surface,
      padding: EdgeInsets.fromLTRB(4, topPad + 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: onBack,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step < _stepLabels.length ? _stepLabels[step] : '',
                  style: VeriRentText.titleLarge.copyWith(color: cs.onSurface),
                ),
                Text(
                  'Step ${step + 1} of $total',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceVariant,
              borderRadius: BorderRadius.circular(VeriRentRadius.full),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 12,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Draft',
                  style: VeriRentText.labelSmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRail extends StatelessWidget {
  const _ProgressRail({required this.step, required this.total});
  final int step, total;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(
          total,
          (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                decoration: BoxDecoration(
                  color: i < step
                      ? VeriRentColors.success500
                      : i == step
                      ? cs.primary
                      : cs.outlineVariant,
                  borderRadius: BorderRadius.circular(VeriRentRadius.full),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.step,
    required this.total,
    required this.enabled,
    required this.submitting,
    required this.onNext,
    required this.onBack,
    required this.onSubmit,
  });
  final int step, total;
  final bool enabled, submitting;
  final VoidCallback onNext, onBack, onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final botPad = MediaQuery.of(context).padding.bottom;
    final isLast = step == total - 1;
    return Container(
      color: cs.surface,
      padding: EdgeInsets.fromLTRB(16, 10, 16, botPad + 10),
      child: Row(
        children: [
          if (step > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            flex: 2,
            child: isLast
                ? ElevatedButton.icon(
                    onPressed: (enabled && !submitting) ? onSubmit : null,
                    icon: submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(submitting ? 'Submitting…' : 'Submit Listing'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                  )
                : FilledButton(
                    onPressed: enabled ? onNext : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Continue'),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  SHARED ATOMS
// =============================================================================

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {this.required = false});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
          ),
          if (required)
            Text(
              ' *',
              style: VeriRentText.labelMedium.copyWith(
                color: VeriRentColors.red,
              ),
            ),
        ],
      ),
    );
  }
}

class _Sec extends StatelessWidget {
  const _Sec(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 22, 0, 10),
    child: Text(
      label.toUpperCase(),
      style: VeriRentText.labelSmall.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.1,
        fontSize: 10,
      ),
    ),
  );
}

Widget _infoBox(BuildContext context, String text, {Color? color}) {
  final c = color ?? VeriRentColors.info500;
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: c.withOpacity(0.06),
      borderRadius: BorderRadius.circular(VeriRentRadius.md),
      border: Border.all(color: c.withOpacity(0.25)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 15, color: c),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: VeriRentText.bodySmall.copyWith(color: c, height: 1.6),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    ),
  );
}

Widget _card(BuildContext context, Widget child) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(VeriRentRadius.lg),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: child,
  );
}

Widget _div(BuildContext context) =>
    Divider(height: 20, color: Theme.of(context).colorScheme.outlineVariant);

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 30,
  });
  final String label;
  final int value, min, max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
          ),
        ),
        _CBtn(
          Icons.remove_rounded,
          value > min,
          () => onChanged((value - 1).clamp(min, max)),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
          ),
        ),
        _CBtn(
          Icons.add_rounded,
          value < max,
          () => onChanged((value + 1).clamp(min, max)),
        ),
      ],
    );
  }
}

class _CBtn extends StatelessWidget {
  const _CBtn(this.icon, this.enabled, this.onTap);
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? cs.primary.withOpacity(0.10) : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(VeriRentRadius.sm),
          border: Border.all(
            color: enabled ? cs.primary.withOpacity(0.3) : cs.outlineVariant,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _DropField extends StatelessWidget {
  const _DropField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.required = false,
  });
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label, required: required),
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

// =============================================================================
//  STEP 1 — CATEGORY
// =============================================================================

class _StepCategory extends StatelessWidget {
  const _StepCategory({
    super.key,
    required this.selected,
    required this.userTier,
    required this.canList,
    required this.onSelect,
  });
  final PropertyCategory? selected;
  final String userTier;
  final bool Function(PropertyCategory) canList;
  final ValueChanged<PropertyCategory> onSelect;

  static const _cats = [
    (
      PropertyCategory.residential,
      Icons.home_rounded,
      'Residential',
      'Apartments, duplexes, houses & bungalows',
      VeriRentColors.primary,
      null,
    ),
    (
      PropertyCategory.land,
      Icons.landscape_rounded,
      'Land',
      'Plots, farmland & development sites',
      Color(0xFF4CAF50),
      null,
    ),
    (
      PropertyCategory.commercial,
      Icons.business_center_rounded,
      'Commercial',
      'Offices, shops, plazas & warehouses',
      VeriRentColors.info500,
      'Pro+',
    ),
    (
      PropertyCategory.estate,
      Icons.domain_rounded,
      'Estate / Gated Community',
      'Multi-unit developments with shared facilities',
      VeriRentColors.gold,
      'Pro+',
    ),
    (
      PropertyCategory.shortLet,
      Icons.weekend_rounded,
      'Short-let',
      'Furnished daily/weekly rentals',
      Color(0xFF7C3AED),
      'Pro+',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What type of property are you listing?',
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Your verification tier determines which categories are unlocked.',
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Tier context banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              border: Border.all(color: cs.primary.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 16,
                  color: VeriRentColors.gold,
                ),
                const SizedBox(width: 10),
                Text(
                  '$userTier Member — ',
                  style: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
                ),
                Expanded(
                  child: Text(
                    userTier == 'Basic'
                        ? 'Residential listings only. Upgrade to unlock more.'
                        : 'All categories unlocked.',
                    style: VeriRentText.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          ..._cats.map((c) {
            final locked = !canList(c.$1);
            final isSel = selected == c.$1;
            return GestureDetector(
              onTap: locked
                  ? () => _showUpgradeHint(context)
                  : () => onSelect(c.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSel
                      ? (c.$5 as Color).withOpacity(0.07)
                      : locked
                      ? cs.surfaceVariant.withOpacity(0.5)
                      : cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(
                    color: isSel
                        ? (c.$5 as Color)
                        : locked
                        ? cs.outlineVariant.withOpacity(0.5)
                        : cs.outlineVariant,
                    width: isSel ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: locked
                            ? cs.outlineVariant.withOpacity(0.25)
                            : (c.$5 as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      ),
                      child: Icon(
                        locked ? Icons.lock_rounded : c.$2,
                        size: 20,
                        color: locked ? cs.onSurfaceVariant : (c.$5 as Color),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c.$3,
                                style: VeriRentText.titleSmall.copyWith(
                                  color: locked
                                      ? cs.onSurfaceVariant
                                      : cs.onSurface,
                                ),
                              ),
                              if (c.$6 != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: VeriRentColors.gold.withOpacity(
                                      0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.full,
                                    ),
                                    border: Border.all(
                                      color: VeriRentColors.gold.withOpacity(
                                        0.4,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    c.$6!,
                                    style: VeriRentText.labelSmall.copyWith(
                                      color: VeriRentColors.gold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            locked
                                ? 'Upgrade to Pro to list ${c.$3} properties.'
                                : c.$4,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant.withOpacity(
                                locked ? 0.6 : 1,
                              ),
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    isSel
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: c.$5 as Color,
                            size: 20,
                          )
                        : locked
                        ? Icon(
                            Icons.lock_outline_rounded,
                            color: cs.outlineVariant,
                            size: 18,
                          )
                        : Icon(
                            Icons.chevron_right_rounded,
                            color: cs.outlineVariant,
                            size: 18,
                          ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showUpgradeHint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Upgrade to Pro to unlock this category.'),
        action: SnackBarAction(label: 'Upgrade', onPressed: () {}),
      ),
    );
  }
}

// =============================================================================
//  STEP 2 — LISTING TYPE + PROPERTY SUB-TYPE
// =============================================================================

class _StepType extends StatelessWidget {
  const _StepType({
    super.key,
    required this.category,
    required this.listingType,
    required this.propertyType,
    required this.onListingType,
    required this.onPropertyType,
  });
  final PropertyCategory category;
  final ListingType? listingType;
  final PropertyType? propertyType;
  final ValueChanged<ListingType> onListingType;
  final ValueChanged<PropertyType> onPropertyType;

  bool get _lockListingType =>
      category == PropertyCategory.land ||
      category == PropertyCategory.shortLet ||
      category == PropertyCategory.estate;

  List<PropertyType> get _types {
    switch (category) {
      case PropertyCategory.residential:
        return [
          PropertyType.apartment,
          PropertyType.duplex,
          PropertyType.house,
        ];
      case PropertyCategory.commercial:
        return [PropertyType.office];
      case PropertyCategory.estate:
        return [PropertyType.apartment, PropertyType.duplex];
      default:
        return [PropertyType.apartment];
    }
  }

  static const _typeInfo = {
    PropertyType.apartment: ('Apartment / Flat', Icons.apartment_rounded),
    PropertyType.duplex: ('Duplex / Terrace', Icons.villa_rounded),
    PropertyType.house: ('Detached House / Bungalow', Icons.house_rounded),
    PropertyType.land: ('Land / Plot', Icons.landscape_rounded),
    PropertyType.office: ('Office / Shop / Space', Icons.business_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you listing this property?',
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 20),
          const _Sec('Listing Purpose'),

          if (_lockListingType)
            _card(
              context,
              Row(
                children: [
                  Icon(
                    category == PropertyCategory.shortLet
                        ? Icons.key_rounded
                        : Icons.sell_rounded,
                    size: 16,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category == PropertyCategory.shortLet
                          ? 'Short-lets are always listed as For Rent.'
                          : category == PropertyCategory.estate
                          ? 'Estate units are always listed as For Sale.'
                          : 'Land is always listed as For Sale.',
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                _TypePill(
                  'For Rent',
                  Icons.key_rounded,
                  listingType == ListingType.rent,
                  () => onListingType(ListingType.rent),
                ),
                const SizedBox(width: 10),
                _TypePill(
                  'For Sale',
                  Icons.sell_rounded,
                  listingType == ListingType.sale,
                  () => onListingType(ListingType.sale),
                ),
              ],
            ),

          const _Sec('Property Sub-type'),
          ..._types.map((t) {
            final info = _typeInfo[t]!;
            final isSel = propertyType == t;
            return GestureDetector(
              onTap: () => onPropertyType(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSel ? cs.primary.withOpacity(0.07) : cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(
                    color: isSel ? cs.primary : cs.outlineVariant,
                    width: isSel ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      info.$2,
                      size: 18,
                      color: isSel ? cs.primary : cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        info.$1,
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSel)
                      Icon(
                        Icons.check_circle_rounded,
                        color: cs.primary,
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill(this.label, this.icon, this.selected, this.onTap);
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? cs.primary.withOpacity(0.08) : cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(
              color: selected ? cs.primary : cs.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: VeriRentText.labelMedium.copyWith(
                  color: selected ? cs.primary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  STEP 3 — BASIC DETAILS
// =============================================================================

const _lgas = [
  'Port Harcourt',
  'Obio-Akpor',
  'Eleme',
  'Etche',
  'Gokana',
  'Ikwerre',
  'Khana',
  'Ogba-Egbema-Ndoni',
  'Ogu-Bolo',
  'Okrika',
  'Omuma',
  'Opobo-Nkoro',
  'Oyigbo',
  'Tai',
];

class _StepBasicDetails extends StatelessWidget {
  const _StepBasicDetails({
    super.key,
    required this.formKey,
    required this.category,
    required this.listingType,
    required this.titleCtrl,
    required this.descCtrl,
    required this.addressCtrl,
    required this.neighbourhoodCtrl,
    required this.priceCtrl,
    required this.areaSqmCtrl,
    required this.lga,
    required this.priceUnit,
    required this.paymentTerms,
    required this.ndprConsent,
    required this.onLga,
    required this.onPriceUnit,
    required this.onPaymentTerms,
    required this.onNdpr,
    required this.onChange,
  });
  final GlobalKey<FormState> formKey;
  final PropertyCategory category;
  final ListingType listingType;
  final TextEditingController titleCtrl,
      descCtrl,
      addressCtrl,
      neighbourhoodCtrl,
      priceCtrl,
      areaSqmCtrl;
  final String? lga, priceUnit, paymentTerms;
  final bool ndprConsent;
  final ValueChanged<String?> onLga, onPriceUnit, onPaymentTerms;
  final ValueChanged<bool> onNdpr;
  final VoidCallback onChange;

  List<String> get _units {
    switch (category) {
      case PropertyCategory.shortLet:
        return ['per night', 'per week', 'per month'];
      case PropertyCategory.land:
        return ['asking price', 'per sqm'];
      case PropertyCategory.estate:
        return ['per unit', 'asking price'];
      case PropertyCategory.commercial:
        return ['per year', 'per month', 'asking price'];
      default:
        return ['per year', 'per month', 'asking price'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about the property',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 20),

            // ── NDPR consent — collected before any personal data ───────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: VeriRentColors.info500.withOpacity(0.06),
                borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                border: Border.all(
                  color: VeriRentColors.info500.withOpacity(0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.privacy_tip_outlined,
                        size: 16,
                        color: VeriRentColors.info500,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NDPR Data Notice',
                        style: VeriRentText.titleSmall.copyWith(
                          color: VeriRentColors.info500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your listing data (address, price, contact details) will be '
                    'stored and processed in accordance with the Nigeria Data '
                    'Protection Regulation (NDPR) 2019. It will be visible to '
                    'verified users on the VeriRent NG platform.',
                    style: VeriRentText.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.6,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: ndprConsent,
                        onChanged: (v) => onNdpr(v ?? false),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNdpr(!ndprConsent),
                          child: Text(
                            'I understand and consent to data processing under the NDPR.',
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const _Sec('Listing Title'),
            _FieldLabel('Property title', required: true),
            TextFormField(
              controller: titleCtrl,
              maxLength: 80,
              onChanged: (_) => onChange(),
              style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              decoration: const InputDecoration(
                hintText: 'e.g. 3 Bedroom Flat, GRA Phase 2',
                prefixIcon: Icon(Icons.title_rounded, size: 18),
                counterText: '',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            _FieldLabel('Description'),
            TextFormField(
              controller: descCtrl,
              maxLines: 4,
              style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              decoration: InputDecoration(
                hintText:
                    'Describe the property — key features, condition, surroundings…',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 56),
                  child: Icon(Icons.description_outlined, size: 18),
                ),
              ),
            ),

            const _Sec('Location'),
            _FieldLabel('Street address'),
            TextFormField(
              controller: addressCtrl,
              style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              decoration: const InputDecoration(
                hintText: 'e.g. 14 Aba Road',
                prefixIcon: Icon(Icons.location_on_outlined, size: 18),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Neighbourhood', required: true),
                      TextFormField(
                        controller: neighbourhoodCtrl,
                        onChanged: (_) => onChange(),
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g. GRA Phase 2',
                          prefixIcon: Icon(Icons.map_outlined, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DropField(
                    label: 'LGA',
                    required: true,
                    value: lga,
                    items: _lgas,
                    onChanged: onLga,
                  ),
                ),
              ],
            ),

            const _Sec('Pricing'),

            // Rivers State rent cap advisory
            if (listingType == ListingType.rent &&
                category == PropertyCategory.residential) ...[
              _infoBox(
                context,
                'Rivers State Tenancy Law advisory: Landlords may only collect '
                'rent in advance for a maximum of 1 year at a time. Ensure '
                'your payment terms comply with the Recovery of Premises Law '
                'Cap R4 LFN 2004.',
                color: VeriRentColors.warning500,
              ),
              const SizedBox(height: 10),
            ],

            _FieldLabel('Asking price (₦)', required: true),
            TextFormField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => onChange(),
              style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              decoration: const InputDecoration(
                hintText: '1800000',
                prefixIcon: Icon(Icons.attach_money_rounded, size: 18),
                prefixText: '₦ ',
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Price is required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DropField(
                    label: 'Price unit',
                    value: priceUnit,
                    items: _units,
                    onChanged: onPriceUnit,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DropField(
                    label: 'Payment terms',
                    value: paymentTerms,
                    items: const [
                      'Lump sum',
                      '2 installments',
                      '6-month plan',
                      '12-month plan',
                      'Negotiable',
                    ],
                    onChanged: onPaymentTerms,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FieldLabel('Total floor area (m²)'),
            TextFormField(
              controller: areaSqmCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              decoration: const InputDecoration(
                hintText: '120',
                prefixIcon: Icon(Icons.square_foot_rounded, size: 18),
                suffixText: 'm²',
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  STEP 4 — SPECIFIC DETAILS  (delegates to sub-widgets by category)
// =============================================================================

class _StepSpecific extends StatelessWidget {
  const _StepSpecific({
    super.key,
    required this.category,
    required this.listingType,
    // residential
    required this.bedrooms,
    required this.bathrooms,
    required this.toilets,
    required this.furnishing,
    required this.condition,
    required this.waterSupply,
    required this.powerSupply,
    required this.hasAC,
    required this.hasParking,
    required this.hasGarden,
    required this.isFenced,
    required this.hasGuard,
    required this.hasCCTV,
    required this.onBeds,
    required this.onBaths,
    required this.onToilets,
    required this.onFurnishing,
    required this.onCondition,
    required this.onWater,
    required this.onPower,
    required this.onAC,
    required this.onParking,
    required this.onGarden,
    required this.onFenced,
    required this.onGuard,
    required this.onCCTV,
    // land
    required this.dimsCtrl,
    required this.surveyNumCtrl,
    required this.landUse,
    required this.documentType,
    required this.hasFrontage,
    required this.hasTarredRoad,
    required this.hasDrainage,
    required this.hasElecPoles,
    required this.onLandUse,
    required this.onDocType,
    required this.onFrontage,
    required this.onTarred,
    required this.onDrainage,
    required this.onElecPoles,
    // commercial
    required this.officeType,
    required this.layoutType,
    required this.floorLevel,
    required this.parkingSpaces,
    required this.hasHVAC,
    required this.hasElevator,
    required this.hasConferenceRoom,
    required this.hasInternet,
    required this.has24HrPower,
    required this.hasFireSafety,
    required this.minLeaseMonths,
    required this.onOfficeType,
    required this.onLayoutType,
    required this.onFloorLevel,
    required this.onParkingSpaces,
    required this.onHVAC,
    required this.onElevator,
    required this.onConference,
    required this.onInternet,
    required this.on24Pwr,
    required this.onFire,
    required this.onMinLease,
    // estate
    required this.unitCount,
    required this.unitBeds,
    required this.unitBaths,
    required this.estatePlan,
    required this.hasEstateCof0,
    required this.onUnitCount,
    required this.onUnitBeds,
    required this.onUnitBaths,
    required this.onEstatePlan,
    required this.onEstateCof0,
    // shortlet
    required this.sltBeds,
    required this.sltBaths,
    required this.checkInCtrl,
    required this.checkOutCtrl,
    required this.sltWifi,
    required this.sltHousekeeping,
    required this.sltPets,
    required this.sltSmoking,
    required this.cancellationPolicy,
    required this.onSltBeds,
    required this.onSltBaths,
    required this.onSltWifi,
    required this.onSltHousekeeping,
    required this.onSltPets,
    required this.onSltSmoking,
    required this.onCancellation,
  });

  final PropertyCategory category;
  final ListingType listingType;
  final int bedrooms, bathrooms, toilets;
  final String? furnishing, condition, waterSupply, powerSupply;
  final bool hasAC, hasParking, hasGarden, isFenced, hasGuard, hasCCTV;
  final ValueChanged<int> onBeds, onBaths, onToilets;
  final ValueChanged<String?> onFurnishing, onCondition, onWater, onPower;
  final ValueChanged<bool> onAC, onParking, onGarden, onFenced, onGuard, onCCTV;
  final TextEditingController dimsCtrl, surveyNumCtrl;
  final String? landUse, documentType;
  final bool hasFrontage, hasTarredRoad, hasDrainage, hasElecPoles;
  final ValueChanged<String?> onLandUse, onDocType;
  final ValueChanged<bool> onFrontage, onTarred, onDrainage, onElecPoles;
  final String? officeType, layoutType;
  final int floorLevel, parkingSpaces;
  final bool hasHVAC,
      hasElevator,
      hasConferenceRoom,
      hasInternet,
      has24HrPower,
      hasFireSafety;
  final int minLeaseMonths;
  final ValueChanged<String?> onOfficeType, onLayoutType;
  final ValueChanged<int> onFloorLevel, onParkingSpaces, onMinLease;
  final ValueChanged<bool> onHVAC,
      onElevator,
      onConference,
      onInternet,
      on24Pwr,
      onFire;
  final int unitCount, unitBeds, unitBaths;
  final String? estatePlan;
  final bool hasEstateCof0;
  final ValueChanged<int> onUnitCount, onUnitBeds, onUnitBaths;
  final ValueChanged<String?> onEstatePlan;
  final ValueChanged<bool> onEstateCof0;
  final int sltBeds, sltBaths;
  final TextEditingController checkInCtrl, checkOutCtrl;
  final bool sltWifi, sltHousekeeping, sltPets, sltSmoking;
  final String? cancellationPolicy;
  final ValueChanged<int> onSltBeds, onSltBaths;
  final ValueChanged<bool> onSltWifi,
      onSltHousekeeping,
      onSltPets,
      onSltSmoking;
  final ValueChanged<String?> onCancellation;

  String get _title {
    switch (category) {
      case PropertyCategory.land:
        return 'Land details';
      case PropertyCategory.commercial:
        return 'Space details';
      case PropertyCategory.estate:
        return 'Estate details';
      case PropertyCategory.shortLet:
        return 'Short-let details';
      default:
        return 'Room & property details';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 20),
          _body(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    switch (category) {
      case PropertyCategory.land:
        return _LandFields(
          dimsCtrl: dimsCtrl,
          surveyNumCtrl: surveyNumCtrl,
          landUse: landUse,
          documentType: documentType,
          hasFrontage: hasFrontage,
          hasTarredRoad: hasTarredRoad,
          hasDrainage: hasDrainage,
          hasElecPoles: hasElecPoles,
          onLandUse: onLandUse,
          onDocType: onDocType,
          onFrontage: onFrontage,
          onTarred: onTarred,
          onDrainage: onDrainage,
          onElecPoles: onElecPoles,
        );
      case PropertyCategory.commercial:
        return _CommercialFields(
          officeType: officeType,
          layoutType: layoutType,
          floorLevel: floorLevel,
          parkingSpaces: parkingSpaces,
          hasHVAC: hasHVAC,
          hasElevator: hasElevator,
          hasConferenceRoom: hasConferenceRoom,
          hasInternet: hasInternet,
          has24HrPower: has24HrPower,
          hasFireSafety: hasFireSafety,
          minLeaseMonths: minLeaseMonths,
          onOfficeType: onOfficeType,
          onLayoutType: onLayoutType,
          onFloorLevel: onFloorLevel,
          onParkingSpaces: onParkingSpaces,
          onHVAC: onHVAC,
          onElevator: onElevator,
          onConference: onConference,
          onInternet: onInternet,
          on24Pwr: on24Pwr,
          onFire: onFire,
          onMinLease: onMinLease,
        );
      case PropertyCategory.estate:
        return _EstateFields(
          unitCount: unitCount,
          unitBeds: unitBeds,
          unitBaths: unitBaths,
          estatePlan: estatePlan,
          hasEstateCof0: hasEstateCof0,
          onUnitCount: onUnitCount,
          onUnitBeds: onUnitBeds,
          onUnitBaths: onUnitBaths,
          onEstatePlan: onEstatePlan,
          onEstateCof0: onEstateCof0,
        );
      case PropertyCategory.shortLet:
        return _ShortletFields(
          sltBeds: sltBeds,
          sltBaths: sltBaths,
          checkInCtrl: checkInCtrl,
          checkOutCtrl: checkOutCtrl,
          sltWifi: sltWifi,
          sltHousekeeping: sltHousekeeping,
          sltPets: sltPets,
          sltSmoking: sltSmoking,
          cancellationPolicy: cancellationPolicy,
          onSltBeds: onSltBeds,
          onSltBaths: onSltBaths,
          onSltWifi: onSltWifi,
          onSltHousekeeping: onSltHousekeeping,
          onSltPets: onSltPets,
          onSltSmoking: onSltSmoking,
          onCancellation: onCancellation,
        );
      default:
        return _ResidentialFields(
          bedrooms: bedrooms,
          bathrooms: bathrooms,
          toilets: toilets,
          furnishing: furnishing,
          condition: condition,
          waterSupply: waterSupply,
          powerSupply: powerSupply,
          hasAC: hasAC,
          hasParking: hasParking,
          hasGarden: hasGarden,
          isFenced: isFenced,
          hasGuard: hasGuard,
          hasCCTV: hasCCTV,
          onBeds: onBeds,
          onBaths: onBaths,
          onToilets: onToilets,
          onFurnishing: onFurnishing,
          onCondition: onCondition,
          onWater: onWater,
          onPower: onPower,
          onAC: onAC,
          onParking: onParking,
          onGarden: onGarden,
          onFenced: onFenced,
          onGuard: onGuard,
          onCCTV: onCCTV,
        );
    }
  }
}

// ── Residential ───────────────────────────────────────────────────────────────
class _ResidentialFields extends StatelessWidget {
  const _ResidentialFields({
    required this.bedrooms,
    required this.bathrooms,
    required this.toilets,
    required this.furnishing,
    required this.condition,
    required this.waterSupply,
    required this.powerSupply,
    required this.hasAC,
    required this.hasParking,
    required this.hasGarden,
    required this.isFenced,
    required this.hasGuard,
    required this.hasCCTV,
    required this.onBeds,
    required this.onBaths,
    required this.onToilets,
    required this.onFurnishing,
    required this.onCondition,
    required this.onWater,
    required this.onPower,
    required this.onAC,
    required this.onParking,
    required this.onGarden,
    required this.onFenced,
    required this.onGuard,
    required this.onCCTV,
  });
  final int bedrooms, bathrooms, toilets;
  final String? furnishing, condition, waterSupply, powerSupply;
  final bool hasAC, hasParking, hasGarden, isFenced, hasGuard, hasCCTV;
  final ValueChanged<int> onBeds, onBaths, onToilets;
  final ValueChanged<String?> onFurnishing, onCondition, onWater, onPower;
  final ValueChanged<bool> onAC, onParking, onGarden, onFenced, onGuard, onCCTV;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _Sec('Rooms'),
      _card(
        context,
        Column(
          children: [
            _Counter(
              label: 'Bedrooms',
              value: bedrooms,
              onChanged: onBeds,
              min: 1,
            ),
            _div(context),
            _Counter(
              label: 'Bathrooms',
              value: bathrooms,
              onChanged: onBaths,
              min: 1,
            ),
            _div(context),
            _Counter(
              label: 'Toilets',
              value: toilets,
              onChanged: onToilets,
              min: 1,
            ),
          ],
        ),
      ),
      const _Sec('Condition & Furnishing'),
      Row(
        children: [
          Expanded(
            child: _DropField(
              label: 'Condition',
              value: condition,
              items: const ['New', 'Good', 'Renovated', 'Needs Work'],
              onChanged: onCondition,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DropField(
              label: 'Furnishing',
              value: furnishing,
              items: const ['Unfurnished', 'Semi-Furnished', 'Fully Furnished'],
              onChanged: onFurnishing,
            ),
          ),
        ],
      ),
      const _Sec('Utilities'),
      Row(
        children: [
          Expanded(
            child: _DropField(
              label: 'Water Supply',
              value: waterSupply,
              items: const [
                'Borehole',
                'Public Supply',
                'Borehole + Tank',
                'River',
              ],
              onChanged: onWater,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DropField(
              label: 'Power Supply',
              value: powerSupply,
              items: const [
                'Prepaid NEPA',
                'NEPA + Generator',
                '24hr Power',
                'Solar',
              ],
              onChanged: onPower,
            ),
          ),
        ],
      ),
      const _Sec('Security & Extras'),
      _card(
        context,
        Column(
          children: [
            _Toggle(label: 'Air Conditioning', value: hasAC, onChanged: onAC),
            _div(context),
            _Toggle(
              label: 'Parking Space',
              value: hasParking,
              onChanged: onParking,
            ),
            _div(context),
            _Toggle(
              label: 'Garden / Lawn',
              value: hasGarden,
              onChanged: onGarden,
            ),
            _div(context),
            _Toggle(
              label: 'Perimeter Fence',
              value: isFenced,
              onChanged: onFenced,
            ),
            _div(context),
            _Toggle(
              label: 'Security Guard',
              value: hasGuard,
              onChanged: onGuard,
            ),
            _div(context),
            _Toggle(
              label: 'CCTV Surveillance',
              value: hasCCTV,
              onChanged: onCCTV,
            ),
          ],
        ),
      ),
    ],
  );
}

// ── Land ──────────────────────────────────────────────────────────────────────
class _LandFields extends StatelessWidget {
  const _LandFields({
    required this.dimsCtrl,
    required this.surveyNumCtrl,
    required this.landUse,
    required this.documentType,
    required this.hasFrontage,
    required this.hasTarredRoad,
    required this.hasDrainage,
    required this.hasElecPoles,
    required this.onLandUse,
    required this.onDocType,
    required this.onFrontage,
    required this.onTarred,
    required this.onDrainage,
    required this.onElecPoles,
  });
  final TextEditingController dimsCtrl, surveyNumCtrl;
  final String? landUse, documentType;
  final bool hasFrontage, hasTarredRoad, hasDrainage, hasElecPoles;
  final ValueChanged<String?> onLandUse, onDocType;
  final ValueChanged<bool> onFrontage, onTarred, onDrainage, onElecPoles;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title document compliance note
        _infoBox(
          context,
          'Land and estate listings require a verifiable title document. '
          'A C of O or Governor\'s Consent is the only document that fully '
          'extinguishes government interest under Nigerian land law '
          '(Land Use Act 1978).',
        ),
        const _Sec('Land Classification'),
        Row(
          children: [
            Expanded(
              child: _DropField(
                label: 'Land Use',
                required: true,
                value: landUse,
                items: const [
                  'Residential',
                  'Commercial',
                  'Agricultural',
                  'Industrial',
                  'Mixed Use',
                ],
                onChanged: onLandUse,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DropField(
                label: 'Title Document',
                required: true,
                value: documentType,
                items: const [
                  "C of O",
                  "Deed of Assignment",
                  "Governor's Consent",
                  "Survey Plan",
                  "Family Receipt",
                  "Gazette",
                ],
                onChanged: onDocType,
              ),
            ),
          ],
        ),
        const _Sec('Plot Details'),
        _FieldLabel('Plot dimensions'),
        TextFormField(
          controller: dimsCtrl,
          style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
          decoration: const InputDecoration(
            hintText: 'e.g. 18m × 36m',
            prefixIcon: Icon(Icons.straighten_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        _FieldLabel('Survey plan number'),
        TextFormField(
          controller: surveyNumCtrl,
          style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
          decoration: const InputDecoration(
            hintText: 'e.g. SPH/OA/2023/04412',
            prefixIcon: Icon(Icons.numbers_rounded, size: 18),
          ),
        ),
        const _Sec('Infrastructure'),
        _card(
          context,
          Column(
            children: [
              _Toggle(
                label: 'Street Frontage',
                value: hasFrontage,
                onChanged: onFrontage,
              ),
              _div(context),
              _Toggle(
                label: 'Tarred Road Access',
                value: hasTarredRoad,
                onChanged: onTarred,
              ),
              _div(context),
              _Toggle(
                label: 'Drainage System',
                value: hasDrainage,
                onChanged: onDrainage,
              ),
              _div(context),
              _Toggle(
                label: 'Electricity Poles Nearby',
                value: hasElecPoles,
                onChanged: onElecPoles,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Commercial ────────────────────────────────────────────────────────────────
class _CommercialFields extends StatelessWidget {
  const _CommercialFields({
    required this.officeType,
    required this.layoutType,
    required this.floorLevel,
    required this.parkingSpaces,
    required this.hasHVAC,
    required this.hasElevator,
    required this.hasConferenceRoom,
    required this.hasInternet,
    required this.has24HrPower,
    required this.hasFireSafety,
    required this.minLeaseMonths,
    required this.onOfficeType,
    required this.onLayoutType,
    required this.onFloorLevel,
    required this.onParkingSpaces,
    required this.onHVAC,
    required this.onElevator,
    required this.onConference,
    required this.onInternet,
    required this.on24Pwr,
    required this.onFire,
    required this.onMinLease,
  });
  final String? officeType, layoutType;
  final int floorLevel, parkingSpaces, minLeaseMonths;
  final bool hasHVAC,
      hasElevator,
      hasConferenceRoom,
      hasInternet,
      has24HrPower,
      hasFireSafety;
  final ValueChanged<String?> onOfficeType, onLayoutType;
  final ValueChanged<int> onFloorLevel, onParkingSpaces, onMinLease;
  final ValueChanged<bool> onHVAC,
      onElevator,
      onConference,
      onInternet,
      on24Pwr,
      onFire;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _Sec('Space Type'),
      Row(
        children: [
          Expanded(
            child: _DropField(
              label: 'Space Type',
              value: officeType,
              items: const [
                'Office',
                'Shop',
                'Warehouse',
                'Plaza',
                'Showroom',
                'Co-working',
              ],
              onChanged: onOfficeType,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DropField(
              label: 'Layout',
              value: layoutType,
              items: const [
                'Open Plan',
                'Partitioned',
                'Private Offices',
                'Hybrid',
              ],
              onChanged: onLayoutType,
            ),
          ),
        ],
      ),
      const _Sec('Configuration'),
      _card(
        context,
        Column(
          children: [
            _Counter(
              label: 'Floor Level',
              value: floorLevel,
              onChanged: onFloorLevel,
            ),
            _div(context),
            _Counter(
              label: 'Parking Spaces',
              value: parkingSpaces,
              onChanged: onParkingSpaces,
            ),
            _div(context),
            _Counter(
              label: 'Min Lease (months)',
              value: minLeaseMonths,
              onChanged: onMinLease,
              min: 1,
              max: 60,
            ),
          ],
        ),
      ),
      const _Sec('Facilities'),
      _card(
        context,
        Column(
          children: [
            _Toggle(
              label: 'HVAC / Air Conditioning',
              value: hasHVAC,
              onChanged: onHVAC,
            ),
            _div(context),
            _Toggle(
              label: 'Elevator Access',
              value: hasElevator,
              onChanged: onElevator,
            ),
            _div(context),
            _Toggle(
              label: 'Conference Room',
              value: hasConferenceRoom,
              onChanged: onConference,
            ),
            _div(context),
            _Toggle(
              label: 'High-Speed Internet',
              value: hasInternet,
              onChanged: onInternet,
            ),
            _div(context),
            _Toggle(
              label: '24-Hour Power',
              value: has24HrPower,
              onChanged: on24Pwr,
            ),
            _div(context),
            _Toggle(
              label: 'Fire Safety System',
              value: hasFireSafety,
              onChanged: onFire,
            ),
          ],
        ),
      ),
    ],
  );
}

// ── Estate ────────────────────────────────────────────────────────────────────
class _EstateFields extends StatelessWidget {
  const _EstateFields({
    required this.unitCount,
    required this.unitBeds,
    required this.unitBaths,
    required this.estatePlan,
    required this.hasEstateCof0,
    required this.onUnitCount,
    required this.onUnitBeds,
    required this.onUnitBaths,
    required this.onEstatePlan,
    required this.onEstateCof0,
  });
  final int unitCount, unitBeds, unitBaths;
  final String? estatePlan;
  final bool hasEstateCof0;
  final ValueChanged<int> onUnitCount, onUnitBeds, onUnitBaths;
  final ValueChanged<String?> onEstatePlan;
  final ValueChanged<bool> onEstateCof0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _infoBox(
        context,
        'Estate listings require a valid C of O covering the entire boundary. '
        'Off-plan listings must include FMBN or state housing authority '
        'approval documents.',
        color: VeriRentColors.gold,
      ),
      const _Sec('Estate Configuration'),
      _card(
        context,
        Column(
          children: [
            _Counter(
              label: 'Total Units',
              value: unitCount,
              onChanged: onUnitCount,
              min: 2,
              max: 1000,
            ),
            _div(context),
            _Counter(
              label: 'Bedrooms per Unit',
              value: unitBeds,
              onChanged: onUnitBeds,
              min: 1,
            ),
            _div(context),
            _Counter(
              label: 'Bathrooms per Unit',
              value: unitBaths,
              onChanged: onUnitBaths,
              min: 1,
            ),
          ],
        ),
      ),
      const _Sec('Compliance & Documents'),
      _card(
        context,
        Column(
          children: [
            _Toggle(
              label: 'C of O for Full Estate Boundary',
              subtitle: 'Required for estate listings',
              value: hasEstateCof0,
              onChanged: onEstateCof0,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _DropField(
        label: 'Payment Plan',
        value: estatePlan,
        items: const [
          'Outright',
          '6-month plan',
          '12-month plan',
          '24-month plan',
          'Off-plan — flexible',
        ],
        onChanged: onEstatePlan,
      ),
    ],
  );
}

// ── Shortlet ──────────────────────────────────────────────────────────────────
class _ShortletFields extends StatelessWidget {
  const _ShortletFields({
    required this.sltBeds,
    required this.sltBaths,
    required this.checkInCtrl,
    required this.checkOutCtrl,
    required this.sltWifi,
    required this.sltHousekeeping,
    required this.sltPets,
    required this.sltSmoking,
    required this.cancellationPolicy,
    required this.onSltBeds,
    required this.onSltBaths,
    required this.onSltWifi,
    required this.onSltHousekeeping,
    required this.onSltPets,
    required this.onSltSmoking,
    required this.onCancellation,
  });
  final int sltBeds, sltBaths;
  final TextEditingController checkInCtrl, checkOutCtrl;
  final bool sltWifi, sltHousekeeping, sltPets, sltSmoking;
  final String? cancellationPolicy;
  final ValueChanged<int> onSltBeds, onSltBaths;
  final ValueChanged<bool> onSltWifi,
      onSltHousekeeping,
      onSltPets,
      onSltSmoking;
  final ValueChanged<String?> onCancellation;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Sec('Unit Size'),
        _card(
          context,
          Column(
            children: [
              _Counter(
                label: 'Bedrooms',
                value: sltBeds,
                onChanged: onSltBeds,
                min: 1,
              ),
              _div(context),
              _Counter(
                label: 'Bathrooms',
                value: sltBaths,
                onChanged: onSltBaths,
                min: 1,
              ),
            ],
          ),
        ),
        const _Sec('Check-in / Check-out'),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Check-in time'),
                  TextFormField(
                    controller: checkInCtrl,
                    style: VeriRentText.bodyMedium.copyWith(
                      color: cs.onSurface,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.login_rounded, size: 18),
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
                  _FieldLabel('Check-out time'),
                  TextFormField(
                    controller: checkOutCtrl,
                    style: VeriRentText.bodyMedium.copyWith(
                      color: cs.onSurface,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.logout_rounded, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const _Sec('House Rules'),
        _card(
          context,
          Column(
            children: [
              _Toggle(
                label: 'WiFi Included',
                value: sltWifi,
                onChanged: onSltWifi,
              ),
              _div(context),
              _Toggle(
                label: 'Housekeeping Included',
                value: sltHousekeeping,
                onChanged: onSltHousekeeping,
              ),
              _div(context),
              _Toggle(
                label: 'Pets Allowed',
                value: sltPets,
                onChanged: onSltPets,
              ),
              _div(context),
              _Toggle(
                label: 'Smoking Allowed',
                value: sltSmoking,
                onChanged: onSltSmoking,
              ),
            ],
          ),
        ),
        const _Sec('Cancellation Policy'),
        _DropField(
          label: 'Policy',
          value: cancellationPolicy,
          items: const [
            'Free cancellation (48hr)',
            'Free cancellation (24hr)',
            'Non-refundable',
            'Flexible — full refund',
          ],
          onChanged: onCancellation,
        ),
      ],
    );
  }
}

// =============================================================================
//  STEP 5 — AMENITIES
// =============================================================================

class _StepAmenities extends StatelessWidget {
  const _StepAmenities({
    super.key,
    required this.category,
    required this.selected,
    required this.onToggle,
  });
  final PropertyCategory category;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  static const _pool = {
    PropertyCategory.residential: [
      'Prepaid Meter',
      'Generator Backup',
      'Borehole Water',
      'Overhead Tank',
      'Dedicated Parking',
      'Boys Quarter',
      'Security Guard',
      '24hr Security',
      'CCTV',
      'Intercom',
      'Fence & Gate',
      'POP Ceiling',
      'Tiled Floors',
      'Swimming Pool',
      'Gym',
      "Children's Play Area",
      'Rooftop Access',
      'Solar Panels',
      'Modern Kitchen',
      'Laundry Room',
      'Store Room',
      'Visitor Parking',
      'Garden / Lawn',
    ],
    PropertyCategory.land: [
      'Fenced Perimeter',
      'Tarred Road Access',
      'Drainage Channel',
      'Electricity Poles',
      'Water Line',
      'Street Lighting',
      'Corner Plot',
      'Survey Beacons',
      'Cleared & Ready',
      'Access Gate',
    ],
    PropertyCategory.commercial: [
      'HVAC System',
      'Fibre Internet',
      'Reception Area',
      '24hr Power',
      'Generator',
      'CCTV',
      'Fire Safety',
      'Elevator',
      'Conference Room',
      'Boardroom',
      'Pantry / Kitchen',
      'Server Room',
      'Disabled Access',
      '24hr Security',
      'Visitor Parking',
      'Signage Rights',
      'Pest Control',
    ],
    PropertyCategory.estate: [
      'Gated Community',
      '24hr Security',
      'CCTV Surveillance',
      'Swimming Pool',
      'Gym',
      "Children's Play Area",
      'Estate Generator',
      'Borehole Water',
      'Paved Internal Roads',
      'Visitor Parking',
      'Clubhouse',
      'Tennis Court',
      'Jogging Track',
      'Estate Management Office',
      'Waste Management',
    ],
    PropertyCategory.shortLet: [
      'WiFi (100Mbps)',
      'Smart TV',
      'Netflix / Streaming',
      'AC in all rooms',
      'Fully Equipped Kitchen',
      'Generator Backup',
      '24hr Security',
      'Parking Space',
      'Housekeeping',
      'Smart Lock / Self Check-in',
      'Iron & Board',
      'Hair Dryer',
      'Washing Machine',
      'Workspace / Desk',
      'Balcony / Terrace',
      'Swimming Pool',
      'Gym Access',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final list = _pool[category] ?? _pool[PropertyCategory.residential]!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What amenities does this property have?',
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Listings with more amenities rank higher in search.',
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          if (selected.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(VeriRentRadius.full),
                border: Border.all(color: cs.primary.withOpacity(0.25)),
              ),
              child: Text(
                '${selected.length} selected',
                style: VeriRentText.labelMedium.copyWith(color: cs.primary),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list.map((a) {
              final on = selected.contains(a);
              return GestureDetector(
                onTap: () => onToggle(a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 130),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: on ? cs.primary.withOpacity(0.10) : cs.surface,
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                    border: Border.all(
                      color: on ? cs.primary : cs.outlineVariant,
                      width: on ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (on) ...[
                        Icon(Icons.check_rounded, size: 12, color: cs.primary),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        a,
                        style: VeriRentText.labelMedium.copyWith(
                          color: on ? cs.primary : cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// =============================================================================
//  STEP 6 — PHOTOS
// =============================================================================

class _StepPhotos extends StatelessWidget {
  const _StepPhotos({
    super.key,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  });
  final int count;
  final VoidCallback onAdd, onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add property photos',
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Listings with 5+ photos get 3× more enquiries. Minimum 1 required.',
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo guidelines',
                  style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: 10),
                ...[
                  'Use natural daylight where possible',
                  'Cover all rooms — exterior, interior, kitchen, bathrooms',
                  'Minimum 800×600px resolution',
                  'No watermarks, logos, or agent branding overlaid on photos',
                  'Images must represent the actual property being listed',
                ].map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.tips_and_updates_rounded,
                            size: 13,
                            color: VeriRentColors.gold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: count + 1,
            itemBuilder: (_, i) {
              if (i < count) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(VeriRentRadius.md),
                        border: Border.all(color: cs.primary.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: 28,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: VeriRentColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (i == 0)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
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
                  ],
                );
              }
              return GestureDetector(
                onTap: onAdd,
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 24,
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
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(VeriRentRadius.full),
                  child: LinearProgressIndicator(
                    value: (count / 10).clamp(0.0, 1.0),
                    backgroundColor: cs.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(
                      count >= 5 ? VeriRentColors.success500 : cs.primary,
                    ),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$count / 10',
                style: VeriRentText.labelSmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (count == 0) ...[
            const SizedBox(height: 8),
            Text(
              '* At least 1 photo required to continue.',
              style: VeriRentText.bodySmall.copyWith(color: VeriRentColors.red),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// =============================================================================
//  STEP 7 — REVIEW & LEGAL CONSENT
// =============================================================================

class _StepReview extends StatelessWidget {
  const _StepReview({
    super.key,
    required this.category,
    required this.listingType,
    required this.title,
    required this.address,
    required this.lga,
    required this.price,
    required this.priceUnit,
    required this.description,
    required this.amenities,
    required this.photoCount,
    required this.bedrooms,
    required this.bathrooms,
    required this.legalConsent,
    required this.onLegalConsent,
  });
  final PropertyCategory category;
  final ListingType listingType;
  final String title, address, lga, price, priceUnit, description;
  final List<String> amenities;
  final int photoCount, bedrooms, bathrooms;
  final bool legalConsent;
  final ValueChanged<bool> onLegalConsent;

  Color get _accent {
    switch (category) {
      case PropertyCategory.land:
        return const Color(0xFF4CAF50);
      case PropertyCategory.commercial:
        return VeriRentColors.info500;
      case PropertyCategory.estate:
        return VeriRentColors.gold;
      case PropertyCategory.shortLet:
        return const Color(0xFF7C3AED);
      default:
        return VeriRentColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review before submitting',
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Your listing will be reviewed by our compliance team within 2 hours.',
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Listing preview card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                    border: Border.all(color: _accent.withOpacity(0.2)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          size: 26,
                          color: _accent,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$photoCount photo${photoCount == 1 ? '' : 's'}',
                          style: VeriRentText.bodySmall.copyWith(
                            color: _accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title.isEmpty ? '(No title)' : title,
                        style: VeriRentText.titleMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                        border: Border.all(color: _accent.withOpacity(0.35)),
                      ),
                      child: Text(
                        listingType == ListingType.rent
                            ? 'For Rent'
                            : 'For Sale',
                        style: VeriRentText.labelSmall.copyWith(
                          color: _accent,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$address, $lga, Rivers State',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '₦ $price',
                  style: VeriRentText.titleMedium.copyWith(
                    color: _accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  priceUnit,
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          _ReviewTable('Property Info', [
            ('Category', category.name),
            ('Address', address.isEmpty ? '—' : address),
            ('LGA', lga),
            if (category == PropertyCategory.residential ||
                category == PropertyCategory.shortLet) ...[
              ('Bedrooms', '$bedrooms'),
              ('Bathrooms', '$bathrooms'),
            ],
          ]),
          const SizedBox(height: 10),
          _ReviewTable(
            'Amenities (${amenities.length})',
            amenities.isEmpty
                ? [('None selected', '')]
                : amenities.map((a) => (a, '✓')).toList(),
          ),

          const SizedBox(height: 20),

          // Legal consent block
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(
                color: legalConsent
                    ? VeriRentColors.success500.withOpacity(0.4)
                    : cs.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.gavel_rounded,
                      size: 16,
                      color: VeriRentColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Legal Declaration',
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'By submitting this listing I confirm that:\n'
                  '• All information provided is accurate and not misleading.\n'
                  '• I hold or represent the holder of a valid ESVARBON or NIESV '
                  'licence, as required under Cap E13 LFN 2004.\n'
                  '• This listing complies with the Recovery of Premises Law of '
                  'Rivers State and all applicable Nigerian land-use regulations.\n'
                  '• The property is not subject to any undisclosed encumbrances, '
                  'litigation, or government acquisition order.',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.7,
                  ),
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: legalConsent,
                      onChanged: (v) => onLegalConsent(v ?? false),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onLegalConsent(!legalConsent),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'I have read, understood, and agree to the above declaration.',
                            style: VeriRentText.labelMedium.copyWith(
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ReviewTable extends StatelessWidget {
  const _ReviewTable(this.title, this.rows);
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
              ),
            ),
          ),
          Divider(height: 1, color: cs.outlineVariant),
          ...rows.map(
            (r) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          r.$1,
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        r.$2,
                        style: VeriRentText.labelMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (r != rows.last)
                  Divider(height: 1, color: cs.outlineVariant, indent: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  SUCCESS SCREEN
// =============================================================================

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 650),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: VeriRentColors.success500.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: VeriRentColors.success500.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 48,
                color: VeriRentColors.success500,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Listing Submitted!',
            style: VeriRentText.headlineMedium.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Your listing is under compliance review and will go live within '
            '2 hours. You\'ll receive a push notification once approved.',
            style: VeriRentText.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.65,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: onDone,
            icon: const Icon(Icons.home_rounded, size: 18),
            label: const Text('Back to Home'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.list_alt_rounded, size: 18),
            label: const Text('View My Listings'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
