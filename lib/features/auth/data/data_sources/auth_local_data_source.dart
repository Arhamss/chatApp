import 'package:chat_app/core/shared_preferences_helper.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheVerificationId(String verificationId);

  String? getVerificationId();

  Future<void> cacheUserDetails(String userId, String userDetailsJson);

  String? getUserDetails(String userId);
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

  @override
  Future<void> cacheUserDetails(String userId, String userDetailsJson) async {
    await sharedPreferencesHelper.setString(
      'user_details_$userId',
      userDetailsJson,
    );
  }

  @override
  String? getUserDetails(String userId) {
    return sharedPreferencesHelper.getString('user_details_$userId');
  }
}
