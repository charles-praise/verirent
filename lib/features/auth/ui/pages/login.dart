// =============================================================================
//  VeriRent NG — Login Page
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/agents_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
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
              // ── Hero Header ─────────────────────────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(24, topPad + 20, 24, 36),
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
                    // Back
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
                    const SizedBox(height: 28),

                    // Brand mark
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: VeriRentColors.secondary500,
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.md,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: VeriRentColors.secondary500.withOpacity(
                                  0.35,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: VeriRentColors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VeriRent NG',
                              style: VeriRentText.headlineMedium.copyWith(
                                color: VeriRentColors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Verified Rentals · Trusted Agents',
                              style: VeriRentText.bodySmall.copyWith(
                                color: VeriRentColors.white.withOpacity(0.65),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Welcome back',
                      style: VeriRentText.displaySmall.copyWith(
                        color: VeriRentColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to explore verified listings',
                      style: VeriRentText.bodyMedium.copyWith(
                        color: VeriRentColors.white.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Form Card ────────────────────────────────────────────
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
                      _FieldLabel('Email Address'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _fieldDecoration(
                          context,
                          hint: 'you@example.com',
                          icon: Icons.email_outlined,
                        ),
                        validator: (v) => (v != null && v.contains('@'))
                            ? null
                            : 'Enter a valid email',
                      ),
                      const SizedBox(height: 16),

                      _FieldLabel('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        decoration: _fieldDecoration(
                          context,
                          hint: '••••••••',
                          icon: Icons.lock_outlined,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        validator: (v) => (v != null && v.length >= 6)
                            ? null
                            : 'Min. 6 characters',
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: VeriRentText.labelMedium.copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),

                      // ── Primary CTA ─────────────────────────────
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
                                  'Sign In',
                                  style: VeriRentText.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Divider ─────────────────────────────────
                      Row(
                        children: [
                          Expanded(child: Divider(color: cs.outlineVariant)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'or',
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: cs.outlineVariant)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Social buttons ───────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _SocialBtn(
                              label: 'Google',
                              icon: Icons.g_mobiledata_rounded,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SocialBtn(
                              label: 'Apple',
                              icon: Icons.apple_rounded,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Sign up link ─────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?  ",
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Sign Up',
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

  InputDecoration _fieldDecoration(
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

class _SocialBtn extends StatelessWidget {
  const _SocialBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(VeriRentRadius.md),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: cs.onSurface),
            const SizedBox(width: 8),
            Text(
              label,
              style: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
