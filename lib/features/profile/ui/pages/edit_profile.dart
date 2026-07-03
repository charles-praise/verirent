// =============================================================================
//  1. EDIT PROFILE PAGE
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../widget/sub_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController(text: 'Charles');
  final _lastNameCtrl = TextEditingController(text: 'Praise');
  final _emailCtrl = TextEditingController(text: 'charles@nixele.ng');
  final _phoneCtrl = TextEditingController(text: '+234 803 456 7890');
  final _bioCtrl = TextEditingController(
    text:
        'Flutter & FastAPI developer based in Port Harcourt, Nigeria. '
        'PropTech enthusiast exploring the Rivers State rental market.',
  );
  final _linkedinCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  String? _gender;
  String? _occupation;
  bool _saving = false;
  bool _profilePublic = true;
  bool _showPhone = false;
  bool _showEmail = true;

  @override
  void dispose() {
    for (final c in [
      _firstNameCtrl,
      _lastNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _bioCtrl,
      _linkedinCtrl,
      _websiteCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceVariant,
      appBar: SubBar(
        title: 'Edit Profile',
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              'Save',
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
              // ── Avatar ─────────────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            VeriRentColors.primary400,
                            VeriRentColors.primary700,
                          ],
                        ),
                        border: Border.all(
                          color: VeriRentColors.gold,
                          width: 2.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'CP',
                          style: VeriRentText.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.surface, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Change Photo'),
                ),
              ),

              // ── Personal Info ───────────────────────────────────────────
              sectionLabel(context, 'Personal Information'),
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
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fieldLabel(context, 'First Name', required: true),
                              TextFormField(
                                controller: _firstNameCtrl,
                                style: VeriRentText.bodyMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'First name',
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    size: 18,
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fieldLabel(context, 'Last Name', required: true),
                              TextFormField(
                                controller: _lastNameCtrl,
                                style: VeriRentText.bodyMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Last name',
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    fieldLabel(context, 'Email Address', required: true),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        prefixIcon: Icon(Icons.email_outlined, size: 18),
                      ),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Valid email required'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    fieldLabel(context, 'Phone Number'),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: '+234 800 000 0000',
                        prefixIcon: Icon(Icons.phone_outlined, size: 18),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fieldLabel(context, 'Gender'),
                              DropdownButtonFormField<String>(
                                value: _gender,
                                hint: Text(
                                  'Select',
                                  style: VeriRentText.bodySmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                                items: ['Male', 'Female', 'Prefer not to say']
                                    .map(
                                      (g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() => _gender = v),
                                style: VeriRentText.bodyMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.md,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.md,
                                    ),
                                    borderSide: BorderSide(color: cs.outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fieldLabel(context, 'Occupation'),
                              DropdownButtonFormField<String>(
                                value: _occupation,
                                hint: Text(
                                  'Select',
                                  style: VeriRentText.bodySmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                                items:
                                    [
                                          'Developer',
                                          'Engineer',
                                          'Doctor',
                                          'Teacher',
                                          'Lawyer',
                                          'Business Owner',
                                          'Student',
                                          'Other',
                                        ]
                                        .map(
                                          (o) => DropdownMenuItem(
                                            value: o,
                                            child: Text(o),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (v) =>
                                    setState(() => _occupation = v),
                                style: VeriRentText.bodyMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.md,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.md,
                                    ),
                                    borderSide: BorderSide(color: cs.outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Bio ────────────────────────────────────────────────────
              sectionLabel(context, 'Bio'),
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
                    fieldLabel(context, 'About You'),
                    TextFormField(
                      controller: _bioCtrl,
                      maxLines: 4,
                      maxLength: 300,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Tell landlords and agents a bit about yourself…',
                        alignLabelWithHint: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 56),
                          child: Icon(Icons.notes_rounded, size: 18),
                        ),
                        counterStyle: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Social / Links ─────────────────────────────────────────
              sectionLabel(context, 'Links (Optional)'),
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
                    fieldLabel(context, 'LinkedIn Profile'),
                    TextFormField(
                      controller: _linkedinCtrl,
                      keyboardType: TextInputType.url,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'https://linkedin.com/in/yourname',
                        prefixIcon: Icon(Icons.link_rounded, size: 18),
                      ),
                    ),
                    const SizedBox(height: 14),
                    fieldLabel(context, 'Website / Portfolio'),
                    TextFormField(
                      controller: _websiteCtrl,
                      keyboardType: TextInputType.url,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'https://yoursite.com',
                        prefixIcon: Icon(Icons.language_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Privacy ────────────────────────────────────────────────
              sectionLabel(context, 'Privacy'),
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  children: [
                    _PrivacyToggle(
                      label: 'Public Profile',
                      subtitle: 'Agents can see your profile when you enquire',
                      value: _profilePublic,
                      onChanged: (v) => setState(() => _profilePublic = v),
                    ),
                    Divider(height: 1, color: cs.outlineVariant, indent: 16),
                    _PrivacyToggle(
                      label: 'Show Phone Number',
                      subtitle: 'Visible to verified agents only',
                      value: _showPhone,
                      onChanged: (v) => setState(() => _showPhone = v),
                    ),
                    Divider(height: 1, color: cs.outlineVariant, indent: 16),
                    _PrivacyToggle(
                      label: 'Show Email Address',
                      subtitle: 'Visible to verified agents only',
                      value: _showEmail,
                      onChanged: (v) => setState(() => _showEmail = v),
                    ),
                  ],
                ),
              ),

              // ── Danger zone ────────────────────────────────────────────
              sectionLabel(context, 'Account'),
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: ListTile(
                  onTap: () => _showDeleteConfirm(context),
                  leading: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: VeriRentColors.red.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: VeriRentColors.red,
                    ),
                  ),
                  title: Text(
                    'Delete Account',
                    style: VeriRentText.bodyMedium.copyWith(
                      color: VeriRentColors.red,
                    ),
                  ),
                  subtitle: Text(
                    'Permanently remove your account and data',
                    style: VeriRentText.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: VeriRentColors.red,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This will permanently delete your VeriRent NG account, '
          'all your listings, saved properties, and personal data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Delete', style: TextStyle(color: VeriRentColors.red)),
          ),
        ],
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
