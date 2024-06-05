import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:logging/logging.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this.sharedPreferencesHelper);

  final SharedPreferencesHelper sharedPreferencesHelper;
  final Logger logger = Logger('AuthLocalDataSourceImpl');

  Future<void> cacheVerificationId(String verificationId) async {
    try {
      await sharedPreferencesHelper.setString(
        'verification_id',
        verificationId,
      );
    } catch (e, stackTrace) {
      logger.severe('Failed to cache verification ID', e, stackTrace);
    }
  }

  String? getVerificationId() {
    try {
      return sharedPreferencesHelper.getString('verification_id');
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached verification ID', e, stackTrace);
      return null;
    }
  }

  Future<void> cacheUserDetails(String userId, String userDetailsJson) async {
    try {
      await sharedPreferencesHelper.setString(
        'user_details_$userId',
        userDetailsJson,
      );
    } catch (e, stackTrace) {
      logger.severe('Failed to cache user details', e, stackTrace);
    }
  }

  String? getUserDetails(String userId) {
    try {
      return sharedPreferencesHelper.getString('user_details_$userId');
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached user details', e, stackTrace);
      return null;
    }
  }
}
