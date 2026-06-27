// =============================================================================
//  2.  CHANGE PASSWORD PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;

  // Strength checks
  bool get _hasLength => _newCtrl.text.length >= 8;
  bool get _hasUpper => _newCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _newCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _newCtrl.text.contains(RegExp(r'[!@#\$&*~]'));
  int get _strength =>
      [_hasLength, _hasUpper, _hasNumber, _hasSpecial].where((b) => b).length;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully.')),
      );
      Navigator.maybePop(context);
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
        backgroundColor: cs.surfaceContainerHighest,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SubPageAppBar(title: 'Change Password')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current password
                      SectionLabel('Current Password'),
                      _PasswordField(
                        controller: _currentCtrl,
                        label: 'Current password',
                        show: _showCurrent,
                        onToggle: () =>
                            setState(() => _showCurrent = !_showCurrent),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Enter your current password'
                            : null,
                      ),

                      const SizedBox(height: 20),
                      SectionLabel('New Password'),

                      // New password
                      _PasswordField(
                        controller: _newCtrl,
                        label: 'New password',
                        show: _showNew,
                        onToggle: () => setState(() => _showNew = !_showNew),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter a new password';
                          }
                          if (v.length < 8) {
                            return 'At least 8 characters required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Strength meter
                      _StrengthMeter(strength: _strength),

                      const SizedBox(height: 8),
                      _StrengthChecks(
                        hasLength: _hasLength,
                        hasUpper: _hasUpper,
                        hasNumber: _hasNumber,
                        hasSpecial: _hasSpecial,
                      ),

                      const SizedBox(height: 16),

                      // Confirm password
                      _PasswordField(
                        controller: _confirmCtrl,
                        label: 'Confirm new password',
                        show: _showConfirm,
                        onToggle: () =>
                            setState(() => _showConfirm = !_showConfirm),
                        validator: (v) {
                          if (v != _newCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Update Password'),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: VeriRentText.labelMedium.copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.show,
    required this.onToggle,
    this.onChanged,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final bool show;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      onChanged: onChanged,
      validator: validator,
      style: VeriRentText.bodyMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outlined, size: 18),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.strength});
  final int strength;

  Color get _color {
    if (strength <= 1) return VeriRentColors.red;
    if (strength == 2) return VeriRentColors.gold;
    if (strength == 3) return VeriRentColors.warning500;
    return VeriRentColors.success500;
  }

  String get _label {
    if (strength <= 1) return 'Weak';
    if (strength == 2) return 'Fair';
    if (strength == 3) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(VeriRentRadius.full),
                child: LinearProgressIndicator(
                  value: strength / 4,
                  backgroundColor: cs.outlineVariant,
                  valueColor: AlwaysStoppedAnimation(_color),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _label,
              style: VeriRentText.labelSmall.copyWith(color: _color),
            ),
          ],
        ),
      ],
    );
  }
}

class _StrengthChecks extends StatelessWidget {
  const _StrengthChecks({
    required this.hasLength,
    required this.hasUpper,
    required this.hasNumber,
    required this.hasSpecial,
  });
  final bool hasLength, hasUpper, hasNumber, hasSpecial;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _Check(label: '8+ chars', met: hasLength),
        _Check(label: 'Uppercase', met: hasUpper),
        _Check(label: 'Number', met: hasNumber),
        _Check(label: 'Symbol', met: hasSpecial),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.label, required this.met});
  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final color = met
        ? VeriRentColors.success500
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: VeriRentText.bodySmall.copyWith(color: color)),
      ],
    );
  }
}
