// =============================================================================
//  4.  LANGUAGE PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';
import '../cubit/settings_cubit.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: GetIt.I<SettingsCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: cs.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();
            return Scaffold(
              backgroundColor: cs.surfaceContainerHighest,
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SubPageAppBar(title: 'Language')),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(
                        'Choose your preferred language for the Agent NG interface.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SectionLabel('Interface Language')),
                  SliverToBoxAdapter(
                    child: Group(
                      children: state.languages
                          .map(
                            (l) => LangTile(
                              option: l,
                              selected: state.selectedLanguage == l.code,
                              onTap: () => cubit.updateSelectedLanguage(l.code),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
                      child: FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Save Language'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LangOption {
  const LangOption(this.code, this.name, this.flag);
  final String code, name, flag;
}

class LangTile extends StatelessWidget {
  const LangTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final LangOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Text(option.flag, style: const TextStyle(fontSize: 22)),
      title: Text(
        option.name,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: cs.primary, size: 20)
          : Icon(
              Icons.radio_button_unchecked_rounded,
              color: cs.outlineVariant,
              size: 20,
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
