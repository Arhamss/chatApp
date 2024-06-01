import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:logging/logging.dart';

class ChatLocalDataSource {
  ChatLocalDataSource(this.sharedPreferencesHelper);

  final SharedPreferencesHelper sharedPreferencesHelper;
  final Logger logger = Logger('ChatLocalDataSourceImpl');

  Future<void> cacheChats(List<String> chats) async {
    try {
      await sharedPreferencesHelper.setStringList('cached_chats', chats);
    } catch (e, stackTrace) {
      logger.severe('Failed to cache chats', e, stackTrace);
    }
  }

  List<String>? getCachedChats() {
    try {
      return sharedPreferencesHelper.getStringList('cached_chats');
    } catch (e, stackTrace) {
      logger.severe('Failed to get cached chats', e, stackTrace);
      return null;
    }
  }
}
