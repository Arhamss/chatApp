import 'package:chat_app/core/shared_preferences_helper.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheVerificationId(String verificationId);
  String? getVerificationId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this.sharedPreferencesHelper);
  final SharedPreferencesHelper sharedPreferencesHelper;

  @override
  Future<void> cacheVerificationId(String verificationId) async {
    await sharedPreferencesHelper.setString('verification_id', verificationId);
  }

  @override
  String? getVerificationId() {
    return sharedPreferencesHelper.getString('verification_id');
  }
}
