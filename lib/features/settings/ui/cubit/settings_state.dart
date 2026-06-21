part of 'settings_cubit.dart';

enum SettingStage { initial, loading, loaded, error }

class SettingsState extends Equatable {
  // Notification states
  final bool pushNotifs;
  final bool emailNotifs;
  final bool smsNotifs;
  final bool newListingAlerts;
  final bool priceDropAlerts;

  // settingsState

  // Appearance
  final ThemeMode themeMode;

  // Privacy
  final bool shareSearchData;
  final bool locationEnabled;

  // Language
  final String selectedLanguage;
  final List<LangOption> languages;

  const SettingsState({
    this.priceDropAlerts = true,
    this.newListingAlerts = true,
    this.smsNotifs = false,
    this.emailNotifs = true,
    this.pushNotifs = true,
    this.themeMode = ThemeMode.dark,
    this.shareSearchData = false,
    this.locationEnabled = true,
    this.selectedLanguage = 'en_NG',
    this.languages = const [
      LangOption('en_NG', 'English (Nigeria)', '🇳🇬'),
      LangOption('en_GB', 'English (UK)', '🇬🇧'),
      LangOption('en_US', 'English (US)', '🇺🇸'),
      LangOption('pcm', 'Nigerian Pidgin', '🇳🇬'),
      LangOption('yo', 'Yorùbá', '🇳🇬'),
      LangOption('ha', 'Hausa', '🇳🇬'),
      LangOption('ig', 'Igbo', '🇳🇬'),
    ],
  });
  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      priceDropAlerts: json['priceDropAlerts'] as bool,
      newListingAlerts: json['newListingAlerts'] as bool,
      smsNotifs: json['smsNotifs'] as bool,
      emailNotifs: json['emailNotifs'] as bool,
      pushNotifs: json['pushNotifs'] as bool,
      themeMode: ThemeMode.values.byName(
        json['themeMode'] as String? ?? ThemeMode.system.name,
      ),
      shareSearchData: json['shareSearchData'] as bool,
      locationEnabled: json['locationEnabled'] as bool,
      selectedLanguage: json['selectedLanguage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priceDropAlerts': priceDropAlerts,
      'newListingAlerts': newListingAlerts,
      'smsNotifs': smsNotifs,
      'emailNotifs': emailNotifs,
      'pushNotifs': pushNotifs,
      'themeMode': themeMode.name,
      'shareSearchData': shareSearchData,
      'locationEnabled': locationEnabled,
      'selectedLanguage': selectedLanguage,
    };
  }

  SettingsState copyWith({
    bool? pushNotifs,
    bool? emailNotifs,
    bool? smsNotifs,
    bool? newListingAlerts,
    bool? priceDropAlerts,
    ThemeMode? themeMode,
    bool? shareSearchData,
    bool? locationEnabled,
    String? selectedLanguage,
  }) {
    return SettingsState(
      pushNotifs: pushNotifs ?? this.pushNotifs,
      emailNotifs: emailNotifs ?? this.emailNotifs,
      smsNotifs: smsNotifs ?? this.smsNotifs,
      newListingAlerts: newListingAlerts ?? this.newListingAlerts,
      priceDropAlerts: priceDropAlerts ?? this.priceDropAlerts,
      themeMode: themeMode ?? this.themeMode,
      shareSearchData: shareSearchData ?? this.shareSearchData,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    pushNotifs,
    emailNotifs,
    smsNotifs,
    newListingAlerts,
    priceDropAlerts,
    themeMode,
    shareSearchData,
    locationEnabled,
    selectedLanguage,
    languages,
  ];
}

class GateWay {
  final SharedPreferences _pref;
  GateWay(this._pref);

  String getSelectedLanguage() =>
      _pref.getString('selectedLanguage') ?? 'en_NG';
}
