class SettingsModel {
  String url;
  bool registrationEnabled;
  String? supportEmail;

  SettingsModel({
    required this.url,
    required this.registrationEnabled,
    this.supportEmail,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      url: json['url']?.toString() ?? 'https://api.example.com/',
      registrationEnabled: json['registrationEnabled'] ?? false,
      supportEmail: json['supportEmail']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'registrationEnabled': registrationEnabled,
      'supportEmail': supportEmail,
    };
  }
}
