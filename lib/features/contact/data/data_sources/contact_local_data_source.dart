import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:logging/logging.dart';

class ContactLocalDataSource {
  ContactLocalDataSource(this.sharedPreferencesHelper);

  final SharedPreferencesHelper sharedPreferencesHelper;
  final Logger logger = Logger('ContactLocalDataSource');

  Future<void> cacheContacts(List<String> contacts) async {
    try {
      await sharedPreferencesHelper.setStringList('cached_contacts', contacts);
    } catch (e, stackTrace) {
      logger.severe('Failed to cache contacts', e, stackTrace);
    }
  }

  List<String>? getCachedContacts() {
    try {
      return sharedPreferencesHelper.getStringList('cached_contacts');
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached contacts', e, stackTrace);
      return null;
    }
  }
}
