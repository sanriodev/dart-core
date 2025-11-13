import 'package:blvckleg_dart_core/models/auth/login_response_model.dart';
import 'package:blvckleg_dart_core/models/auth/login_response_user.dart';
import 'package:hive/hive.dart';

class LoginAuthAdapter extends TypeAdapter<LoginResponse> {
  @override
  final int typeId = 1;

  @override
  LoginResponse read(BinaryReader reader) {
    final accessToken = reader.readString();
    final refreshToken = reader.readString();

    LoginResponseUser? user;
    try {
      final hasUser = reader.readBool();
      if (hasUser) {
        final raw = reader.read();
        if (raw is Map) {
          final map = raw.cast<String, dynamic>();
          user = LoginResponseUser.fromJson(map);
        }
      }
    } catch (_) {}

    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  @override
  void write(BinaryWriter writer, LoginResponse obj) {
    writer.writeString(obj.accessToken);
    writer.writeString(obj.refreshToken);
    if (obj.user != null) {
      writer.writeBool(true);
      writer.write(obj.user!.toJson());
    } else {
      writer.writeBool(false);
    }
  }
}
