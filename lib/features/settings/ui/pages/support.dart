// =============================================================================
//  8.  CONTACT SUPPORT PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _category = 'General';
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
      _sent = true;
    });
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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SubPageAppBar(title: 'Contact Support')),
            if (_sent)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: VeriRentColors.success500.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: VeriRentColors.success500,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Message Sent!',
                        style: VeriRentText.headlineMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our team will respond within 24 hours.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Back to Settings'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Contact channels
              SliverToBoxAdapter(child: SectionLabel('Reach Us')),
              SliverToBoxAdapter(
                child: Group(
                  children: [
                    _ContactChannelTile(
                      icon: Icons.email_outlined,
                      iconColor: cs.primary,
                      title: 'Email',
                      subtitle: 'support@verirent.ng',
                      onTap: () {},
                    ),
                    _ContactChannelTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: VeriRentColors.tierVerified,
                      title: 'Live Chat',
                      subtitle: 'Mon – Fri, 8 AM – 6 PM WAT',
                      onTap: () {},
                    ),
                    _ContactChannelTile(
                      icon: Icons.phone_outlined,
                      iconColor: VeriRentColors.success500,
                      title: 'Phone',
                      subtitle: '+234 (0) 800 VERIRENT',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Form
              SliverToBoxAdapter(child: SectionLabel('Send a Message')),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Category chips
                        SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                [
                                      'General',
                                      'Verification',
                                      'Listing',
                                      'Billing',
                                      'Technical',
                                    ]
                                    .map(
                                      (c) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: ChoiceChip(
                                          label: Text(c),
                                          selected: _category == c,
                                          onSelected: (_) =>
                                              setState(() => _category = c),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _subjectCtrl,
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Subject',
                            prefixIcon: Icon(Icons.title_rounded, size: 18),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter a subject'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _messageCtrl,
                          maxLines: 5,
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            alignLabelWithHint: true,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(Icons.message_outlined, size: 18),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 10)
                              ? 'Message too short'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Attach
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file_rounded, size: 16),
                          label: const Text('Attach Screenshot'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                          ),
                        ),
                        const SizedBox(height: 12),

                        FilledButton(
                          onPressed: _loading ? null : _send,
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
                              : const Text('Send Message'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactChannelTile extends StatelessWidget {
  const _ContactChannelTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: profileIconBox(icon, iconColor),
      title: Text(
        title,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: cs.onSurfaceVariant,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
