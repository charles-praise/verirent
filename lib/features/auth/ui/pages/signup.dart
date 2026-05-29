// =============================================================================
//  VeriRent NG — Signup Page
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/agents_theme.dart';

enum _UserRole { tenant, agent }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  _UserRole _role = _UserRole.tenant;
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Privacy Policy'),
        ),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(24, topPad + 20, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      VeriRentColors.primary700,
                      VeriRentColors.primary500,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: VeriRentColors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                          border: Border.all(
                            color: VeriRentColors.white.withOpacity(0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: VeriRentColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Create Account',
                      style: VeriRentText.displaySmall.copyWith(
                        color: VeriRentColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Join Nigeria's first certified rental\nmarketplace",
                      style: VeriRentText.bodyMedium.copyWith(
                        color: VeriRentColors.white.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Form ─────────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(16, -20, 16, 0),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Role Selector ──────────────────────────────
                      _FieldLabel('I am a'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _RoleCard(
                              icon: Icons.person_rounded,
                              label: 'Tenant',
                              sublabel: 'Looking for a home',
                              selected: _role == _UserRole.tenant,
                              onTap: () =>
                                  setState(() => _role = _UserRole.tenant),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _RoleCard(
                              icon: Icons.business_rounded,
                              label: 'Agent',
                              sublabel: 'Listing properties',
                              selected: _role == _UserRole.agent,
                              onTap: () =>
                                  setState(() => _role = _UserRole.agent),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Full Name ──────────────────────────────────
                      _FieldLabel('Full Name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: _dec(
                          context,
                          hint: 'Charles Pepple',
                          icon: Icons.person_outlined,
                        ),
                        validator: (v) => (v != null && v.trim().length > 2)
                            ? null
                            : 'Enter your full name',
                      ),
                      const SizedBox(height: 14),

                      // ── Email ──────────────────────────────────────
                      _FieldLabel('Email Address'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _dec(
                          context,
                          hint: 'you@example.com',
                          icon: Icons.email_outlined,
                        ),
                        validator: (v) => (v != null && v.contains('@'))
                            ? null
                            : 'Enter a valid email',
                      ),
                      const SizedBox(height: 14),

                      // ── Phone ──────────────────────────────────────
                      _FieldLabel('Phone Number'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _dec(
                          context,
                          hint: '+234 800 000 0000',
                          icon: Icons.phone_outlined,
                        ),
                        validator: (v) => (v != null && v.length >= 10)
                            ? null
                            : 'Enter a valid phone number',
                      ),
                      const SizedBox(height: 14),

                      // ── Password ───────────────────────────────────
                      _FieldLabel('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        decoration: _dec(
                          context,
                          hint: 'Min. 8 characters',
                          icon: Icons.lock_outlined,
                          suffix: _VisibilityBtn(
                            obscure: _obscure,
                            onTap: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v != null && v.length >= 8)
                            ? null
                            : 'Minimum 8 characters',
                      ),
                      const SizedBox(height: 14),

                      // ── Confirm Password ───────────────────────────
                      _FieldLabel('Confirm Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscureConfirm,
                        decoration: _dec(
                          context,
                          hint: '••••••••',
                          icon: Icons.lock_outlined,
                          suffix: _VisibilityBtn(
                            obscure: _obscureConfirm,
                            onTap: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                        validator: (v) => (v == _passwordCtrl.text)
                            ? null
                            : 'Passwords do not match',
                      ),
                      const SizedBox(height: 20),

                      // ── Terms ──────────────────────────────────────
                      GestureDetector(
                        onTap: () =>
                            setState(() => _acceptedTerms = !_acceptedTerms),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _acceptedTerms
                                    ? cs.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.xs,
                                ),
                                border: Border.all(
                                  color: _acceptedTerms
                                      ? cs.primary
                                      : cs.outline,
                                  width: 1.5,
                                ),
                              ),
                              child: _acceptedTerms
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: VeriRentText.bodySmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── CTA ────────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: VeriRentText.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?  ',
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Text(
                              'Sign In',
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: botPad + 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(
    BuildContext context, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 18, color: cs.onSurfaceVariant),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: VeriRentText.labelMedium.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  );
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? VeriRentColors.primaryDim : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
          border: Border.all(
            color: selected ? VeriRentColors.primary : cs.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? VeriRentColors.primary
                      : cs.onSurfaceVariant,
                ),
                const Spacer(),
                if (selected)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: VeriRentColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: VeriRentText.titleSmall.copyWith(
                color: selected ? VeriRentColors.primary : cs.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisibilityBtn extends StatelessWidget {
  const _VisibilityBtn({required this.obscure, required this.onTap});
  final bool obscure;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
