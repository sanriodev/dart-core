import 'dart:convert';

import 'package:blvckleg_dart_core/adapter/login_auth_adapter.dart';
import 'package:blvckleg_dart_core/models/auth/login_response_model.dart';
import 'package:blvckleg_dart_core/settings/settings.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

dynamic decodeJwt(String jwtString) {
  final parts = jwtString.split('.');

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
    case 3:
      output += '=';
    default:
      throw Exception('Illegal base64url string!');
  }

  return utf8.decode(base64Url.decode(output));
}

bool jwtIsExpired(String rawJwtString) {
  final Map<String, dynamic> json =
      decodeJwt(rawJwtString) as Map<String, dynamic>;
  return DateTime.now().millisecondsSinceEpoch > (json['exp'] as int) * 1000;
}

Future<void> registerDartCore() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(LoginAuthAdapter());
  await Hive.openBox<LoginResponse>('auth');
  final settings = Settings();
  await settings.loadSettings();
}
